USE locadora

-- 1) Consultar, num_cadastro do cliente, nome do cliente, titulo do filme, data_fabrica��o
-- do dvd, valor da loca��o, dos dvds que tem a maior data de fabrica��o dentre todos os
-- cadastrados.



SELECT * FROM Cliente
SELECT * FROM Locacao
SELECT * FROM DVD
SELECT * FROM Filme

-- 2) Consultar Consultar, num_cadastro do cliente, nome do cliente, data de loca��o
-- (Formato DD/MM/AAAA) e a quantidade de DVD�s alugados por cliente (Chamar essa
-- coluna de qtd), por data de loca��o

-- 3) Consultar Consultar, num_cadastro do cliente, nome do cliente, data de loca��o
-- (Formato DD/MM/AAAA) e a valor total de todos os dvd�s alugados (Chamar essa
-- coluna de valor_total), por data de loca��o

-- 4) Consultar Consultar, num_cadastro do cliente, nome do cliente, Endere�o
-- concatenado de logradouro e numero como Endereco, data de loca��o (Formato
-- DD/MM/AAAA) dos clientes que alugaram mais de 2 filmes simultaneamente