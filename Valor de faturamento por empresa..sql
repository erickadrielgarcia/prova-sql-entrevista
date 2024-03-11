SELECT p.id_empresa, e.razao_social, SUM(valor_total) 
FROM public.pedido p 
JOIN public.empresa e ON e.id_empresa = p.id_empresa
GROUP BY p.id_empresa, e.razao_social
