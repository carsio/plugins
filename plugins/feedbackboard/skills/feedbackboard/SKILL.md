---
name: feedbackboard
description: Consultar e atualizar feedbacks do FeedbackBoard via MCP — listar projetos, filtrar relatos, abrir detalhes com anexos e mover cards no Kanban. Use quando o usuário pedir feedbacks, bugs reportados, fila do Kanban ou status de relatos no FeedbackBoard.
---

# FeedbackBoard

Use as tools do MCP `feedbackboard` (já autenticadas com o token do plugin).

## Fluxo

1. `list_projects` — descubra `projectId` / `projectToken` se ainda não souber o projeto.
2. `summarize_project` — visão rápida da fila por status e tipo.
3. `list_feedbacks` — filtre por `tipo` (bug | melhoria | outro), `status` (Reportado | Priorizado | Fazendo | Pronto), período ou texto.
4. `get_feedback` — antes de corrigir um bug: descrição completa, página, elemento apontado e anexos.
5. `update_feedback` — mova o card ou registre `resolucao`. A descrição original do usuário não muda por aqui.

## Regras

- Informe `projectId` **ou** `projectToken` nas tools que pedem projeto.
- Não invente IDs: liste antes de atualizar.
- Ao fechar um relato, preencha `resolucao` curta e objetiva.
