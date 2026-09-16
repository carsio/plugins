# Estou cansado, chefe

Plugin com a imagem de John Coffey e um hook que tenta perceber quando a cota de uso acabou. Aí o agente fala como no filme *A Espera de um Milagre*.

## Hook

Instala em:

- Cursor: `sessionStart`, `beforeSubmitPrompt`, `postToolUseFailure`, `stop`
- Claude Code: `SessionStart`, `UserPromptSubmit`, `PostToolUseFailure`, `Stop`

O script lê o payload do hook e o cache de uso do Bithub (`com.bithub.app/usage`). Se achar limite em 0%, 429 ou cota esgotada, injeta uma fala começando por **Estou cansado, chefe.**
