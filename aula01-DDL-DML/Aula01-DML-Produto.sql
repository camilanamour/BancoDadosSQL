USE lojaprodutos

/*
DML - MANIPULAÇÃO DE DADOS - CRUD
INSERT (CREATE), SELECT (LER, READ), UPDATE (UPDATE), DELETE (DELETE)
*/

/* INSERIR REGISTROS (TUPLAS)
INSERT INTO tabela (Atrib1, ..., AtribN)
VALUES (dado1, dado2,..., dN)
*/

INSERT INTO produto (codProduto, nomeProduto, valorUnitario, descricao)
VALUES (1, 'Mouse', 25.90, 'Mouse simples de 2 botões')

INSERT INTO produto (codProduto, nomeProduto, valorUnitario, descricao)
VALUES (2, 'Pen Drive', 51.90, 'Pen Drive de 64 GB')

-- Pode ser fora de ordem
INSERT INTO produto (descricao, valorUnitario, codProduto, nomeProduto)
VALUES ('Monitor de 21 polegadas 4k, HDMI, com entrada DVI e VGA, multi resoluções e alimentação interna', 90.80, 3, 'Monitor')

-- Precisa ser em ordem
INSERT INTO produto
VALUES (4, 'Teclado', 50.90, 'Teclado simples')

INSERT INTO produto
VALUES (5, 'Cabo Rede', 10.90, NULL) -- ou sem valor (5, 'Cabo Rede', 10.90)

INSERT INTO produto
VALUES (6, 'Cabo USB', 10.90, NULL)

-- Inserção de data 'AAAA-MM-DD' ('AAAA-DD-MM, EM PORTUGUÊS DD-MM-AAAA)
-- Inserção data e hora 'AAAA-MM-DD HH:mm:ss:ddd'
-- INSERIR EM MASSA
INSERT INTO pedido VALUES
(9001, '2021-10-01 12:30'),
(9002, '2021-10-01 12:40'),
(9003, '2021-10-01 12:45'),
(9004, '2021-10-01 12:57')

/* CONSULTAR TODOS OS REGISTROS DA TABELA
SELECT * 
FROM tabela
*/
SELECT * FROM produto
SELECT * FROM pedido
SELECT * FROM produto_pedido

INSERT INTO produto_pedido
VALUES (1, 9002, 3, 77.70) -- consistente

/* ATUALIZAR DADO A DADO
UPDATE tabela
SET atributo1= novo_valor1, atributo2 = novo_valor2, ...
WHERE condições
*/
UPDATE pedido
SET dataPedido = '2021-10-01 13:00'
WHERE codPedido = 9003 -- chave primária = apenas um registro

UPDATE produto
SET valorUnitario = 27.99, descricao = 'Mouse óptico com 2 botões'
WHERE nomeProduto = 'Mouse' -- muda todos que tem o nome Mouse

UPDATE produto
SET descricao = 'Cabo de Rede de 5m'
WHERE nomeProduto = 'Cabo Rede' AND descricao IS NULL

/* UPDATE GENERICO - PARA JAVA
UPDATE produto
SET nomeProduto = ?, valorUnitario = ?, descricao = ?
WHERE CodProduto = ?
*/

/* EXCLUIR REGISTROS - ÚLTIMOS CASOS
DELETE tabela - perde todos os registros

DELETE tabela
WHERE condições - baseada em chave primária 
--> valor completo e correto
*/
DELETE pedido
WHERE codPedido = 9002