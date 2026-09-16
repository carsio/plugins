# Não grita

Rules para o agente nunca assinar commits, merge requests ou qualquer texto com o próprio nome, nem mencionar uso de IA.

## Rules

Todas com `alwaysApply: true`:

- `sem-assinatura-git` — commits, tags e trailers Git
- `sem-mencao-ia-mr` — MR, PR, issues e reviews
- `escrita-sem-nome` — qualquer texto, sem se identificar como IA

## Skill e comando

Os nomes são diferentes de propósito: agentes se perdem quando o slash command e a skill têm o mesmo nome.

| Tipo | Nome |
| --- | --- |
| Skill | `nao-grita` |
| Slash command | `aplica-nao-grita` |

A skill `nao-grita` reforça a política nos agentes que carregam skills. O comando `/aplica-nao-grita` aplica a mesma skill sem reutilizar o nome.
