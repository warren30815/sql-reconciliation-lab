WITH ar AS (
SELECT
    payee_id AS user_id,
    SUM(amount) AS total_ar,
    COUNT(*) AS ar_count,
    AVG(amount) AS avg_ar
  FROM ledger_transactions
  WHERE transaction_date BETWEEN '2024-01-02' AND '2024-02-05'
  GROUP BY payee_id
),
ap AS (
  SELECT
    payer_id AS user_id,
    SUM(amount) AS total_ap,
    COUNT(*) AS ap_count,
    AVG(amount) AS avg_ap
  FROM ledger_transactions
  WHERE transaction_date BETWEEN '2024-01-02' AND '2024-02-05'
  GROUP BY payer_id
),
summary AS (
  SELECT
    COALESCE(ar.user_id, ap.user_id) AS user_id,
    COALESCE(total_ar, 0) AS ar_balance,
    COALESCE(total_ap, 0) AS ap_balance,
    COALESCE(ar_count, 0) AS ar_count,
    COALESCE(ap_count, 0) AS ap_count,
    COALESCE(avg_ar, 0) AS avg_ar,
    COALESCE(avg_ap, 0) AS avg_ap,
    COALESCE(total_ar, 0) - COALESCE(total_ap, 0) AS net_balance,
    CASE
      WHEN COALESCE(total_ar, 0) > COALESCE(total_ap, 0) THEN 'AR'
      WHEN COALESCE(total_ap, 0) > COALESCE(total_ar, 0) THEN 'AP'
      ELSE 'Neutral'
    END AS dominant_type
  FROM ar
  FULL OUTER JOIN ap ON ar.user_id = ap.user_id
)
SELECT *
FROM summary
ORDER BY net_balance DESC;