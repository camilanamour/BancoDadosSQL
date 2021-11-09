use projetos

-- a) Adicionar User (6; Joao; Ti_joao; 123mudar; joao@empresa.com)
INSERT INTO Usuario(nome, username, senha, email) VALUES
('Joao', 'Ti_joao', '123mudar', 'joao@empresa.com')

SELECT * FROM Usuario

-- b) Adicionar Project (10004; Atualização de Sistemas; Modificação de Sistemas Operacionais nos PC's; 12/09/2014)
INSERT INTO Projeto(nome, descricao, data_projeto) VALUES
('Atualização de Sistemas', 'Modificação de Sistemas Operacionais nos PCs', '2014-09-12')

SELECT * FROM Projeto

SELECT * FROM Usuario_Projeto

-- c) Consultar:
-- 1) Id, Name e Email de Users, Id, Name, Description e Data de Projects, dos usuários que participaram do projeto Name Re-folha
SELECT us.id, us.nome, us.email, pjt.id AS id_projeto, pjt.nome AS nome_projeto, pjt.descricao, pjt.data_projeto
FROM Usuario us INNER JOIN Usuario_Projeto uspjt
ON us.id = uspjt.id_usuario
INNER JOIN Projeto pjt
ON pjt.id = uspjt.id_projeto
WHERE pjt.nome = 'Re-folha'

-- 2) Name dos Projects que não tem Users
SELECT pjt.nome
FROM Projeto pjt LEFT OUTER JOIN Usuario_Projeto uspjt
ON pjt.id = uspjt.id_projeto
WHERE uspjt.id_projeto IS NULL

-- 3) Name dos Users que não tem Projects
SELECT us.nome
FROM Usuario us LEFT OUTER JOIN Usuario_Projeto uspjt
ON us.id = uspjt.id_usuario
WHERE uspjt.id_usuario IS NULL