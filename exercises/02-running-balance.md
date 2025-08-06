# Exercise 2: Running Balance per User

## Objective
Calculate a running balance (cumulative sum) of each user's ledger over time.

## Background
A running balance shows how a user's net position changes over time. For each transaction:
- If user is the payer: balance decreases (negative impact)
- If user is the payee: balance increases (positive impact)

## Task
Write a SQL query that shows:
1. Each user's transaction history chronologically
2. The impact of each transaction on their balance (+/- amount)
3. A running total of their balance after each transaction

## Expected Output Format
```
user_id                              | transaction_date | transaction_impact | running_balance
-------------------------------------|------------------|-------------------|----------------
<user_id>                            | YYYY-MM-DD       |              0.00 |            0.00
...
```

## Sample Input Data
Using transactions from 2024-01-02 to 2024-01-12:
```
transaction_id         | payer_id                             | payee_id                             | amount  | transaction_date
1580515618419523584    | a7b8c9d0-1234-4567-89ab-cdef01234567 | b2c3d4e5-2345-5678-9abc-def012345678 | 1500.00 | 2024-01-02
1580515618419523585    | c3d4e5f6-3456-6789-abcd-ef0123456789 | a7b8c9d0-1234-4567-89ab-cdef01234567 | 2750.50 | 2024-01-02
1580515618419523588    | a7b8c9d0-1234-4567-89ab-cdef01234567 | e5f6a7b8-5678-89ab-cdef-012345678901 | 3500.00 | 2024-01-04
1580515618419523592    | e5f6a7b8-5678-89ab-cdef-012345678901 | a7b8c9d0-1234-4567-89ab-cdef01234567 | 4000.00 | 2024-01-06
1580515618419523594    | a7b8c9d0-1234-4567-89ab-cdef01234567 | c3d4e5f6-3456-6789-abcd-ef0123456789 | 2500.00 | 2024-01-08
1580515618419523598    | d4e5f6a7-4567-789a-bcde-f01234567890 | a7b8c9d0-1234-4567-89ab-cdef01234567 | 1650.00 | 2024-01-10
1580515618419523601    | a7b8c9d0-1234-4567-89ab-cdef01234567 | b2c3d4e5-2345-5678-9abc-def012345678 | 1950.00 | 2024-01-12
```

## Expected Output for Sample
For user `a7b8c9d0-1234-4567-89ab-cdef01234567`:
```
user_id                              | transaction_date | transaction_impact | running_balance
a7b8c9d0-1234-4567-89ab-cdef01234567 | 2024-01-02       |           -1500.00 |        -1500.00
a7b8c9d0-1234-4567-89ab-cdef01234567 | 2024-01-02       |            2750.50 |         1250.50
a7b8c9d0-1234-4567-89ab-cdef01234567 | 2024-01-04       |           -3500.00 |        -2249.50
a7b8c9d0-1234-4567-89ab-cdef01234567 | 2024-01-06       |            4000.00 |         1750.50
a7b8c9d0-1234-4567-89ab-cdef01234567 | 2024-01-08       |           -2500.00 |         -749.50
a7b8c9d0-1234-4567-89ab-cdef01234567 | 2024-01-10       |            1650.00 |          900.50
a7b8c9d0-1234-4567-89ab-cdef01234567 | 2024-01-12       |           -1950.00 |        -1049.50
```

## Hints
1. Use UNION ALL to combine payer and payee transactions for each user
2. Use window functions (SUM() OVER()) for the running balance calculation
3. ORDER BY user_id, transaction_date, transaction_id for consistent ordering
4. Consider what happens when multiple transactions occur on the same date

## Advanced Challenge
Include the transaction_id and counterparty (who they paid/received from) in your output.

## Validation
The final running_balance for each user should match their net_balance from Exercise 1.
