use locadora

SELECT * FROM Filme
SELECT * FROM Estrela
SELECT * FROM Filme_Estrela
SELECT * FROM DVD
SELECT * FROM Cliente
SELECT * FROM Locacao

-- 1) Consultar num_cadastro do cliente, nome do cliente, data_locacao (Formato dd/mm/aaaa), Qtd_dias_alugado (total de dias que o filme ficou alugado), titulo do
-- filme, ano do filme da loca��o do cliente cujo nome inicia com Matilde
SELECT c.num_cadastro, c.nome, CONVERT(CHAR(10),l.data_locacao,103) AS data_locacao, 
	   DATEDIFF(DAY, l.data_locacao, l.data_devolucao) AS Qtd_dias_alugado,
	   f.titulo, f.ano
FROM Cliente c INNER JOIN Locacao l
ON c.num_cadastro = l.num_cadastro
INNER JOIN DVD 
ON DVD.num = l.num_DVD
INNER JOIN Filme f
ON f.id = DVD.id_filme
WHERE c.nome LIKE 'Matilde%'

-- 2) Consultar nome da estrela, nome_real da estrela, t�tulo do filme dos filmes cadastrados do ano de 2015
SELECT est.nome, est.nome_real, fil.titulo
FROM Estrela est INNER JOIN Filme_Estrela filest
ON est.id = filest.id_estrela
INNER JOIN Filme fil
ON fil.id = filest.id_filme
WHERE fil.ano = 2015

-- 3) Consultar t�tulo do filme, data_fabrica��o do dvd (formato dd/mm/aaaa), caso a diferen�a do ano do filme com o ano atual seja maior que 6, deve aparecer a diferen�a
-- do ano com o ano atual concatenado com a palavra anos (Exemplo: 7 anos), caso contr�rio s� a diferen�a (Exemplo: 4).
SELECT f.titulo, CONVERT(CHAR(10),dvd.data_fabricacao,103) AS data_fabrica��o_dvd,
		CASE WHEN (YEAR(GETDATE()) - f.ano) > 6 THEN
			CAST(YEAR(GETDATE()) - f.ano AS VARCHAR(3)) + ' anos'
		ELSE
			CAST(YEAR(GETDATE()) - f.ano AS VARCHAR(3))
		END AS diferenca
FROM Filme f INNER JOIN DVD
ON f.id = DVD.id_filme