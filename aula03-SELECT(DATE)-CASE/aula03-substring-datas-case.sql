CREATE DATABASE aulaselects
GO 
USE aulaselects

--> FUNÇÕES IMPORTANTES
-- SUBSTRING ==> SUBSTRING(varchar, posicao inicial, qtd. de caracteres que quero)
SELECT SUBSTRING('Banco de dados', 1, 5) AS substr -- Banco
SELECT SUBSTRING('Banco de dados', 7, 5) AS substr -- de da
SELECT SUBSTRING('Banco de dados', 10, 5) AS substr -- dados

SELECT SUBSTRING('Banco de dados', 1, 5) AS substr -- sem espaço
SELECT SUBSTRING('Banco de dados', 1, 6) AS substr -- tem espaço

-- TRIM ==> TRIM(varchar) -- remove os espaços a direita e a esquerda da palavra
-- LTRIM & RTRIM
-- LTRIM(varchar) ==> retorna sem espaços a esquerda
SELECT LTRIM('   Banco') AS ltr
-- RTRIM(varchar) ==> retorna sem espaços a direita
SELECT RTRIM('Dados    ') AS rtr

SELECT LTRIM(RTRIM('   Banco       ')) AS lrtr -- remove a direita e a esquerda

-- Remover espaços no substring
SELECT RTRIM(SUBSTRING('Banco de dados', 1, 6)) AS rtr_subst -- 'banco ' ==> 'banco'
SELECT LTRIM(SUBSTRING('Banco de dados', 9, 6)) AS ltr_subst -- ' dados' ==> 'dados'
SELECT LTRIM(RTRIM(SUBSTRING('Banco de dados', 6, 4))) AS lrtr_subst -- ' de ' ==> 'de'

-- DATAS
-- DAY, MONTH, YEAR - recebe um date e retorna int
SELECT DAY(GETDATE()) AS dia_hoje
SELECT MONTH(GETDATE()) AS mes_hoje
SELECT YEAR(GETDATE()) AS ano_hoje
SELECT DAY(GETDATE()) AS dia_hoje, MONTH(GETDATE()) AS mes_hoje, YEAR(GETDATE()) AS ano_hoje

SELECT DAY(GETDATE()) + 1 AS dia_amanha -- fazer cálculo

-- DATEPART -- outros componentes
SELECT DATEPART(WEEKDAY, GETDATE()) AS dia_semana -- 1 = domingo; 7 = sábado
SELECT DATEPART(WEEKDAY, '2021-10-27') AS dia_semana

SELECT DATEPART(WEEK, GETDATE()) AS semana_ano -- semana do ano
SELECT DATEPART(DAYOFYEAR, GETDATE()) AS dia_ano -- dia do ano

-- DATEDIFF, DATEADD
-- DATEADD ==> (DATEADD(TIPO, INT, DATE) --> retorna uma DATA ou DATETIME
SELECT DATEADD(DAY, 5, GETDATE()) AS daqui_5_dias -- agrega valor
SELECT CONVERT(CHAR(10), DATEADD(DAY, 5, GETDATE()), 103) AS daqui_5_dias_BR

SELECT DATEADD(DAY, -28, GETDATE()) AS atras_28_dias -- 
SELECT CONVERT(CHAR(10), DATEADD(DAY, -28, GETDATE()), 103) AS atras_28_dias_BR

SELECT CONVERT(CHAR(10), DATEADD(WEEK, 2, GETDATE()), 103) AS atras_2_semana_BR

-- DATEDIFF(TIPO, DATE, DATE) --> retorna INT (DATE - DATE = INT)
SELECT DATEDIFF(DAY, '2021-07-28', GETDATE()) AS dias_aula -- mais atual por último = positivo
SELECT DATEDIFF(MONTH, '2021-07-28', GETDATE()) AS meses_aula
SELECT DATEDIFF(WEEK, '2021-07-28', GETDATE()) AS semanas_aula
SELECT DATEDIFF(YEAR, '2019-07-25', GETDATE()) AS anos_fatec -- anos inconsistência
---------------------------------------------------------------------------------------

EXEC sp_help funcionario
EXEC sp_help projeto
EXEC sp_help funcproj

SELECT * FROM funcionario
SELECT * FROM projeto
SELECT * FROM funcproj

INSERT INTO funcionario VALUES 
('Fulano','da Silva Jr.','R. Voluntários da Patria',8150,NULL,'05423110','11','32549874','1990-09-09',1235.00),
('João','dos Santos','R. Anhaia',150,NULL,'03425000','11','45879852','1973-08-19',2352.00),
('Maria','dos Santos','R. Pedro de Toledo',18,NULL,'04426000','11','32568974','1982-05-03',4550.00)

-- Consultar nome e cep mascarado(XXXXX-XXX)
SELECT id, nome + ' ' + sobrenome AS nome_comp, SUBSTRING(cep, 1, 5) + '-' + SUBSTRING(cep, 6, 3) AS cep
FROM Funcionario

-- Consultar nome e telefone mascarado com ddd ((XX)XXXX-XXXX)
SELECT id, nome + ' ' + sobrenome AS nome_comp, 
	   '(' + ddd + ')' + SUBSTRING(telefone, 1, 4) + '-' + SUBSTRING(cep, 5, 4) AS telefone
FROM Funcionario

--> celular (Telefone com 6,7,8,9 ==> acrescentar 9)

-- CASE ==> Parecido com um Switch.. case
-- ALIAS NO INICIO
SELECT id, nome + ' ' + sobrenome AS nome_comp, 
	   tel = CASE (SUBSTRING(telefone,1,1)) -- ou para int --> faz CAST(SUBSTRING(telefone,1,1))
	   WHEN '6' THEN
	   '(' + ddd + ')' + '9' + SUBSTRING(telefone, 1, 4) + '-' + SUBSTRING(cep, 5, 4) 
	   WHEN '7' THEN
	   '(' + ddd + ')' + '9' + SUBSTRING(telefone, 1, 4) + '-' + SUBSTRING(cep, 5, 4) 
	   WHEN '8' THEN
	   '(' + ddd + ')' + '9' + SUBSTRING(telefone, 1, 4) + '-' + SUBSTRING(cep, 5, 4) 
	   WHEN '9' THEN
	   '(' + ddd + ')' + '9' + SUBSTRING(telefone, 1, 4) + '-' + SUBSTRING(cep, 5, 4) 
	   ELSE
	   '(' + ddd + ')' + SUBSTRING(telefone, 1, 4) + '-' + SUBSTRING(cep, 5, 4) 
	   END
FROM Funcionario

-- CASE ==> Parecido com if
-- Alias no final
-- CASE ==> Parecido com um Switch.. case
SELECT id, nome + ' ' + sobrenome AS nome_comp, 
	   CASE 
			WHEN (CAST(SUBSTRING(telefone,1,1) AS INT)) >= 6 THEN
	   '(' + ddd + ')' + '9' + SUBSTRING(telefone, 1, 4) + '-' + SUBSTRING(cep, 5, 4)
	   ELSE
	   '(' + ddd + ')' + SUBSTRING(telefone, 1, 4) + '-' + SUBSTRING(cep, 5, 4)
	   END AS Tel
FROM Funcionario

--Consultar nome completo, com endereço completo (possível NULL)
SELECT id, 
	   nome + ' ' + sobrenome AS nome_completo,
	   logradouro + ',' + CAST(numero AS VARCHAR(5)) + ' - ' + bairro AS endereco
FROM funcionario
 
--Corrigir com CASE
SELECT id, 
	   nome + ' ' + sobrenome AS nome_completo,
	   CASE
			WHEN (bairro IS NOT NULL) THEN
				logradouro + ',' + CAST(numero AS VARCHAR(5)) + ' - ' + bairro 
			ELSE
				logradouro + ',' + CAST(numero AS VARCHAR(5))
		END AS endereco
FROM funcionario


-- Consultar nome completo, endereço, telefone, validando o celular
SELECT id, 
	   nome + ' ' + sobrenome AS nome_completo,
		CASE -- endereço
			WHEN (bairro IS NOT NULL) THEN
				logradouro + ',' + CAST(numero AS VARCHAR(5)) + ' - ' + bairro 
			ELSE
				logradouro + ',' + CAST(numero AS VARCHAR(5))
		END AS endereco,
		SUBSTRING(cep, 1, 5) + '-' + SUBSTRING(cep, 6, 3) AS cep,
		CASE -- telefone ou celular
			WHEN (CAST(SUBSTRING(telefone, 1, 1) AS INT)) >= 6 THEN
				'('+ddd+') 9'+SUBSTRING(telefone,1,4)+'-'+SUBSTRING(telefone,5,4)
			ELSE
				'('+ddd+') '+SUBSTRING(telefone,1,4)+'-'+SUBSTRING(telefone,5,4)
		END AS tel
FROM funcionario


-- Quantos dias trabalhados, por funcionário em cada projeto
-- DATADIFF
SELECT id_funcionario
	   codigo_projeto, DATEDIFF(DAY, data_inicio, data_fim) AS dias_trabalhados
FROM funcproj

-- Funcionário 3 do projeto 1003 pediu mais três dias - BR
-- DATAADD
SELECT CONVERT(CHAR(10),DATEADD(DAY, 3, data_fim), 103) AS nova_data
FROM funcproj
WHERE id_funcionario = 3 AND codigo_projeto = 1003

-- Quais projetos com mais ou igual 10 dias trabalhados
SELECT DISTINCT codigo_projeto
FROM funcproj
WHERE DATEDIFF(DAY, data_inicio, data_fim) >= 10

-- Quais projetos com menos 10 dias trabalhados
SELECT DISTINCT codigo_projeto
FROM funcproj
WHERE DATEDIFF(DAY, data_inicio, data_fim) < 10


-- SUBQUERY OU SUBSELECT == SUBCONSULTA -- custo de processamento -- BAIXO DESEMPENHO
-- Nomes e descrições de projetos distintos com menos de 10 dias (tabelas distintas)

SELECT *
FROM projeto
WHERE codigo IN (1002, 1003) --> (1, ..., n) espécie de vetor ou NOT IN(1001, 1004,..., n)

SELECT nome, descricao
FROM projeto
WHERE codigo IN -- menos de 10 dias
(
		SELECT DISTINCT codigo_projeto
		FROM funcproj
		WHERE DATEDIFF(DAY, data_inicio, data_fim) < 10 
) -- Retorno do select interno vai para a condição do select externo 

SELECT nome, descricao
FROM projeto
WHERE codigo NOT IN -- mais ou igual a 10 dias
(
		SELECT DISTINCT codigo_projeto
		FROM funcproj
		WHERE DATEDIFF(DAY, data_inicio, data_fim) < 10
) 

-- Nomes completos dos Funcionários que estão no projeto Modificação do Módulo de Cadastro
SELECT nome + ' ' + sobrenome AS nome_comp
FROM funcionario
WHERE id IN -- exibe o nome dos funcionários segundo o código fornecedido
(
	SELECT id_funcionario
	FROM funcproj
	WHERE codigo_projeto IN -- fornece os id dos funcionarios que estão no projeto
	(
		SELECT codigo
		FROM projeto
		WHERE nome = 'Modificação do Módulo de Cadastro' -- fornece o código do projeto
	)
)

----> NOME COMPLETO, ENDEREÇO, TELEFONE DOS FUNCIONÁRIOS QUE ESTÃO NO PROJETO "Modificação do Módulo de Cadastro" <----
SELECT	id, 
		nome + ' ' + sobrenome AS nome_completo,
		CASE
			WHEN (bairro IS NOT NULL) THEN
				logradouro + ',' + CAST(numero AS VARCHAR(5)) + ' - ' + bairro 
			ELSE
				logradouro + ',' + CAST(numero AS VARCHAR(5))
		END AS endereco,
		SUBSTRING(cep, 1, 5) + '-' + SUBSTRING(cep, 6, 3) AS cep,
		CASE 
			WHEN (CAST(SUBSTRING(telefone, 1, 1) AS INT)) >= 6 THEN
				'('+ddd+') 9'+SUBSTRING(telefone,1,4)+'-'+SUBSTRING(telefone,5,4)
			ELSE
				'('+ddd+') '+SUBSTRING(telefone,1,4)+'-'+SUBSTRING(telefone,5,4)
		END AS tel
FROM funcionario
WHERE id IN
(
	SELECT id_funcionario
	FROM funcproj
	WHERE codigo_projeto IN
	(
		SELECT codigo
		FROM projeto
		WHERE nome = 'Modificação do Módulo de Cadastro'
	)
)

--> Nome completo e idade em anos (fez e ainda fará) dos funcionários
SELECT id,
		nome + ' ' + sobrenome AS nome_completo,
		CASE
			WHEN (MONTH(GETDATE()) = MONTH(data_nasc) AND
					DAY(GETDATE()) = DAY(data_nasc)) THEN
						DATEDIFF(YEAR, data_nasc, GETDATE())
			ELSE
				CASE 
					WHEN (MONTH(GETDATE()) > MONTH(data_nasc)) THEN
						DATEDIFF(YEAR, data_nasc, GETDATE())
					ELSE
						DATEDIFF(YEAR, data_nasc, GETDATE()) - 1
					END
			END AS idade, -- com case
			DATEDIFF(DAY, data_nasc, GETDATE()) / 365 AS idade_datediff -- APENAS calcular idade COM DATEDIFF(DAY) / 365
FROM funcionario