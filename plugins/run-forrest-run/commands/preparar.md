---
name: preparar
description: "Verifica dependências, recomenda configurações da máquina e instala tudo após confirmação, deixando o projeto pronto para rodar."
---

Aplique a skill `run-forrest-run` no modo de preparação (`$forrest setup $ARGUMENTS`). Este slash command chama-se `preparar`; a skill orquestradora chama-se `run-forrest-run`.

Siga rigorosamente a ordem:
1. Faça o diagnóstico somente leitura do projeto e da máquina do usuário.
2. Apresente as recomendações de configuração e o **Gate de Confirmação** detalhando o que será instalado e configurado.
3. Aguarde a confirmação explícita do usuário.
4. Após confirmado, configure a máquina/runtimes, gere ou atualize o `.env` sem sobrescrever segredos existentes, instale as dependências do projeto e prepare os serviços/migrations, informando ao final o comando exato para iniciar a aplicação.
