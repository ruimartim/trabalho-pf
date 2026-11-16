-- | Núcleo funcional (puro) da concessionária.
--
-- Fase 1: pattern matching, guards e recursão explícita sobre listas.
-- Propositadamente NÃO se usam map/filter/fold aqui (ficam para a Fase 2).
module Domain
  ( -- * Regras de preço
    descontoPorCondicao
  , calcularPrecoFinal
  , classificarPreco
  , calcularComissao
    -- * Pesquisa
  , procurarPorId
  , procurarPorMarca
  , procurarPorCombustivel
  , veiculosDisponiveis
    -- * Estatísticas
  , contarVeiculos
  , somaPrecos
  , maisCaro
  , maisBarato
  , contarPorMarca
    -- * Operações sobre o stock
  , adicionarVeiculo
  , removerVeiculo
  , marcarComoVendido
  , ordenarPorPreco
    -- * Vendas
  , criarVenda
  , totalVendas
  , comissaoTotalVendedor
    -- * Auxiliares
  , minusculas
  ) where

import Data.Char (toLower)
import Model

-- ---------------------------------------------------------------
-- Regras de preço
-- ---------------------------------------------------------------

-- | Desconto aplicado consoante a condição do veículo.
descontoPorCondicao :: Condicao -> Double
descontoPorCondicao Novo  = 0.00
descontoPorCondicao Usado = 0.10

-- | Preço final de um veículo, já com desconto.
calcularPrecoFinal :: Veiculo -> Double
calcularPrecoFinal v = preco v * (1 - descontoPorCondicao (condicao v))

-- | Classifica um preço numa categoria.
classificarPreco :: Double -> CategoriaPreco
classificarPreco p
  | p < 15000 = Economico
  | p < 40000 = Medio
  | otherwise = Premium

-- | Comissão do vendedor sobre o valor de uma venda (escalões).
calcularComissao :: Double -> Double
calcularComissao valor
  | valor < 15000 = valor * 0.02
  | valor < 40000 = valor * 0.03
  | otherwise     = valor * 0.05

-- ---------------------------------------------------------------
-- Pesquisa (recursão explícita)
-- ---------------------------------------------------------------

-- | Procura um veículo pelo identificador.
procurarPorId :: Int -> Stock -> Maybe Veiculo
procurarPorId _ [] = Nothing
procurarPorId i (v:vs)
  | veiculoId v == i = Just v
  | otherwise        = procurarPorId i vs

-- | Todos os veículos de uma marca (ignora maiúsculas/minúsculas).
procurarPorMarca :: String -> Stock -> Stock
procurarPorMarca _ [] = []
procurarPorMarca m (v:vs)
  | minusculas (marca v) == minusculas m = v : resto
  | otherwise                            = resto
  where
    resto = procurarPorMarca m vs

-- | Todos os veículos com determinado combustível.
procurarPorCombustivel :: Combustivel -> Stock -> Stock
procurarPorCombustivel _ [] = []
procurarPorCombustivel c (v:vs)
  | combustivel v == c = v : resto
  | otherwise          = resto
  where
    resto = procurarPorCombustivel c vs

-- | Só os veículos disponíveis para venda.
veiculosDisponiveis :: Stock -> Stock
veiculosDisponiveis [] = []
veiculosDisponiveis (v:vs) =
  case disponibilidade v of
    Disponivel -> v : veiculosDisponiveis vs
    _          -> veiculosDisponiveis vs

-- ---------------------------------------------------------------
-- Estatísticas
-- ---------------------------------------------------------------

-- | Número de veículos no stock.
contarVeiculos :: Stock -> Int
contarVeiculos []     = 0
contarVeiculos (_:vs) = 1 + contarVeiculos vs

-- | Soma dos preços de tabela.
somaPrecos :: Stock -> Double
somaPrecos []     = 0
somaPrecos (v:vs) = preco v + somaPrecos vs

-- | Veículo mais caro (Nothing se o stock estiver vazio).
maisCaro :: Stock -> Maybe Veiculo
maisCaro []     = Nothing
maisCaro [v]    = Just v
maisCaro (v:vs) =
  case maisCaro vs of
    Nothing -> Just v
    Just w
      | preco v >= preco w -> Just v
      | otherwise          -> Just w

-- | Veículo mais barato (Nothing se o stock estiver vazio).
maisBarato :: Stock -> Maybe Veiculo
maisBarato []     = Nothing
maisBarato [v]    = Just v
maisBarato (v:vs) =
  case maisBarato vs of
    Nothing -> Just v
    Just w
      | preco v <= preco w -> Just v
      | otherwise          -> Just w

-- | Quantos veículos há de uma marca.
contarPorMarca :: String -> Stock -> Int
contarPorMarca m stock = contarVeiculos (procurarPorMarca m stock)

-- ---------------------------------------------------------------
-- Operações sobre o stock
-- ---------------------------------------------------------------

-- | Adiciona um veículo ao stock.
adicionarVeiculo :: Veiculo -> Stock -> Stock
adicionarVeiculo v stock = v : stock

-- | Remove o veículo com o identificador dado.
removerVeiculo :: Int -> Stock -> Stock
removerVeiculo _ [] = []
removerVeiculo i (v:vs)
  | veiculoId v == i = vs
  | otherwise        = v : removerVeiculo i vs

-- | Marca um veículo como vendido.
marcarComoVendido :: Int -> Stock -> Stock
marcarComoVendido _ [] = []
marcarComoVendido i (v:vs)
  | veiculoId v == i = v { disponibilidade = Vendido } : vs
  | otherwise        = v : marcarComoVendido i vs

-- | Ordena por preço crescente (insertion sort recursivo).
ordenarPorPreco :: Stock -> Stock
ordenarPorPreco []     = []
ordenarPorPreco (v:vs) = inserirPorPreco v (ordenarPorPreco vs)

inserirPorPreco :: Veiculo -> Stock -> Stock
inserirPorPreco v [] = [v]
inserirPorPreco v (w:ws)
  | preco v <= preco w = v : w : ws
  | otherwise          = w : inserirPorPreco v ws

-- ---------------------------------------------------------------
-- Vendas
-- ---------------------------------------------------------------

-- | Cria uma venda; o preço final já inclui o desconto da condição.
criarVenda :: Int -> Veiculo -> Cliente -> Vendedor -> Venda
criarVenda i v c vd = Venda
  { vendaId       = i
  , vendaVeiculo  = v
  , vendaCliente  = c
  , vendaVendedor = vd
  , precoFinal    = calcularPrecoFinal v
  }

-- | Valor total de uma lista de vendas.
totalVendas :: [Venda] -> Double
totalVendas []     = 0
totalVendas (x:xs) = precoFinal x + totalVendas xs

-- | Comissão total acumulada por um vendedor.
comissaoTotalVendedor :: Int -> [Venda] -> Double
comissaoTotalVendedor _ [] = 0
comissaoTotalVendedor i (x:xs)
  | vendedorId (vendaVendedor x) == i =
      calcularComissao (precoFinal x) + resto
  | otherwise = resto
  where
    resto = comissaoTotalVendedor i xs

-- ---------------------------------------------------------------
-- Auxiliares
-- ---------------------------------------------------------------

-- | Converte uma string para minúsculas (recursão explícita).
minusculas :: String -> String
minusculas []     = []
minusculas (c:cs) = toLower c : minusculas cs
