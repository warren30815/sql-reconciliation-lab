DROP FUNCTION IF EXISTS get_ar_ap_summary_udf(date, date);

CREATE FUNCTION get_ar_ap_summary_udf(start_date DATE, end_date DATE)
RETURNS TABLE (
  user_id UUID,
  ar_balance NUMERIC(10,0),
  ap_balance NUMERIC(10,0),
  ar_count BIGINT,
  ap_count BIGINT,
  avg_ar NUMERIC(10,0),
  avg_ap NUMERIC(10,0),
  net_balance NUMERIC(10,0)
) AS $$
BEGIN
  RETURN QUERY
  WITH ar AS (
    SELECT
      payee_id AS user_id,
      ROUND(SUM(amount), 0) AS total_ar,
      COUNT(*) AS ar_count,
      ROUND(AVG(amount), 0) AS avg_ar
    FROM ledger_transactions
    WHERE transaction_date BETWEEN start_date AND end_date
    GROUP BY payee_id
  ),
  ap AS (
    SELECT
      payer_id AS user_id,
      ROUND(SUM(amount), 0) AS total_ap,
      COUNT(*) AS ap_count,
      ROUND(AVG(amount), 0) AS avg_ap
    FROM ledger_transactions
    WHERE transaction_date BETWEEN start_date AND end_date
    GROUP BY payer_id
  ),
  summary AS (
    SELECT
      COALESCE(ar.user_id, ap.user_id) AS user_id,
      ROUND(COALESCE(ar.total_ar, 0), 0) AS ar_balance,
      ROUND(COALESCE(ap.total_ap, 0), 0) AS ap_balance,
      COALESCE(ar.ar_count, 0) AS ar_count,
      COALESCE(ap.ap_count, 0) AS ap_count,
      ROUND(COALESCE(ar.avg_ar, 0), 0) AS avg_ar,
      ROUND(COALESCE(ap.avg_ap, 0), 0) AS avg_ap,
      ROUND(COALESCE(ar.total_ar, 0) - COALESCE(ap.total_ap, 0), 0) AS net_balance
    FROM ar
    FULL OUTER JOIN ap ON ar.user_id = ap.user_id
  )
  SELECT
    summary.user_id,
    summary.ar_balance,
    summary.ap_balance,
    summary.ar_count,
    summary.ap_count,
    summary.avg_ar,
    summary.avg_ap,
    summary.net_balance
  FROM summary
  ORDER BY summary.net_balance DESC;
END;
$$ LANGUAGE plpgsql;

-- 測試

SELECT * FROM get_ar_ap_summary_udf('2024-01-06', '2024-02-04');
