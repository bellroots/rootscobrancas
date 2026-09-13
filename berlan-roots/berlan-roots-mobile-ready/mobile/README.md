# ROOTS Cobranças — aplicativo mobile

Aplicativo móvel em React Native + Expo, usando o Supabase já existente no projeto ROOTS.

## O que está implementado antes da fase de testes

- Login e cadastro via Supabase Auth
- Dashboard com carteira, recebido, saldo em aberto e vencido
- Clientes: listagem, busca, cadastro, edição e detalhe
- Empréstimos: criação com Price ou juros simples, geração automática de parcelas e detalhe
- Pagamentos: registro por parcela e vínculo em `pagamento_parcelas`
- Cobranças: parcelas pendentes e vencidas
- Relatórios: carteira, vencido, recebido, despesas e inadimplência
- Despesas: cadastro e listagem
- Rotas e etiquetas: consulta e cadastro básico de rotas
- Documentos: cadastro/listagem de modelos
- Mais: acesso às demais categorias do produto
- Telas reservadas para Colaboradores, Empresa/Configuração, Premium, Notificações, Integrações e Ajuda/Suporte

As telas reservadas não fingem funcionalidade: o schema atual não possui tabelas próprias para esses módulos.

## Rodar para testar

1. Instale Node.js LTS.
2. Entre nesta pasta e rode `npm install`.
3. Copie `.env.example` para `.env` e informe a URL e a chave pública/anon do Supabase.
4. Rode `npm start`.
5. Abra pelo Expo Go no Android/iPhone ou por emulador.

## Banco de dados

Este app foi feito para o schema existente em `berlan-roots/database/schema.sql`.

## Próxima fase

Na etapa de testes devem ser validados: autenticação real, RLS, criação/edição de clientes, geração de parcelas, pagamentos parciais/totais, atrasos, datas, arredondamentos, relatórios e comportamento em Android/iOS.
