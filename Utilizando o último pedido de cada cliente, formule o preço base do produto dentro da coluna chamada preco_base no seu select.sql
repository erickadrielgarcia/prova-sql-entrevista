SELECT p.id_produto, p.descricao AS descricao_produto, c.id_cliente, c.razao_social AS razao_social_cliente, e.id_empresa,
e.razao_social AS razao_social_empresa, v.id_vendedor, v.nome,  cp.preco_maximo, cp.preco_minimo, 
CASE
    -- Calcula o preço base do produto com base nos preços do item do pedido e nas configurações de preço
    WHEN MAX(ip.preco_praticado) < cp.preco_minimo THEN cp.preco_minimo -- Se o preço praticado for menor que o preço mínimo, usa o preço mínimo
    WHEN MAX(ip.preco_praticado) > cp.preco_maximo THEN cp.preco_maximo -- Se o preço praticado for maior que o preço máximo, usa o preço máximo
    ELSE MAX(ip.preco_praticado) -- Caso contrário, usa o preço praticado
END AS preco_base
FROM public.clientes c
JOIN public.pedido pd ON c.id_cliente = pd.id_cliente
JOIN public.empresa e ON e.id_empresa = pd.id_empresa
JOIN public.itens_pedido ip ON pd.id_pedido = ip.id_pedido -- Junta com a tabela de itens do pedido usando o ID do pedido
JOIN public.produtos p ON ip.id_produto = p.id_produto -- Junta com a tabela de produtos usando o ID do produto
JOIN public.vendedores v ON v.id_vendedor = c.id_vendedor -- Junta com a tabela de vendedores usando o ID do vendedor do cliente
JOIN public.config_preco_produto cp ON cp.id_produto = p.id_produto -- Junta com a tabela de configurações de preço do produto
WHERE (c.id_cliente, pd.id_pedido) IN 
( -- Restringe os resultados aos IDs de cliente e de pedido que correspondem ao último pedido de cada cliente 
	SELECT id_cliente, MAX(id_pedido) AS ultimo_pedido -- Seleciona o ID do último pedido de cada cliente 
	FROM public.pedido GROUP BY id_cliente -- Agrupa os resultados por ID do cliente
)
GROUP BY p.id_produto, p.descricao, c.id_cliente, c.razao_social, e.id_empresa, e.razao_social, v.id_vendedor, v.nome, 
cp.preco_maximo, cp.preco_minimo ORDER BY c.id_cliente ASC