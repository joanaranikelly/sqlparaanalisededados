-- PARA QUE SERVE ##################################################################
-- Servem para consultar dados de outras consultas.


-- TIPOS ###########################################################################
-- Subquery no WHERE
-- Subquery com WITH
-- Subquery no FROM
-- Subquery no SELECT


-- EXEMPLOS ########################################################################

-- (Exemplo 1) Subquery no WHERE -- retorna apenas um valor
-- Informe qual é o veículo mais barato da tabela products

SELECT *
FROM sales.products
WHERE price = (SELECT MIN(price)FROM sales.products)

SELECT MIN(price)
FROM sales.products


-- (Exemplo 2) Subquery com WITH
-- Calcule a idade média dos clientes por status profissional
WITH tabela as(
	SELECT
		professional_status,
		(current_date - birth_date)/365 as idade
	FROM sales.customers
)
SELECT
	professional_status,
	AVG(idade) as idade_media
FROM tabela
GROUP BY professional_status


-- (Exemplo 3) Subquery no FROM
-- Calcule a média de idades dos clientes por status profissional
SELECT
	professional_status,
	AVG(idade) as idade_media
FROM (	
	SELECT
		professional_status,
		(current_date - birth_date)/365 as idade
	FROM sales.customers) as tabela
GROUP BY professional_status


-- (Exemplo 4) Subquery no SELECT
-- Na tabela sales.funnel crie uma coluna que informe o nº de visitas acumuladas 
-- que a loja visitada recebeu até o momento
select
	fun.visit_id,
	fun.visit_page_date,
	sto.store_name,
	(
		select count(*)
		from sales.funnel as fun2
		where fun2.visit_page_date <= fun.visit_page_date
			and fun2.store_id = fun.store_id
	) as visitas_acumuladas
from sales.funnel as fun
left join sales.stores as sto
	on fun.store_id = sto.store_id
order by sto.store_name, fun.visit_page_date





SELECT
	fun.visit_id,
	fun.visit_page_date,
	sto.store_name,
	(
		SELECT COUNT(*)
		FROM sales.funnel AS fun
		WHERE fun2.visit_page_date <= fun.visit_page_date
		AND fun2.store_id = fun.store_id
	
	) AS visitas
FROM sales.funnel AS fun
LEFT JOIN sales.stores as sto
ON fun.store_id = sto.store_id
ORDER BY sto.store_name, fun.visit_page_date
-- RESUMO ##########################################################################
-- (1) Servem para consultar dados de outras consultas.
-- (2) Para que as subqueries no WHERE e no SELECT funcionem, elas devem retornar 
-- apenas um único valor
-- (3) Não é recomendado utilizar subqueries diretamente dentro do FROM pois isso 
-- dificulta a legibilidade da query. 
