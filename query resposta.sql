SET search_path TO natural_one; 
SELECT distinct 
spedf.fornecedor[6] As emit_cnpj, 
spedf.fornecedor[8] As emit_ie, 
spedf.fornecedor[4] As razao_social, 
(select uf from public.ibge_ufs where codigo=substring(spedf.fornecedor[9], 0, 3)::int) As uf 
FROM 
( SELECT cab.cnpj, c4_cab.dt_ini, 
c4_cab.reg AS reg_cab, 
string_to_array(c4_cab.linha, '|'::text) AS c4_cab, 
c4_det1.reg AS reg_det1, 
string_to_array(c4_det1.linha, '|'::text) AS c4_det1, 
string_to_array(fornecedor.linha, '|'::text) AS fornecedor 
FROM 
( SELECT cab_1.id, 
cab_1.tipo, 
cab_1.versao, 
cab_1.cod_finalidade, 
cab_1.cnpj, 
cab_1.dt_ini, 
cab_1.dt_fin 
FROM tb_sped_cab cab_1 WHERE ((cab_1.tipo, cab_1.versao::text, cab_1.cod_finalidade, cab_1.cnpj::text, cab_1.dt_ini)
 IN ( SELECT tb_sped_cab.tipo, tb_sped_cab.versao, max(tb_sped_cab.cod_finalidade) AS cod_finalidade, 
 tb_sped_cab.cnpj,
 tb_sped_cab.dt_ini 
 FROM tb_sped_cab WHERE tb_sped_cab.tipo in (1, 2) and dt_ini between '2017-08-01' and '2018-03-31' 
 GROUP BY tb_sped_cab.tipo, tb_sped_cab.versao, tb_sped_cab.cnpj, tb_sped_cab.dt_ini))) cab 
 LEFT JOIN tb_sped_det c4_cab ON cab.id = c4_cab.id_sped AND (c4_cab.reg::text = ANY (ARRAY['C100'::character varying::text]))
 LEFT JOIN tb_sped_det c4_det1 ON c4_cab.id_sped = c4_det1.id_sped AND c4_cab.id = c4_det1.reg_pai AND (c4_det1.reg::text = ANY (ARRAY['C170'::character varying::text])) 
 LEFT JOIN tb_sped_det fornecedor ON fornecedor.id_sped = cab.id AND (string_to_array(fornecedor.linha, '|'::text))[3] = (string_to_array(c4_cab.linha, '|'::text))[5] 
 AND fornecedor.reg::text = '0150'::text ) As spedf where spedf.c4_cab[3] = '0' and spedf.c4_cab[4] = '1' and spedf.c4_det1[12] 
 not like ALL (ARRAY['%410', '%201', '%910', '%911', '%151', '%557', '%949']) order by spedf.fornecedor[6];