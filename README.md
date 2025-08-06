# sql-reconciliation-lab

A hands-on SQL exercise set for practicing ledger reconciliation, cashflow tracking, and AR/AP analytics using raw transaction data.

---

## Background

This repository simulates real-world financial reconciliation scenarios. You'll work with raw ledger transactions that record who paid whom, how much, and when. The goal is to derive key business metrics such as AR/AP balances, running balances using SQL.

---

## Goals

Through this exercise, you'll learn to:

- Compute Accounts Receivable (AR) and Accounts Payable (AP) balances.
- Track running balances per user.
- Calculate average balances over past N-day windows.

---

## Dataset

The dataset simulates simplified ledger transactions with the following fields:

| Column             | Description                              |
|--------------------|------------------------------------------|
| transaction_id     | Unique ID of the transaction             |
| payer_id           | ID of the paying user/company            |
| payee_id           | ID of the receiving user/company         |
| amount             | Transaction amount (positive number)     |
| transaction_date   | Date of transaction (YYYY-MM-DD)         |

Dataset file: `data/ledger_transactions.csv`

---

## Exercises

### 1. User AR/AP Balances
Compute the latest accounts receivable (AR) and accounts payable (AP) per user.

### 2. Running Balance per User
Calculate a running balance (cumulative sum) of each user’s ledger over time.

### 3. Average Balance over Past N Days
For a given date, compute the average balance for each user over the past 30 days.

> Exercise descriptions and tasks are located in `/exercises/{exercise_name}.md`.

---

## Getting Started (MacOS Setup)

### Recommended Database GUI

For easier query writing and result browsing, it's recommended to use [DBeaver](https://dbeaver.io/), a free universal database client.

After installation, you can connect to your local PostgreSQL database through DBeaver's connection wizard.

### 1. Fork and Start Practicing

1. Fork this repository to your own GitHub account.
2. Git clone the forked repository.
3. Navigate to `/exercises/` and attempt each SQL task.
4. You can save your own solutions in your forked repo under `/solutions/`.

### 2. Install PostgreSQL (using Homebrew)

```bash
brew install postgresql
brew services start postgresql
```

Verify installation:
```bash
psql --version
```

### 3. Create Database User

Create a PostgreSQL user for this project (replace `ledger_user` and `yourpassword` as needed):

```bash
psql postgres
CREATE USER ledger_user WITH PASSWORD 'yourpassword';
\q
```

### 4. Create Database (with User)

Create the database and set the owner to your new user:

```bash
createdb ledger_practice -O ledger_user
```

### 5. Seed Data into PostgreSQL

Run the provided seed script to load the dataset into PostgreSQL:

```bash
cd <repository>
psql -U ledger_user ledger_practice < seed_data/seed_ledger_transactions.sql
```

You should now have a table named `ledger_transactions` with sample data.

### 6. Connect to Database

Use dbeaver GUI, connection settings:
```
Host: localhost
Port: 5432
Database: ledger_practice
Username: ledger_user
Password: yourpassword
```
