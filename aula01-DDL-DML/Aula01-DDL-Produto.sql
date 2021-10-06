/*
CRIAR UM DOMÍNIO (DATABASE)
DDL (ESQUEMA-ESTRUTURA) - CREATE (Criar), ALTER (Modificar), DROP (Excluir)

CREATE DATABASE nome - Cria a database no servidor
USE nome_database - Ativa a database
*/
CREATE DATABASE lojaprodutos -- cria datbase
GO -- Permite a execução em batches (lotes)
USE lojaprodutos -- Ativa a database

DROP DATABASE lojaprodutos -- Excluir a database --> não pode estar aviva
-- USE master

/* CRIAR UMA TABELA
CREATE TABLE nome(
Atributo1 tipo nulidade,
[Atributo 2] tipo nulidade,
...
AtributoN tipo nulidade
PRIMARY KEY (Atributo1, AtributoN) -- Chave composta
FOREIGN KEY (Atributo 4) REFERENCES tab1(PK)
FOREIGN KEY (Atributo 4) REFERENCES tab1(PK)
)
*/
CREATE TABLE produto(
codProduto		INT				NOT NULL,
nomeProduto		VARCHAR(20)		NOT NULL,
valorUnitario	DECIMAL(7,2)	NOT NULL
PRIMARY KEY (codProduto)
)

CREATE TABLE pedido(
codPedido		INT				NOT NULL,
dataPedido		DATE			NOT NULL
PRIMARY KEY (codPedido)
)
GO
CREATE TABLE produto_pedido(
codProduto		INT				NOT NULL,
codPedido		INT				NOT NULL,
qtde			INT				NOT NULL,
valorTotal		DECIMAL(7,2)	NOT NULL
PRIMARY KEY (codProduto, codPedido)
FOREIGN KEY (codProduto) REFERENCES produto (codProduto),
FOREIGN KEY (codPedido) REFERENCES pedido (codPedido)
)

-- EXEC sp_help nome_tabela -- Retorna todas aas informções da tabela
EXEC sp_help produto
EXEC sp_help pedido
EXEC sp_help produto_pedido


/* MODIFICAR A ESTRUTURA DA TABELA
ALTER TABLE nome_tabela
operações de modificação (ADD, ALTER COLUMN (tipo de dado), DROP COLUMN (exclui coluna))
*/

ALTER TABLE produto
ADD descricao VARCHAR NULL

/*
TABELA CRIADA SEM PK
ALTER TABLE produto
ADD PRIMARY KEY (codProduto)

TABELA CRIADA SEM FK
ALTER TABLE produto
ADD FOREIGN KEY (codProduto) REFERENCES produto (codProduto)
*/

ALTER TABLE produto
ALTER COLUMN descricao VARCHAR(100) NULL -- NOT NULL FUNCIONOU PQ ESTA SEM DADOS

ALTER TABLE produto
DROP COLUMN descricao

-- EXEC sp_rename 'dbo.tabela.coluna', 'novo_nome', 'COLUMN' - Renomeia coluna
-- EXEC sp_rename 'dbo.tabela', 'novo_nome'- Renomeia tabela
EXEC sp_rename 'dbo.produto.descricao', 'descr', 'COLUMN'
-- IMPACTA DIRETAMENTE TRANSACT SQL

ALTER TABLE produto
DROP COLUMN descr

/* EXCLUIR UMA TABELA
DROP TABLE nome -- se tiver tabelas que faz referencia dela, não exclui, precisa excluir
todas as referências - garante consistências
*/
DROP TABLE produto

ALTER TABLE pedido
ALTER COLUMN dataPedido DATETIME NOT NULL