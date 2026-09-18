-- Durable upstream refund identifier for refunds whose outcome is unknown.
--
-- Previously the identifier existed only in the REFUND_PENDING audit row, which
-- is written best-effort. If that insert failed, a REFUND_PENDING order had no
-- recoverable identifier and every later inquiry failed with "refund request
-- identifier missing" — an order with no way out. Store it on the order itself.
ALTER TABLE payment_orders
    ADD COLUMN IF NOT EXISTS provider_refund_id VARCHAR(128);

COMMENT ON COLUMN payment_orders.provider_refund_id IS
    'Upstream refund identifier (e.g. Antom refundRequestId) used to inquire about a refund whose result is not yet final';
