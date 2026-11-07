# Gestão de Concessionária (Haskell)

Projeto semestral de **Programação Funcional** — UTAD.
Grupo: PL02GR06

## Descrição

Sistema de gestão de uma concessionária de automóveis: stock de veículos,
clientes, vendedores e vendas (com descontos e comissões).

## Estado atual

**Fase 1 — Modelação e núcleo funcional**

- Modelo de domínio com tipos algébricos e records (`src/Model.hs`)
- Funções puras com pattern matching, guards e recursão explícita (`src/Domain.hs`)
- Dados de teste (`src/DadosTeste.hs`)
- Demonstração em `app/Main.hs`
- Testes em `test/Spec.hs`

## Requisitos

- GHC e Cabal (instalação recomendada via [GHCup](https://www.haskell.org/ghcup/))

## Compilar e executar

```bash
cabal build
cabal run concessionaria
```

## Testes

```bash
cabal test
```

## Estrutura

```
├── app/Main.hs         -- ponto de entrada (IO)
├── src/
│   ├── Model.hs        -- tipos de dados
│   ├── Domain.hs       -- lógica pura do domínio
│   └── DadosTeste.hs   -- dados de exemplo
├── test/Spec.hs        -- testes das funções puras
├── data/               -- ficheiros de dados (Fase 3)
└── docs/               -- relatório final (Fase 3)
```

## Funcionalidades (Fase 1)

- Pesquisa de veículos por id, marca e combustível
- Estatísticas: contagem, soma de preços, mais caro/mais barato
- Adicionar/remover veículos, marcar como vendido, ordenar por preço
- Cálculo de preço final (desconto por condição), categoria de preço
- Criação de vendas e comissões por escalões

## Grupo

- Nome Joana Esteves (2025161031)
- Nome Rui Mendes (nº)
- Nome Diogo Silva (nº)
