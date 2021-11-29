USE projetos

-- Quantos projetos não tem usuários associados a ele. A coluna deve chamar qty_projects_no_users
SELECT COUNT(pj.id) AS qty_projects_no_users
FROM Projeto pj LEFT OUTER JOIN Usuario_Projeto
ON pj.id = Usuario_Projeto.id_projeto
WHERE Usuario_Projeto.id_projeto IS NULL

-- Id do projeto, nome do projeto, qty_users_project (quantidade de usuários por projeto) em ordem alfabética crescente pelo nome do projeto
SELECT pj.id, pj.nome, COUNT(uspjt.id_usuario) AS qty_users_project
FROM Projeto pj INNER JOIN Usuario_Projeto uspjt
ON pj.id = uspjt.id_projeto
GROUP BY pj.id, pj.nome