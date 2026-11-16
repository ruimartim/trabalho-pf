-- | Testes simples (sem dependências externas) das funções puras.
module Main (main) where

import Control.Monad (unless)
import System.Exit (exitFailure)

import DadosTeste
import Domain
import Model

-- | Um teste: descrição e resultado.
type Teste = (String, Bool)

testes :: [Teste]
testes =
  [ ("desconto Novo e 0",            descontoPorCondicao Novo == 0)
  , ("desconto Usado e 10%",         descontoPorCondicao Usado == 0.10)
  , ("classificar 10000 = Economico", classificarPreco 10000 == Economico)
  , ("classificar 15000 = Medio",     classificarPreco 15000 == Medio)
  , ("classificar 40000 = Premium",   classificarPreco 40000 == Premium)
  , ("contar stock de exemplo = 6",   contarVeiculos stockExemplo == 6)
  , ("contar stock vazio = 0",        contarVeiculos [] == 0)
  , ("somaPrecos vazio = 0",          somaPrecos [] == 0)
  , ("maisCaro vazio = Nothing",      maisCaro [] == Nothing)
  , ("maisCaro e o Tesla",            fmap marca (maisCaro stockExemplo) == Just "Tesla")
  , ("maisBarato e o Fiat",           fmap marca (maisBarato stockExemplo) == Just "Fiat")
  , ("procurarPorId existente",       fmap modelo (procurarPorId 3 stockExemplo) == Just "Model 3")
  , ("procurarPorId inexistente",     procurarPorId 99 stockExemplo == Nothing)
  , ("marca ignora maiusculas",       contarPorMarca "TOYOTA" stockExemplo == 2)
  , ("marca inexistente = 0",         contarPorMarca "Ford" stockExemplo == 0)
  , ("combustivel Eletrico = 1",      contarVeiculos (procurarPorCombustivel Eletrico stockExemplo) == 1)
  , ("disponiveis = 4",               contarVeiculos (veiculosDisponiveis stockExemplo) == 4)
  , ("remover reduz o stock",         contarVeiculos (removerVeiculo 1 stockExemplo) == 5)
  , ("remover id inexistente",        contarVeiculos (removerVeiculo 99 stockExemplo) == 6)
  , ("adicionar aumenta o stock",     contarVeiculos (adicionarVeiculo (head stockExemplo) stockExemplo) == 7)
  , ("marcarComoVendido",             fmap disponibilidade (procurarPorId 1 (marcarComoVendido 1 stockExemplo)) == Just Vendido)
  , ("ordenar: primeiro e o mais barato", fmap marca (safeHead (ordenarPorPreco stockExemplo)) == Just "Fiat")
  , ("ordenar mantem o tamanho",      contarVeiculos (ordenarPorPreco stockExemplo) == 6)
  , ("comissao escalao baixo",        calcularComissao 10000 == 200)
  , ("comissao escalao alto",         calcularComissao 50000 == 2500)
  , ("preco final usado com desconto", calcularPrecoFinal (stockExemplo !! 1) == 12900 * 0.9)
  , ("totalVendas vazio = 0",         totalVendas [] == 0)
  , ("comissaoTotal sem vendas = 0",  comissaoTotalVendedor 1 [] == 0)
  ]
  where
    safeHead []    = Nothing
    safeHead (x:_) = Just x

main :: IO ()
main = do
  let falhas = [d | (d, ok) <- testes, not ok]
  mapM_ (\d -> putStrLn ("FALHOU: " ++ d)) falhas
  putStrLn (show (length testes - length falhas) ++ "/" ++ show (length testes) ++ " testes passaram")
  unless (null falhas) exitFailure
