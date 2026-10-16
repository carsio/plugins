---
name: rodar
description: "Analisa o projeto e a máquina, exibe recomendações com gate de confirmação e coloca o projeto para rodar."
---

Aplique a skill `run-forrest-run` no modo completo (`$forrest run $ARGUMENTS`). Este slash command chama-se `rodar`; a skill orquestradora chama-se `run-forrest-run`.

Siga rigorosamente a ordem:
1. Analise o projeto (stack, lockfile, scripts, `.env.example`, serviços/Docker) e diagnostique a máquina do usuário (runtimes, versões, portas livres, dependências instaladas).
2. Apresente o diagnóstico, as recomendações de configuração e o **Gate de Confirmação** explicando exatamente o que será feito na máquina e no projeto.
3. Aguarde a confirmação explícita do usuário.
4. Após confirmado, configure o ambiente, instale as dependências necessárias, suba os serviços de apoio e inicie o projeto, validando se subiu corretamente.
