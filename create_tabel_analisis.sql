CREATE OR REPLACE TABLE rekami_data.tabel_analisa AS
SELECT
  t.transaction_id,
  t.date,
  EXTRACT(YEAR FROM t.date) AS tahun,
  EXTRACT(MONTH FROM t.date) AS bulan,
  FORMAT_DATE('%Y-%m', t.date) AS tahun_bulan,

  t.branch_id,
  kc.branch_name,
  kc.kota,
  kc.provinsi,
  kc.rating AS rating_cabang,

  t.customer_name,
  t.product_id,
  p.product_name,
  p.price AS actual_price,
  t.discount_percentage,

  -- persentase gross laba
  CASE
    WHEN p.price <= 50000 THEN 0.10
    WHEN p.price <= 100000 THEN 0.15
    WHEN p.price <= 300000 THEN 0.20
    WHEN p.price <= 500000 THEN 0.25
    ELSE 0.30
  END AS persentase_gross_laba,

  -- nett sales (diskon dalam desimal)
  p.price * (1 - t.discount_percentage) AS nett_sales,

  -- nett profit (nett sales × persentase laba)
  (p.price * (1 - t.discount_percentage)) *
  CASE
    WHEN p.price <= 50000 THEN 0.10
    WHEN p.price <= 100000 THEN 0.15
    WHEN p.price <= 300000 THEN 0.20
    WHEN p.price <= 500000 THEN 0.25
    ELSE 0.30
  END AS nett_profit,

  t.rating AS rating_transaksi

FROM rekami_data.kf_final_transaction t
LEFT JOIN rekami_data.kf_product p USING (product_id)
LEFT JOIN rekami_data.kf_kantor_cabang kc USING (branch_id);
