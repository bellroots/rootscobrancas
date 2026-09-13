# Plano de testes — ROOTS Mobile

## 1. Acesso
- Criar conta, confirmar e-mail quando aplicável, entrar, sair e reabrir o app.
- Confirmar que um usuário não enxerga dados de outro usuário (RLS).

## 2. Clientes
- Criar, pesquisar, editar e abrir detalhes.
- Validar CPF/CNPJ, telefone, endereço e campos vazios durante os testes de UX.

## 3. Empréstimos
- Criar casos com juros 0%, Price e juros simples.
- Conferir quantidade, valor e datas das parcelas.
- Conferir virada de mês em datas como 29, 30 e 31.

## 4. Pagamentos
- Pagamento total e parcial.
- PIX, dinheiro, transferência, débito, crédito e cheque.
- Confirmar atualização de `parcelas`, `pagamentos` e `pagamento_parcelas`.

## 5. Atrasos
- Parcela vencida sem multa.
- Mora diária e mensal.
- Multa percentual e fixa.

## 6. Cobranças e relatórios
- Comparar valores do app com consultas no Supabase.
- Conferir carteira aberta, vencido, recebido, despesas e inadimplência.

## 7. Módulos auxiliares
- Despesas, rotas, etiquetas e modelos de documentos.
- Validar estados vazios, listas grandes e teclado.

## 8. Dispositivos
- Android real e iPhone real.
- Tela pequena e tela grande, modo avião, internet lenta e retomada do app.

## Pendências intencionais
Colaboradores, Empresa/Configuração, Premium, Notificações, Integrações e Ajuda/Suporte precisam de definição/tabelas de backend antes de serem ativados.
