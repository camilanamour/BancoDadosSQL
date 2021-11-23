USE projetos

-- Quantos projetos n�o tem usu�rios associados a ele. A coluna deve chamar qty_projects_no_users
SELECT COUNT(pj.id) AS qty_projects_no_users
FROM Projeto pj LEFT OUTER JOIN Usuario_Projeto
ON pj.id = Usuario_Projeto.id_projeto
WHERE Usuario_Projeto.id_projeto IS NULL

-- Id do projeto, nome do projeto, qty_users_project (quantidade de usu�rios por projeto) em ordem alfab�tica crescente pelo nome do projeto
