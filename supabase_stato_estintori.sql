-- ============================================================
-- ROST 81 — Aggiungi colonna stato a rost81_magazzino
-- Eseguire nel Supabase SQL Editor
-- ============================================================

ALTER TABLE rost81_magazzino
  ADD COLUMN IF NOT EXISTS stato text DEFAULT 'NUOVO'
    CHECK (stato IN ('NUOVO', 'REVISIONATO', 'DA REVISIONARE', 'DA SMALTIRE'));

-- Aggiorna gli articoli esistenti senza stato
UPDATE rost81_magazzino SET stato = 'NUOVO' WHERE stato IS NULL;
