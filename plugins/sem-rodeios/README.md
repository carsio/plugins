# Sem Rodeios

Plugin com comandos rápidos para ajustar instantaneamente o **tamanho** (escrever mais ou escrever menos) e o **tom/modo de falar** (técnico, negócio, didático ou apenas código) do agente, eliminando enrolação, saudações automáticas e introduções clichês.

Compatível com **Cursor**, **Claude Code** e **Bithub**.

---

## Comandos Rápidos

| Comando | Tipo | O que faz |
| :--- | :--- | :--- |
| `/curto` | Tamanho | Resposta ultra concisa (TL;DR). Máximo de 3 a 5 bullets ou código direto. Sem enrolação. |
| `/longo` | Tamanho | Resposta exaustiva, aprofundada, com arquitetura, casos de borda e passo a passo. |
| `/tech` | Tom | Perspectiva de Engenheiro Sênior: foco em código, arquitetura, tipos, performance e terminal. |
| `/biz` | Tom | Perspectiva executiva/PM: foco em ROI, valor de negócio, métricas, riscos e prazos. |
| `/didatico` | Tom | Perspectiva de mentor: raciocínio em etapas, analogias claras e explicação dos conceitos. |
| `/code` | Especial | 100% código/diffs/comandos. Zero texto explicativo ou prosa conversacional. |
| `/padrao` | Controle | Restaura o comportamento padrão, desativando restrições anteriores. |
| `/calibrar` | Misto | Permite passar parâmetros combinados (ex: `/calibrar tech curto`). |

---

## Exemplos de Uso

### 1. Pergunta com comando direto
```text
/curto O que é idempotência em APIs REST?
```
O agente responde em até 3 bullet points objetivos.

### 2. Visão de Negócio
```text
/biz Por que devemos migrar de monólito para microsserviços?
```
O agente foca em custos de infraestrutura, autonomia dos times e time-to-market em vez de detalhes de protocolos.

### 3. Apenas Código
```text
/code docker-compose para rodar postgres e redis
```
O agente gera exclusivamente o bloco de código yaml pronto para salvar.

---

## Sintaxe Conversacional (`$tom`)

Se preferir não usar slash commands, use a sintaxe rápida no chat:

- `$tom curto`
- `$tom longo`
- `$tom tech`
- `$tom biz`
- `$tom didatico`
- `$tom code`
- `$tom tech curto`
- `$tom reset`

---

## Estrutura do Plugin

- `commands/` — slash commands prontos para Claude Code, Cursor e Bithub.
- `skills/ajuste-resposta/` — skill orquestradora com as diretrizes e limites rígidos de cada modo.
- `rules/calibracao-resposta.mdc` — regra global sempre ativa que reconhece termos como "seja curto", "escreve menos", "mais técnico" ou "para diretoria" mesmo sem digitar o comando.
