SELECT p.id_cliente, c.razao_social, SUM(valor_total) 
FROM public.pedido p 
JOIN public.clientes c ON c.id_cliente = p.id_cliente
GROUP BY p.id_cliente, c.razao_social
