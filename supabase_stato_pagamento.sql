-- ============================================================
-- ROST 81 — Aggiunta colonne stato e pagamento a rost81_clienti
-- Eseguire nel Supabase SQL Editor
-- ============================================================

ALTER TABLE rost81_clienti
  ADD COLUMN IF NOT EXISTS stato text NOT NULL DEFAULT 'ATTIVO'
    CHECK (stato IN ('ATTIVO','INATTIVO','SOSPESO')),
  ADD COLUMN IF NOT EXISTS pagamento text NOT NULL DEFAULT 'REGOLARE'
    CHECK (pagamento IN ('REGOLARE','DEBITORE'));

-- Tutti gli esistenti → ATTIVO
UPDATE rost81_clienti SET stato = 'ATTIVO' WHERE stato IS NULL OR stato = '';

-- Debitori rilevati dalla colonna note
UPDATE rost81_clienti SET pagamento = 'DEBITORE' WHERE note ILIKE '%DEBITORE%';
UPDATE rost81_clienti SET pagamento = 'REGOLARE' WHERE note NOT ILIKE '%DEBITORE%' OR note IS NULL;
