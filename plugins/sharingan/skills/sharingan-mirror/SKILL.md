---
name: sharingan-mirror
description: Replicar por completo um projeto autorizado em um destino novo, sem historico Git, segredos ou artefatos descartaveis. Use para $sharingan mirror, clonar, espelhar ou criar uma variante completa. Nao use para copiar software sem permissao.
---

# Espelho Sharingan

Replique o projeto com fidelidade primeiro; personalize depois. O resultado deve manter o comportamento original, salvo quando o usuario pedir mudancas funcionais.

Siga as checagens de permissao e exclusoes da skill `sharingan`. Use o subagente `danzo` para a copia quando o destino estiver definido. Depois de espelhar, ofereca `sharingan-brand` e `sharingan-validate`.

## Antes de copiar

Identifique origem (pasta local ou repositorio Git), destino, novo nome e se deve incluir alteracoes locais nao commitadas. Pergunte apenas quando uma escolha ausente alterar materialmente o resultado ou houver risco de sobrescrever dados.

Procure `LICENSE`, `COPYING`, avisos de copyright e regras do repositorio. Prossiga quando o usuario for dono do codigo, tiver autorizacao, ou a licenca permitir a reutilizacao pretendida. Preserve atribuicoes, avisos e termos obrigatorios.

Nunca transfira automaticamente:

- `.git` e historico do repositorio original;
- `.env`, chaves, tokens, certificados, credenciais ou dados pessoais;
- dependencias instaladas, caches, logs, binarios e artefatos de build;
- backups, dumps ou dados de producao.

Mantenha arquivos de exemplo, como `.env.example`, depois de confirmar que nao contem valores reais.

## Replicar

Para origem Git remota, clone em uma area temporaria e use o commit ou ref solicitado. Para origem local, preserve a arvore relevante e inclua alteracoes nao commitadas somente quando isso tiver sido solicitado ou estiver claro no pedido.

Crie o destino apenas depois de confirmar que ele nao sobrescrevera trabalho existente. Copie codigo-fonte, testes, configuracoes, scripts, assets e documentacao necessarios. Preserve dotfiles, permissoes executaveis e links simbolicos quando a plataforma permitir.

Inicialize um novo repositorio Git somente se o usuario pedir ou se isso fizer parte explicita da entrega. Nunca mantenha o remoto `origin` do projeto copiado como destino de publicacao da nova variante.

`--dry-run` produz apenas o plano de copia, sem criar pastas nem gravar arquivos.
