use locadora

-- Fazer uma consulta que retorne ID, Ano, nome do Filme (Caso o nome do filme 
-- tenha mais de 10 caracteres, para caber no campo da tela, mostrar os 10 primeiros caracteres, 
-- seguidos de reticências ...) dos filmes cujos DVDs foram fabricados depois de 01/01/2020
SELECT id, 
	   ano, 
	   CASE
			WHEN LEN(titulo) > 10 THEN
				SUBSTRING (titulo, 1, 10) + '...'
	   ELSE
			titulo
	   END AS titulo
FROM Filme
WHERE id IN
(
	SELECT id_filme
	FROM DVD
	WHERE data_fabricacao > '2020-01-01'
)

-- Fazer uma consulta que retorne num, data_fabricacao, qtd_meses_desde_fabricacao 
-- (Quantos meses desde que o dvd foi fabricado até hoje) do filme Interestelar
SELECT num, data_fabricacao, 
		DATEDIFF(MONTH, data_fabricacao, GETDATE()) AS qtd_meses_desde_fabricacao
FROM DVD
WHERE id_filme IN
(
	SELECT id
	FROM Filme
	WHERE titulo = 'Interestelar'
)

-- Fazer uma consulta que retorne num_dvd, data_locacao, data_devolucao, dias_alugado
-- (Total de dias que o dvd ficou alugado) e valor das locações da cliente que tem, no nome, o termo Rosa
SELECT num_DVD, data_locacao, data_devolucao, 
		DATEDIFF(DAY, data_locacao, data_devolucao) AS dias_alugado, valor
FROM Locacao
WHERE num_cadastro IN
(
	SELECT num_cadastro
	FROM Cliente
	WHERE nome LIKE 'Rosa%'
)

-- Nome, endereço_completo (logradouro e número concatenados), cep (formato XXXXX-XXX) 
-- dos clientes que alugaram DVD de num 10002.
SELECT nome, 
	   logradouro + ', ' + CAST(numero AS VARCHAR(5)) AS endereco_completo, 
	   SUBSTRING(cep, 1, 5) + '-' + SUBSTRING(cep, 6, 8)
FROM Cliente
WHERE num_cadastro IN
(
	SELECT num_cadastro
	FROM Locacao
	WHERE num_DVD = 10002
)

SELECT * FROM Filme
SELECT * FROM Estrela
SELECT * FROM Filme_Estrela
SELECT * FROM DVD
SELECT * FROM Cliente
SELECT * FROM Locacao