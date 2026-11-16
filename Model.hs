-- | Modelo de domínio da concessionária.
-- Fase 1: tipos algébricos, records e aliases.
module Model
  ( Combustivel (..)
  , Condicao (..)
  , Disponibilidade (..)
  , CategoriaPreco (..)
  , Veiculo (..)
  , Cliente (..)
  , Vendedor (..)
  , Venda (..)
  , Stock
  ) where

-- | Tipo de combustível do veículo.
data Combustivel
  = Gasolina
  | Diesel
  | Eletrico
  | Hibrido
  deriving (Show, Eq)

-- | Condição do veículo.
data Condicao
  = Novo
  | Usado
  deriving (Show, Eq)

-- | Disponibilidade no stock.
data Disponibilidade
  = Disponivel
  | Reservado
  | Vendido
  deriving (Show, Eq)

-- | Categoria de preço (calculada, não guardada).
data CategoriaPreco
  = Economico
  | Medio
  | Premium
  deriving (Show, Eq)

-- | Um veículo do stock.
data Veiculo = Veiculo
  { veiculoId       :: Int
  , marca           :: String
  , modelo          :: String
  , ano             :: Int
  , preco           :: Double
  , combustivel     :: Combustivel
  , condicao        :: Condicao
  , disponibilidade :: Disponibilidade
  } deriving (Show, Eq)

-- | Um cliente.
data Cliente = Cliente
  { clienteId   :: Int
  , nomeCliente :: String
  , nif         :: String
  } deriving (Show, Eq)

-- | Um vendedor.
data Vendedor = Vendedor
  { vendedorId   :: Int
  , nomeVendedor :: String
  } deriving (Show, Eq)

-- | Uma venda efetuada. Guarda o preço final já calculado.
data Venda = Venda
  { vendaId       :: Int
  , vendaVeiculo  :: Veiculo
  , vendaCliente  :: Cliente
  , vendaVendedor :: Vendedor
  , precoFinal    :: Double
  } deriving (Show, Eq)

-- | O stock é simplesmente uma lista de veículos.
type Stock = [Veiculo]
