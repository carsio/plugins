---
name: sharingan-brand
description: Mapear e alterar identidade de uma replica ou integracao — nome, marca, cores, textos, imagens, dominios e identificadores — sem remover atribuicoes obrigatorias. Use para $sharingan brand, rebrandear ou personalizar uma variante.
---

# Identidade Sharingan

Monte um mapa da identidade antiga para a nova antes de substituir. Delegue o inventario e o mapa ao subagente `obito`. Nao invente uma marca definitiva se o usuario ainda nao a tiver fornecido. O slash command desta skill e `/sharingan-rebrand`, nao `/sharingan-brand`.

Preserve atribuicoes, avisos de copyright e termos obrigatorios. Aplique a regra `sharingan-safety` ao editar manifests, instaladores e arquivos de configuracao.

## Mapa de identidade

Considere separadamente:

- nome humano do produto;
- nome de pacote e namespaces de codigo;
- IDs tecnicos, slugs, nomes de banco, containers e servicos;
- dominios, emails, links sociais e informacoes de suporte;
- logos, favicons, icones, cores, imagens e textos;
- titulos, descricoes, manifests, instaladores e documentacao.

## Substituicao

Faca substituicoes estruturadas e sensiveis ao contexto. Nao troque fragmentos genericos, nomes de dependencias externas, protocolos, checksums, migracoes antigas ou contratos publicos sem analisar o impacto. Preserve a compatibilidade quando uma alteracao de identificador exigir migracao.

Se o usuario ainda nao tiver fornecido a nova identidade, replique e entregue um inventario objetivo dos pontos de personalizacao.

Opcoes livres como `--name`, `--logo`, `--primary`, `--domain`, `--support-email` e `--description` podem ser usadas quando fizerem sentido para o projeto. `--dry-run` entrega so o mapa, sem editar arquivos.
