# Berlan Roots

Sistema de controle de empréstimos e clientes — projeto de propriedade de
Berlan Conceição dos Santos.

Aplicativo para organizar empréstimos concedidos a clientes: cadastro de
clientes, empréstimos com cálculo automático de parcelas (Price ou Juros
Simples), controle de pagamentos, e juros de mora / multa para parcelas em
atraso. Múltiplos usuários podem usar o mesmo sistema, cada um enxergando
apenas os próprios dados (isolamento via Row Level Security no Supabase).

## Estrutura do projeto

```
berlan-roots/
├── web/
│   └── index.html        # App (HTML + CSS + JS puro, sem build necessário)
├── database/
│   └── schema.sql         # Schema completo do Supabase (tabelas + RLS)
├── docs/                  # Especificações e anotações do projeto
└── README.md
```

## Como rodar localmente

O app não depende de build tools — é um único arquivo HTML.

1. Abra `web/index.html` direto no navegador, ou
2. Sirva a pasta com qualquer servidor estático, por exemplo:
   ```
   npx serve web
   ```

## Backend (Supabase)

1. Crie um projeto no [Supabase](https://supabase.com)
2. No **SQL Editor**, rode o conteúdo de `database/schema.sql`
3. Copie a **Project URL** e a **anon/publishable key** do seu projeto
   (Project Settings → API)
4. Atualize as constantes `SUPABASE_URL` e `SUPABASE_ANON_KEY` no topo do
   `<script>` em `web/index.html`

O isolamento de dados entre usuários é feito por Row Level Security (RLS):
cada tabela tem uma política que só libera acesso às linhas onde
`user_id = auth.uid()`.

## Roadmap

- [x] Autenticação (login/cadastro)
- [x] Cadastro e listagem de clientes
- [x] Cadastro de empréstimo com cálculo automático de parcelas
- [x] Registro de pagamentos
- [x] Juros de mora e multa por atraso
- [ ] Quitação antecipada
- [ ] Renegociação de empréstimo
- [ ] Geração de contrato/recibo (PDF)
- [ ] Relatórios (carteira, inadimplência, ranking de clientes)
- [ ] Empacotamento como app instalável (Capacitor) para Android/iOS

## Empacotamento futuro (app instalável)

Planejado usar **Capacitor** para gerar os apps nativos Android/iOS a partir
deste mesmo código web, com build automatizado via **GitHub Actions**
(incluindo runner macOS para o build iOS, sem precisar de um Mac físico).

## Propriedade

Projeto original de Berlan Conceição dos Santos. Uso e reprodução sem
autorização expressa são proibidos.

## Aplicativo mobile

A nova implementação mobile está em `mobile/`, usando React Native + Expo + o mesmo Supabase.
O diretório `web/` permanece apenas como protótipo/legado e referência das regras já implementadas.
Consulte `mobile/README.md` e `mobile/TEST_PLAN.md` para instalação e testes.
