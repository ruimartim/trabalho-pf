-- | Pequeno conjunto de dados para demonstração (Fase 1).
module DadosTeste
  ( stockExemplo
  , clientesExemplo
  , vendedoresExemplo
  ) where

import Model

stockExemplo :: Stock
stockExemplo =
  [ Veiculo 1 "Renault" "Clio"    2023 17500 Gasolina Novo  Disponivel
  , Veiculo 2 "Toyota"  "Yaris"   2019 12900 Hibrido  Usado Disponivel
  , Veiculo 3 "Tesla"   "Model 3" 2024 42000 Eletrico Novo  Disponivel
  , Veiculo 4 "BMW"     "320d"    2020 28500 Diesel   Usado Reservado
  , Veiculo 5 "Toyota"  "Corolla" 2022 24900 Hibrido  Novo  Disponivel
  , Veiculo 6 "Fiat"    "500"     2018  9800 Gasolina Usado Vendido
  ]

clientesExemplo :: [Cliente]
clientesExemplo =
  [ Cliente 1 "Ana Silva"    "123456789"
  , Cliente 2 "Rui Costa"    "987654321"
  ]

vendedoresExemplo :: [Vendedor]
vendedoresExemplo =
  [ Vendedor 1 "Marta Lopes"
  , Vendedor 2 "Pedro Nunes"
  ]
