-- =========================================================
-- BERLAN ROOTS — Schema inicial (Supabase / PostgreSQL)
-- Isolamento de dados por usuário via Row Level Security (RLS)
-- =========================================================

-- Extensão para gerar UUIDs
create extension if not exists "pgcrypto";

-- ---------------------------------------------------------
-- Função utilitária: atualizar updated_at automaticamente
-- ---------------------------------------------------------
create or replace function public.set_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

-- ---------------------------------------------------------
-- ROTAS DE ATENDIMENTO
-- ---------------------------------------------------------
create table public.rotas (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  nome text not null,
  regiao text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- ---------------------------------------------------------
-- ETIQUETAS
-- ---------------------------------------------------------
create table public.etiquetas (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  nome text not null,
  cor text default '#7C3AED',
  created_at timestamptz not null default now()
);

-- ---------------------------------------------------------
-- CLIENTES
-- ---------------------------------------------------------
create table public.clientes (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  nome text not null,
  tipo_pessoa text not null default 'fisica' check (tipo_pessoa in ('fisica','juridica')),
  documento text,                    -- CPF ou CNPJ
  rg_ie text,
  data_nascimento date,
  logradouro text,
  numero text,
  complemento text,
  bairro text,
  cidade text,
  estado text,
  cep text,
  telefone_principal text,
  telefone_secundario text,
  email text,
  profissao text,
  renda_mensal numeric(12,2),
  observacoes text,
  rota_id uuid references public.rotas(id) on delete set null,
  ativo boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index idx_clientes_user on public.clientes(user_id);
create index idx_clientes_nome on public.clientes using gin (to_tsvector('portuguese', nome));

create trigger trg_clientes_updated
  before update on public.clientes
  for each row execute function public.set_updated_at();

-- Relação N:N entre clientes e etiquetas
create table public.cliente_etiquetas (
  cliente_id uuid not null references public.clientes(id) on delete cascade,
  etiqueta_id uuid not null references public.etiquetas(id) on delete cascade,
  primary key (cliente_id, etiqueta_id)
);

-- ---------------------------------------------------------
-- EMPRÉSTIMOS
-- ---------------------------------------------------------
create table public.emprestimos (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  cliente_id uuid not null references public.clientes(id) on delete cascade,
  valor_principal numeric(12,2) not null,
  taxa_juros_mensal numeric(6,3) not null default 0,
  quantidade_parcelas integer not null default 1,
  valor_parcela numeric(12,2) not null,
  data_primeiro_vencimento date not null,
  forma_pagamento_padrao text,
  sistema_calculo text not null default 'price' check (sistema_calculo in ('price','juros_simples')),
  taxa_juros_mora numeric(6,3) default 0,     -- % ao mês ou ao dia (definir convenção)
  tipo_mora text default 'mensal' check (tipo_mora in ('diaria','mensal')),
  multa_atraso_valor numeric(12,2) default 0,
  multa_atraso_tipo text default 'percentual' check (multa_atraso_tipo in ('percentual','fixo')),
  status text not null default 'ativo' check (status in ('ativo','quitado','vencido','renegociado','cancelado')),
  observacoes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index idx_emprestimos_user on public.emprestimos(user_id);
create index idx_emprestimos_cliente on public.emprestimos(cliente_id);

create trigger trg_emprestimos_updated
  before update on public.emprestimos
  for each row execute function public.set_updated_at();

-- ---------------------------------------------------------
-- PARCELAS
-- ---------------------------------------------------------
create table public.parcelas (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  emprestimo_id uuid not null references public.emprestimos(id) on delete cascade,
  numero integer not null,
  data_vencimento date not null,
  valor_original numeric(12,2) not null,
  valor_pago numeric(12,2) not null default 0,
  status text not null default 'a_vencer' check (status in ('a_vencer','paga','vencida','renegociada','parcial')),
  data_pagamento date,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index idx_parcelas_user on public.parcelas(user_id);
create index idx_parcelas_emprestimo on public.parcelas(emprestimo_id);
create index idx_parcelas_vencimento on public.parcelas(data_vencimento);

create trigger trg_parcelas_updated
  before update on public.parcelas
  for each row execute function public.set_updated_at();

-- ---------------------------------------------------------
-- PAGAMENTOS
-- ---------------------------------------------------------
create table public.pagamentos (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  cliente_id uuid not null references public.clientes(id) on delete cascade,
  emprestimo_id uuid not null references public.emprestimos(id) on delete cascade,
  valor_pago numeric(12,2) not null,
  forma_pagamento text not null check (forma_pagamento in ('dinheiro','pix','cartao_credito','cartao_debito','cheque','transferencia')),
  data_pagamento date not null default current_date,
  observacao text,
  created_at timestamptz not null default now()
);

-- Relação N:N: um pagamento pode quitar mais de uma parcela
create table public.pagamento_parcelas (
  pagamento_id uuid not null references public.pagamentos(id) on delete cascade,
  parcela_id uuid not null references public.parcelas(id) on delete cascade,
  valor_aplicado numeric(12,2) not null,
  primary key (pagamento_id, parcela_id)
);

create index idx_pagamentos_user on public.pagamentos(user_id);
create index idx_pagamentos_cliente on public.pagamentos(cliente_id);

-- ---------------------------------------------------------
-- DESPESAS
-- ---------------------------------------------------------
create table public.despesas (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  descricao text not null,
  categoria text not null default 'outros',
  valor numeric(12,2) not null,
  data_referencia date not null,
  situacao text not null default 'pendente' check (situacao in ('paga','pendente')),
  observacao text,
  created_at timestamptz not null default now()
);

create index idx_despesas_user on public.despesas(user_id);

-- ---------------------------------------------------------
-- MODELOS DE DOCUMENTO
-- ---------------------------------------------------------
create table public.documentos_modelo (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  nome text not null,
  tipo text not null default 'personalizado' check (tipo in ('contrato_mutuo','recibo_pagamento','compromisso_pagamento','personalizado')),
  conteudo text not null,       -- template com placeholders, ex: {{cliente.nome}}
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create trigger trg_documentos_updated
  before update on public.documentos_modelo
  for each row execute function public.set_updated_at();

-- =========================================================
-- ROW LEVEL SECURITY — isolamento total por usuário
-- =========================================================

alter table public.rotas enable row level security;
alter table public.etiquetas enable row level security;
alter table public.clientes enable row level security;
alter table public.cliente_etiquetas enable row level security;
alter table public.emprestimos enable row level security;
alter table public.parcelas enable row level security;
alter table public.pagamentos enable row level security;
alter table public.pagamento_parcelas enable row level security;
alter table public.despesas enable row level security;
alter table public.documentos_modelo enable row level security;

-- Política padrão: cada usuário só enxerga/edita o que é dele.
-- (repetida por tabela porque cada uma tem sua própria policy)

create policy "rotas_isolamento" on public.rotas
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "etiquetas_isolamento" on public.etiquetas
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "clientes_isolamento" on public.clientes
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "emprestimos_isolamento" on public.emprestimos
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "parcelas_isolamento" on public.parcelas
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "pagamentos_isolamento" on public.pagamentos
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "despesas_isolamento" on public.despesas
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "documentos_modelo_isolamento" on public.documentos_modelo
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- Tabelas de relação (N:N) não têm user_id próprio — a segurança vem
-- da tabela "pai" através de uma subconsulta.

create policy "cliente_etiquetas_isolamento" on public.cliente_etiquetas
  for all using (
    exists (select 1 from public.clientes c where c.id = cliente_id and c.user_id = auth.uid())
  ) with check (
    exists (select 1 from public.clientes c where c.id = cliente_id and c.user_id = auth.uid())
  );

create policy "pagamento_parcelas_isolamento" on public.pagamento_parcelas
  for all using (
    exists (select 1 from public.pagamentos p where p.id = pagamento_id and p.user_id = auth.uid())
  ) with check (
    exists (select 1 from public.pagamentos p where p.id = pagamento_id and p.user_id = auth.uid())
  );

-- =========================================================
-- FIM DO SCHEMA INICIAL
-- =========================================================
