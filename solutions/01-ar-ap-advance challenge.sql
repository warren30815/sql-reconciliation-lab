DROP FUNCTION IF EXISTS get_ar_ap_summary_udf(date, date);
--

CREATE FUNCTION get_ar_ap_summary_udf(start_date DATE, end_date DATE)
RETURNS TABLE (
  user_id UUID,
  ar_balance NUMERIC,
  ap_balance NUMERIC,
  ar_count BIGINT,
  ap_count BIGINT,
  avg_ar NUMERIC,
  avg_ap NUMERIC,
  net_balance NUMERIC,
  dominant_type TEXT
) AS $$
BEGIN
  RETURN QUERY
  WITH ar AS (
    SELECT
      payee_id AS user_id,
      SUM(amount) AS total_ar,
      COUNT(*) AS ar_count,
      AVG(amount) AS avg_ar
    FROM ledger_transactions
    WHERE transaction_date BETWEEN start_date AND end_date
    GROUP BY payee_id
  ),
  ap AS (
    SELECT
      payer_id AS user_id,
      SUM(amount) AS total_ap,
      COUNT(*) AS ap_count,
      AVG(amount) AS avg_ap
    FROM ledger_transactions
    WHERE transaction_date BETWEEN start_date AND end_date
    GROUP BY payer_id
  ),
  summary AS (
    SELECT
      COALESCE(ar.user_id, ap.user_id) AS user_id,
      COALESCE(ar.total_ar, 0) AS ar_balance,
      COALESCE(ap.total_ap, 0) AS ap_balance,
      COALESCE(ar.ar_count, 0) AS ar_count,
      COALESCE(ap.ap_count, 0) AS ap_count,
      COALESCE(ar.avg_ar, 0) AS avg_ar,
      COALESCE(ap.avg_ap, 0) AS avg_ap,
      COALESCE(ar.total_ar, 0) - COALESCE(ap.total_ap, 0) AS net_balance,
      CASE
        WHEN COALESCE(ar.total_ar, 0) > COALESCE(ap.total_ap, 0) THEN 'AR'
        WHEN COALESCE(ap.total_ap, 0) > COALESCE(ar.total_ar, 0) THEN 'AP'
        ELSE 'Neutral'
      END AS dominant_type
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
    summary.net_balance,
    summary.dominant_type
  FROM summary
  ORDER BY summary.net_balance DESC;
END;
$$ LANGUAGE plpgsql;

-- 
hSELECT * FROM get_ar_ap_summary_udf('2024-01-06', '2024-02-04');