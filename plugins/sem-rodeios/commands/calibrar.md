---
name: calibrar
description: Calibra o tamanho e o tom da resposta combinando dimensões (ex: /calibrar tech curto, /calibrar biz longo).
---

Aplique a skill `ajuste-resposta`. Este slash command chama-se `calibrar`; a skill orquestradora chama-se `ajuste-resposta`.

Interprete os argumentos (`$ARGUMENTS`) procurando combinações das seguintes opções:
- **Tamanho**:
  - `curto` (tldr, breve, conciso, menos)
  - `longo` (fundo, detalhado, mais, extensivo)
  - `padrao` (reset, normal)
- **Tom**:
  - `tech` (tecnico, engenharia, dev)
  - `biz` (negocio, executivo, produto, pm)
  - `didatico` (mentor, explicativo, professor)
  - `code` (apenas-codigo, codigo)

Exemplos de uso:
- `/calibrar tech curto Como funciona o Garbage Collector em Go?`
- `/calibrar biz longo Qual o impacto de migrar para Postgres?`
- `/calibrar code criar express server com rota health`
- `/calibrar padrao`

Se houver uma pergunta após os modificadores, responda-a aplicando a combinação exata solicitada. Se não houver pergunta, confirme os modos ativos na sessão.
