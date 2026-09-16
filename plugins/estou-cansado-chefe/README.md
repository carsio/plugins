# Estou cansado, chefe

Plugin com o subagente **John Coffey**. Quando o uso está alto, a cota começa a ficar perto do fim ou a janela de contexto chega perto do limite, toca o áudio *Eu estou cansado chefe* e responde como em *A Espera de um Milagre*.

Não dispara se a cota já tiver acabado (0%, 429, limite esgotado).

## Audio

O áudio fica na skill:

`skills/estou-cansado-chefe/assets/eu-estou-cansado-chefe.wav`

Para tocar no sistema:

```text
powershell -NoProfile -ExecutionPolicy Bypass -File skills/estou-cansado-chefe/scripts/play.ps1 -Wait
```

## Subagente

- Nome: **John Coffey**
- Id: `john-coffey`

## Hook

Instala em:

- Cursor: `sessionStart`, `beforeSubmitPrompt`, `preCompact`
- Claude Code: `SessionStart`, `UserPromptSubmit`, `PreCompact`

O script lê o payload do hook e o cache de uso do Bithub (`com.bithub.app/usage`). Dispara se ainda restar cota e ela estiver em 40% ou menos, ou se o evento for compactação de contexto. Intervalo mínimo entre toques: 12 minutos.
