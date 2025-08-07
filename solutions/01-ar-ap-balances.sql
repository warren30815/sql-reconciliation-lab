WITH ar AS (
  SELECT
    payee_id AS user_id,
    COALESCE(SUM(amount), 0) AS ar_balance
  FROM ledger_transactions
  GROUP BY payee_id
),
ap AS (
  SELECT
    payer_id AS user_id,
    COALESCE(SUM(amount), 0) AS ap_balance
  FROM ledger_transactions
  GROUP BY payer_id
),
users AS (
  SELECT user_id FROM ar
  UNION
  SELECT user_id FROM ap
)
SELECT
  u.user_id,
  COALESCE(ar.ar_balance, 0) AS ar_balance,
  COALESCE(ap.ap_balance, 0) AS ap_balance,
  COALESCE(ar.ar_balance, 0) - COALESCE(ap.ap_balance, 0) AS net_balance
FROM users u
LEFT JOIN ar ON u.user_id = ar.user_id
LEFT JOIN ap ON u.user_id = ap.user_id
ORDER BY net_balance DESC;