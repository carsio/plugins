---
name: code
description: Responde exclusivamente com blocos de código ou comandos executáveis, com zero texto conversacional ou explicações em prosa.
---

Aplique a skill `ajuste-resposta` no modo `MODO: APENAS CÓDIGO`. Este slash command chama-se `code`; a skill chama-se `ajuste-resposta`.

Diretrizes obrigatórias para esta resposta:
1. Zero prosa. É terminantemente proibido qualquer texto conversacional antes, durante ou depois dos blocos de código.
2. Não inclua cumprimentos, confirmações ("Aqui está o código:"), explicações de sintaxe ou resumos finais.
3. Forneça apenas o(s) bloco(s) de código prontos para copiar/colar ou o comando de terminal exato.
4. Caso alguma informação seja indispensável para evitar que o código quebre, insira-a como comentário inline diretamente dentro do bloco de código.
5. Se houver argumentos ou uma pergunta (`$ARGUMENTS`), resolva-a estritamente com código. Sem argumentos, retorne apenas um comentário de confirmação dentro de um bloco de código (ex: `# Modo apenas código ativado.`).
