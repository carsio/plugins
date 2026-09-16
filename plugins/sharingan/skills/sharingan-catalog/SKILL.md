---
name: sharingan-catalog
description: Inventariar um projeto autorizado e catalogar funcionalidades com IDs, fluxos, arquivos, dependencias e mapa de acoplamento. Use para $sharingan list, inspect, catalogar capacidades ou explicar uma funcionalidade ponta a ponta. Nao altere codigo.
---

# Catalogo Sharingan

Somente leitura. Reconstrua as funcionalidades a partir do codigo, testes, rotas, banco, configuracoes e documentacao; nao dependa apenas do README.

Delegue varreduras grandes ao subagente `kakashi`. Aplique as exclusoes e checagens de permissao da skill `sharingan` antes de ler segredos ou dados de producao. Os slash commands desta skill sao `/sharingan-list` e `/sharingan-inspect`, nao `/sharingan-catalog`.

## Inventario

Inspecione a arvore completa, incluindo arquivos ocultos, submodulos e links simbolicos. Leia primeiro as instrucoes do repositorio, especialmente `AGENTS.md`, e identifique:

- linguagens, gerenciadores de pacotes, workspaces e pontos de entrada;
- arquivos rastreados e arquivos locais relevantes;
- configuracoes de build, teste, lint, CI, containers e deploy;
- nomes de pacote, namespaces, IDs de aplicativo, dominios, URLs e variaveis;
- textos, logos, icones, cores, metadados, documentacao e fixtures com a marca antiga;
- integracoes externas que precisam continuar intactas ou ser reconfiguradas.

Registre riscos: destino existente, arquivos grandes, submodulos privados, LFS, codigo gerado e referencias que nao podem ser renomeadas mecanicamente.

## Catalogar funcionalidades

Separe capacidades visiveis ao usuario, capacidades administrativas, infraestrutura compartilhada e fundacoes tecnicas.

Para cada funcionalidade, informe:

- ID e nome curto;
- objetivo e valor para o usuario;
- atores e fluxo principal;
- telas, comandos, atalhos ou endpoints envolvidos;
- arquivos e pontos de entrada de frontend, backend e camada nativa;
- estado, banco, eventos, filas ou armazenamento utilizados;
- dependencias internas, externas e funcionalidades acopladas;
- configuracoes, variaveis de ambiente, permissoes e integracoes;
- testes existentes e comportamentos de erro importantes;
- pontos de identidade visual ou textual que podem ser personalizados;
- conjunto minimo de arquivos e dependencias para transplante;
- dificuldade, riscos e estrategia recomendada: copiar, adaptar ou reimplementar.

Apresente primeiro um indice agrupado por dominio e depois fichas rastreaveis ate os arquivos analisados. Inclua um mapa de dependencias entre funcionalidades para deixar claro quando uma escolha exige componentes compartilhados. Marque como hipotese qualquer comportamento sem evidencia suficiente.

Se o usuario pedir um artefato persistente, grave o catalogo em Markdown no caminho solicitado ou, por padrao, em `docs/sharingan/catalogo-funcionalidades.md` do projeto de destino. Caso contrario, entregue o catalogo na conversa.

## Inspecionar

Para `$sharingan inspect` ou pedido equivalente, aprofunde uma unica ficha ponta a ponta: fluxo, arquivos, configuracoes, testes, pontos de personalizacao e fechamento minimo de dependencias.
