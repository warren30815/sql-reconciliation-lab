# Exercise 3: Average Balance over Past N Days

## Objective
For a given date, compute the average balance for each user over the past 30 days.

## Background
This analysis helps understand a user's typical financial position over a rolling window, smoothing out daily fluctuations. It's useful for credit assessments and cash flow planning.

## Task
Write a SQL query that:
1. Takes a target date as input (use 2024-02-05 for this exercise)
2. For each user, calculates their daily balance for the past 30 days (from 2024-01-07 to 2024-02-05)
3. Computes the average balance over this 30-day period
4. Only includes users who had at least one transaction in the period

## Sample Input Data
Using transactions from 2024-01-07 to 2024-02-05 for 30-day average calculation:
```
transaction_id         | payer_id                             | payee_id                             | amount  | transaction_date
1580515618419523594    | a7b8c9d0-1234-4567-89ab-cdef01234567 | c3d4e5f6-3456-6789-abcd-ef0123456789 | 2500.00 | 2024-01-08
1580515618419523598    | d4e5f6a7-4567-789a-bcde-f01234567890 | a7b8c9d0-1234-4567-89ab-cdef01234567 | 1650.00 | 2024-01-10
1580515618419523601    | a7b8c9d0-1234-4567-89ab-cdef01234567 | b2c3d4e5-2345-5678-9abc-def012345678 | 1950.00 | 2024-01-12
1580515618419523604    | b2c3d4e5-2345-5678-9abc-def012345678 | a7b8c9d0-1234-4567-89ab-cdef01234567 | 2250.00 | 2024-01-15
1580515618419523606    | a7b8c9d0-1234-4567-89ab-cdef01234567 | e5f6a7b8-5678-89ab-cdef-012345678901 | 2800.00 | 2024-01-16
1580515618419523610    | c3d4e5f6-3456-6789-abcd-ef0123456789 | a7b8c9d0-1234-4567-89ab-cdef01234567 | 2400.00 | 2024-01-18
1580515618419523612    | a7b8c9d0-1234-4567-89ab-cdef01234567 | c3d4e5f6-3456-6789-abcd-ef0123456789 | 3100.00 | 2024-01-19
1580515618419523616    | e5f6a7b8-5678-89ab-cdef-012345678901 | a7b8c9d0-1234-4567-89ab-cdef01234567 | 2350.00 | 2024-01-23
1580515618419523617    | a7b8c9d0-1234-4567-89ab-cdef01234567 | b2c3d4e5-2345-5678-9abc-def012345678 | 1700.00 | 2024-01-24
1580515618419523622    | a7b8c9d0-1234-4567-89ab-cdef01234567 | d4e5f6a7-4567-789a-bcde-f01234567890 | 2750.00 | 2024-01-26
1580515618419523625    | c3d4e5f6-3456-6789-abcd-ef0123456789 | a7b8c9d0-1234-4567-89ab-cdef01234567 | 1850.00 | 2024-01-30
1580515618419523627    | a7b8c9d0-1234-4567-89ab-cdef01234567 | b2c3d4e5-2345-5678-9abc-def012345678 | 1400.00 | 2024-01-31
1580515618419523631    | e5f6a7b8-5678-89ab-cdef-012345678901 | a7b8c9d0-1234-4567-89ab-cdef01234567 | 1900.00 | 2024-02-02
1580515618419523632    | a7b8c9d0-1234-4567-89ab-cdef01234567 | c3d4e5f6-3456-6789-abcd-ef0123456789 | 2800.00 | 2024-02-02
```

## Expected Output for Sample
For user `a7b8c9d0-1234-4567-89ab-cdef01234567` with target date 2024-02-05:
- Starting balance on 2024-01-07: 1750.50 (from Exercise 2 running balance)
- Daily balance calculations over 30-day window (2024-01-07 to 2024-02-05)
- Average = Sum of daily balances / 30 days

```
user_id                              | target_date | avg_balance_30d | days_with_activity
a7b8c9d0-1234-4567-89ab-cdef01234567 | 2024-02-05  |         1125.83 |                12
```

## Hints
1. First, create a date series for the 30-day window
2. Calculate the running balance for each user up to each date in the window
3. Handle days with no transactions (balance remains the same as previous day)
4. Use window functions to compute running sums
5. Consider using GENERATE_SERIES() to create the date range

## Advanced Challenges
1. Make the number of days (30) a parameter
2. Handle cases where users have no transactions in the window
3. Calculate both simple average and weighted average (by transaction amounts)

## Edge Cases to Consider
- Users with no transactions in the 30-day window
- Users whose first transaction is within the 30-day window
- Days with multiple transactions

## Validation
- Each user should have exactly 30 daily balance entries (one per day in the window)
- The average balance should be mathematically correct: sum of daily balances / 30
- Days with no transactions should carry forward the previous day's balance
- The final day's balance should match the running balance from Exercise 2
