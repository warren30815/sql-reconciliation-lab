-- Create ledger_transactions table
DROP TABLE IF EXISTS ledger_transactions;

CREATE TABLE ledger_transactions (
    transaction_id BIGINT PRIMARY KEY,
    payer_id UUID NOT NULL,
    payee_id UUID NOT NULL,
    amount DECIMAL(10,2) NOT NULL CHECK (amount > 0),
    transaction_date DATE NOT NULL
);

-- Create indexes for better query performance
CREATE INDEX idx_ledger_transactions_payer_id ON ledger_transactions(payer_id);
CREATE INDEX idx_ledger_transactions_payee_id ON ledger_transactions(payee_id);
CREATE INDEX idx_ledger_transactions_date ON ledger_transactions(transaction_date);
CREATE INDEX idx_ledger_transactions_payer_date ON ledger_transactions(payer_id, transaction_date);
CREATE INDEX idx_ledger_transactions_payee_date ON ledger_transactions(payee_id, transaction_date);

-- Load data from CSV file
-- Note: Update the path below to match your actual file location
\COPY ledger_transactions FROM 'data/ledger_transactions.csv' WITH CSV HEADER;

-- Add some comments about the users for reference
COMMENT ON TABLE ledger_transactions IS 'Main ledger table containing all financial transactions between users';
COMMENT ON COLUMN ledger_transactions.transaction_id IS 'Snowflake ID for unique transaction identification';
COMMENT ON COLUMN ledger_transactions.payer_id IS 'UUID of the user making the payment';
COMMENT ON COLUMN ledger_transactions.payee_id IS 'UUID of the user receiving the payment';
COMMENT ON COLUMN ledger_transactions.amount IS 'Transaction amount in currency units (always positive)';
COMMENT ON COLUMN ledger_transactions.transaction_date IS 'Date when the transaction occurred';

-- Display success message
SELECT 'Ledger transactions table created and seeded successfully!' as status;
SELECT COUNT(*) as total_transactions FROM ledger_transactions;
