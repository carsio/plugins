---
name: diagnosticar
description: "Inspeciona o projeto e a máquina do usuário (somente leitura), verificando dependências, portas, variáveis de ambiente e recomendando configurações."
---

Aplique a skill `run-forrest-run` em modo somente leitura (`$forrest check $ARGUMENTS`). Este slash command chama-se `diagnosticar`; a skill orquestradora chama-se `run-forrest-run`.

Use o subagente `forrest` (ou execute a inspeção diretamente) para:
1. Identificar a stack, gerenciador de pacotes, versões exigidas de runtime, variáveis de ambiente e serviços externos do projeto.
2. Verificar na máquina do usuário quais ferramentas/runtimes estão instalados (`[✓]`), divergentes (`[!]`) ou ausentes (`[✗]`), além de conflitos de portas.
3. Entregar o relatório completo com recomendações de configuração e o plano passo a passo do que precisaria ser feito para rodar o projeto.

Não altere arquivos e não instale pacotes neste comando; ao final, pergunte se o usuário deseja executar o plano apresentado.
