---
name: padrao
description: Restaura o tamanho e o tom das respostas para o comportamento padrão do agente.
---

Aplique a skill `ajuste-resposta` no modo `RESET: PADRÃO`. Este slash command chama-se `padrao`; a skill chama-se `ajuste-resposta`.

Diretrizes:
1. Desative todas as restrições artificiais de tamanho (`curto`, `longo`) e de tom (`tech`, `biz`, `didatico`, `code`) ativadas anteriormente.
2. Retorne ao estilo nativo, equilibrado e fluido de conversação do agente.
3. Se houver argumentos ou uma pergunta (`$ARGUMENTS`), responda de modo convencional. Sem argumentos, confirme brevemente o restabelecimento do modo padrão.
