SELECT id_empresa, SUM(valor_total) FROM public.pedido GROUP BY id_empresa