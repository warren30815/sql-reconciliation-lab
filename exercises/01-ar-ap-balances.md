# Exercise 1: User AR/AP Balances

## Objective
Compute the latest accounts receivable (AR) and accounts payable (AP) per user.

## Background
- **Accounts Receivable (AR)**: Money owed TO a user (they are the payee)
- **Accounts Payable (AP)**: Money owed BY a user (they are the payer)

## Task
Write a SQL query that calculates:
1. Total AR balance per user (sum of amounts where user is payee)
2. Total AP balance per user (sum of amounts where user is payer)
3. Net balance per user (AR - AP)

## Expected Output Format
```
user_id                              | ar_balance | ap_balance | net_balance
-------------------------------------|------------|------------|------------
<user_id>                            |       0.00 |       0.00 |        0.00
...
```

## Sample Input Data
Using transactions from 2024-01-02 to 2024-01-06:
```
transaction_id         | payer_id                             | payee_id                             | amount  | transaction_date
1580515618419523584    | a7b8c9d0-1234-4567-89ab-cdef01234567 | b2c3d4e5-2345-5678-9abc-def012345678 | 1500.00 | 2024-01-02
1580515618419523585    | c3d4e5f6-3456-6789-abcd-ef0123456789 | a7b8c9d0-1234-4567-89ab-cdef01234567 | 2750.50 | 2024-01-02
1580515618419523588    | a7b8c9d0-1234-4567-89ab-cdef01234567 | e5f6a7b8-5678-89ab-cdef-012345678901 | 3500.00 | 2024-01-04
1580515618419523592    | e5f6a7b8-5678-89ab-cdef-012345678901 | a7b8c9d0-1234-4567-89ab-cdef01234567 | 4000.00 | 2024-01-06
```

## Expected Output for Sample
For user `a7b8c9d0-1234-4567-89ab-cdef01234567`:
- AR (money owed to them): 2750.50 + 4000.00 = 6750.50
- AP (money they owe): 1500.00 + 3500.00 = 5000.00
- Net balance: 6750.50 - 5000.00 = 1750.50

## Hints
1. Use UNION ALL or separate CTEs to calculate AR and AP
2. Consider using COALESCE for users who might not have AR or AP transactions
3. Order results by net_balance DESC to see who has the highest net receivables

## Advanced Challenge
1. Add date range filtering to calculate AR/AP balances for a specific time period (use WHERE clause on transaction_date)
2. Include additional metrics like average transaction size and transaction count per user
3. Create a summary showing users with the highest net balance and their dominant transaction type

## Validation
Your query should return exactly 5 users (the 5 UUIDs in the dataset).
