# Não grita

Rules para o agente nunca assinar commits, merge requests ou qualquer texto com o próprio nome, nem mencionar uso de IA.

## Rules

Todas com `alwaysApply: true`:

- `sem-assinatura-git` — commits, tags e trailers Git
- `sem-mencao-ia-mr` — MR, PR, issues e reviews
- `escrita-sem-nome` — qualquer texto, sem se identificar como IA

A skill `nao-grita` reforça a mesma política nos agentes que carregam skills.
