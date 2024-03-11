SELECT v.id_vendedor,v.nome,
-- Soma do preço praticado multiplicado pela quantidade de cada item do pedido, resultando no valor total de vendas para cada vendedor
SUM(ip.preco_praticado * ip.quantidade) AS valor_total 
FROM public.vendedores v
JOIN public.clientes c ON v.id_vendedor = c.id_vendedor
JOIN public.pedido p ON c.id_cliente = p.id_cliente
JOIN public.itens_pedido ip ON p.id_pedido = ip.id_pedido 
GROUP BY  v.id_vendedor, v.nome 
ORDER BY v.nome ASC
