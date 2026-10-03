---
name: ajuste-resposta
description: Ajusta o tamanho da resposta (curto/longo) e o tom/público (técnico, negócio, didático ou apenas código) do agente, eliminando enrolação, introduções clichês e saudações desnecessárias. Use quando o usuário pedir respostas mais concisas, mais detalhadas, mais técnicas, voltadas para negócio ou puramente código, ou acionar os comandos /curto, /longo, /tech, /biz, /didatico, /code, /padrao ou /calibrar.
---

# Ajuste de Resposta (Sem Rodeios)

Calibre a profundidade e o estilo das respostas do agente com precisão. Elimine enrolação, saudações automáticas e preâmbulos em todos os modos.

---

## Modos Disponíveis

### Eixo 1: Tamanho (Volume de Texto)

| Modo | Objetivo | Regras Estritas |
| :--- | :--- | :--- |
| **`curto`** | Ultra conciso, direto ao ponto (TL;DR). | **Máximo de 3 a 5 bullet points** ou bloco direto de código. Proibido preâmbulos ("Com certeza!", "Aqui está...", "Vou explicar"). Sem conclusão genérica ("Espero que ajude!"). |
| **`longo`** | Detalhado, aprofundado e completo. | Análise exaustiva cobrindo arquitetura, casos de borda (*edge cases*), alternativas descartadas, impactos colaterais e passo a passo estruturado. |
| **`padrao`** | Equilibrado / Padrão. | Resposta fluida sem restrição forçada de limites. |

### Eixo 2: Tom (Perspectiva e Linguagem)

| Modo | Público-Alvo | Foco Principal |
| :--- | :--- | :--- |
| **`tech`** | Desenvolvedor Sênior / Arquiteto | Detalhes de baixo nível, contratos de tipos, complexidade de tempo/espaço ($O(n)$), comandos de terminal, logs e código idiomático. Zero metáforas simplórias ou linguagem de marketing. |
| **`biz`** | Product Manager / Diretoria / Clientes | Impacto no produto, retorno de investimento (ROI), métricas operacionais, mitigação de riscos técnicos, prazos e viabilidade econômica. Sem termos herméticos sem explicação prática. |
| **`didatico`** | Desenvolvedor Júnior / Estudante / Mentoria | Ensina o *porquê* antes do *como*. Usa analogias práticas, constrói o raciocínio em etapas e alerta para armadilhas comuns. |
| **`code`** | Automação / Copiar e colar direto | **100% código/diffs/comandos**. Zero linhas de texto conversacional antes ou depois dos blocos. Apenas comentários essenciais inline dentro do código. |

---

## Matriz de Cruzamento Rápido

Quando o usuário combinar tamanho e tom (ex: `/calibrar tech curto` ou `$tom biz longo`):

- **Tech + Curto**: Lista de 3 bullets técnicos precisos (ex: tipos, stack, complexidade) + snippet de código essencial.
- **Tech + Longo**: Guia de engenharia exaustivo com arquitetura, diagramas conceituais, testes e benchmarks.
- **Biz + Curto**: Resumo executivo de 3 bullets contendo impacto, prazo e risco.
- **Biz + Longo**: Relatório executivo completo com análise de viabilidade, trade-offs de mercado e plano de rollout.
- **Didático + Curto**: Conceito chave resumido com uma analogia simples e exemplo de uso.
- **Didático + Longo**: Tutorial didático passo a passo dissecando a mecânica interna da tecnologia.
- **Code**: Sobrescreve o tamanho para o mínimo necessário para o código ser executável e funcional.

---

## Comandos Conversacionais Rápidos (`$tom`)

Além dos slash commands em `commands/`, o agente reconhece sintaxe rápida no chat:

- `$tom curto` — ativa modo curto
- `$tom longo` — ativa modo longo
- `$tom tech` — ativa modo técnico
- `$tom biz` — ativa modo negócio
- `$tom didatico` — ativa modo didático
- `$tom code` — ativa apenas código
- `$tom reset` ou `$tom padrao` — restaura modo normal
- `$tom <tom> <tamanho>` — ex: `$tom tech curto`, `$tom biz longo`

Para referência completa de limites e diretrizes, consulte [references/modos.md](references/modos.md).
