-- | Ponto de entrada: demonstração da Fase 1.
-- Todo o IO fica aqui; a lógica está em Domain (pura).
module Main (main) where

import Text.Printf (printf)

import DadosTeste
import Domain
import Model

-- | Descrição de um veículo numa linha.
descrever :: Veiculo -> String
descrever v =
  show (veiculoId v) ++ ". " ++ marca v ++ " " ++ modelo v
    ++ " (" ++ show (ano v) ++ ") - "
    ++ show (preco v) ++ " EUR - "
    ++ show (combustivel v) ++ ", " ++ show (condicao v)
    ++ ", " ++ show (disponibilidade v)

-- | Imprime uma lista de veículos, um por linha.
imprimirLista :: Stock -> IO ()
imprimirLista []     = return ()
imprimirLista (v:vs) = putStrLn ("  " ++ descrever v) >> imprimirLista vs

titulo :: String -> IO ()
titulo t = putStrLn ("\n== " ++ t ++ " ==")

main :: IO ()
main = do
  let stock = stockExemplo

  titulo "Stock completo"
  imprimirLista stock

  printf "\nTotal de veiculos: %d\n" (contarVeiculos stock)
  printf "Soma dos precos de tabela: %.2f EUR\n" (somaPrecos stock)

  titulo "Veiculos Toyota"
  imprimirLista (procurarPorMarca "toyota" stock)

  titulo "Veiculos eletricos"
  imprimirLista (procurarPorCombustivel Eletrico stock)

  titulo "Disponiveis para venda"
  imprimirLista (veiculosDisponiveis stock)

  titulo "Ordenados por preco"
  imprimirLista (ordenarPorPreco stock)

  titulo "Mais caro / mais barato"
  case maisCaro stock of
    Nothing -> putStrLn "  Stock vazio"
    Just v  -> putStrLn ("  Mais caro: " ++ descrever v)
  case maisBarato stock of
    Nothing -> putStrLn "  Stock vazio"
    Just v  -> putStrLn ("  Mais barato: " ++ descrever v)

  titulo "Pesquisa por id"
  putStrLn ("  id 3:  " ++ maybe "nao encontrado" descrever (procurarPorId 3 stock))
  putStrLn ("  id 99: " ++ maybe "nao encontrado" descrever (procurarPorId 99 stock))

  titulo "Categorias de preco"
  printf "  17500 EUR -> %s\n" (show (classificarPreco 17500))
  printf "  42000 EUR -> %s\n" (show (classificarPreco 42000))

  titulo "Uma venda"
  case procurarPorId 2 stock of
    Nothing -> putStrLn "  Veiculo nao encontrado"
    Just v  -> do
      let venda = criarVenda 1 v (head clientesExemplo) (head vendedoresExemplo)
      printf "  Venda #%d: %s %s a %s\n" (vendaId venda) (marca v) (modelo v)
             (nomeCliente (vendaCliente venda))
      printf "  Preco de tabela: %.2f EUR | Preco final: %.2f EUR\n"
             (preco v) (precoFinal venda)
      printf "  Comissao de %s: %.2f EUR\n"
             (nomeVendedor (vendaVendedor venda))
             (comissaoTotalVendedor 1 [venda])
      let stock' = marcarComoVendido 2 stock
      printf "  Disponiveis apos a venda: %d\n"
             (contarVeiculos (veiculosDisponiveis stock'))
