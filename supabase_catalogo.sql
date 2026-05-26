-- ============================================================
-- ROST 81 — Catalogo Prodotti + Aggiornamento Magazzino
-- Eseguire nel Supabase SQL Editor
-- ============================================================

-- 1. CREA TABELLA CATALOGO
CREATE TABLE IF NOT EXISTS rost81_catalogo (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  macrocategoria  text NOT NULL,
  agente          text NOT NULL,
  nome            text NOT NULL,
  classi_ok       text[],
  classi_no       text[],
  normativa       text[],
  piano_manutenzione jsonb DEFAULT '[]',
  taglie          jsonb DEFAULT '[]',
  avviso          text,
  note_tecniche   text,
  created_at      timestamptz DEFAULT now()
);

ALTER TABLE rost81_catalogo ENABLE ROW LEVEL SECURITY;
CREATE POLICY "anon_all" ON rost81_catalogo
  FOR ALL TO anon USING (true) WITH CHECK (true);

-- 2. AGGIORNA TABELLA MAGAZZINO
ALTER TABLE rost81_magazzino
  ADD COLUMN IF NOT EXISTS catalogo_id uuid REFERENCES rost81_catalogo(id),
  ADD COLUMN IF NOT EXISTS taglia text;

-- 3. INSERISCI LE 4 SCHEDE TECNICHE ESTINTORI

INSERT INTO rost81_catalogo
  (macrocategoria, agente, nome, classi_ok, classi_no, normativa,
   piano_manutenzione, taglie, avviso, note_tecniche)
VALUES

-- ── SCHEDA 1: CO₂ ──────────────────────────────────────────
(
  'Estintori',
  'CO₂',
  'Estintore a CO₂ — Anidride Carbonica',
  ARRAY[
    'B – Liquidi infiammabili (benzina, solventi, alcol, vernici)',
    'C – Gas infiammabili (metano, propano, butano)',
    'E – Apparecchiature elettriche sotto tensione'
  ],
  ARRAY[
    'A – Solidi (legno, carta, plastica) — CO₂ si disperde troppo rapidamente',
    'F – Olii da cucina bollenti'
  ],
  ARRAY[
    'EN 3-7:2004 + A1:2007',
    'D.M. 7 gennaio 2005',
    'D.Lgs. 81/2008 – Art. 46',
    'D.M. 10 marzo 1998',
    'UNI 9994-1:2013',
    'PED 2014/68/UE (collaudo cilindro)'
  ],
  '[
    {"freq":"Ogni 6 mesi","desc":"Sorveglianza — ispezione visiva: sigilli, valvola, posizione, manometro"},
    {"freq":"Ogni 12 mesi","desc":"Controllo periodico — verifica peso CO₂ e funzionalità valvola (tecnico abilitato)"},
    {"freq":"Ogni 6 anni","desc":"Revisione — smontaggio completo, verifica componenti e ricarica CO₂"},
    {"freq":"Ogni 12 anni","desc":"Collaudo — prova idraulica del cilindro (PED 2014/68/UE)"}
  ]'::jsonb,
  '[
    {"taglia":"2 kg","nome":"Estintore CO₂ 2 kg","codice":"K2","pressione":"150 bar","efficacia":"34B","gittata":"1,5–2,5 m","scarica":"≈ 8 s","peso":"≈ 6,5 kg","tipo":"portatile"},
    {"taglia":"5 kg","nome":"Estintore CO₂ 5 kg","codice":"K5","pressione":"150 bar","efficacia":"89B","gittata":"2–3 m","scarica":"≈ 12 s","peso":"≈ 14,5 kg","tipo":"portatile"},
    {"taglia":"10 kg","nome":"Estintore CO₂ 10 kg","codice":"K10","pressione":"150 bar","efficacia":"89B","gittata":"3–5 m","scarica":"≈ 20 s","peso":"≈ 27 kg","tipo":"portatile"},
    {"taglia":"Carrellato 18 kg","nome":"Estintore CO₂ carrellato 18 kg","codice":null,"pressione":"150 bar","efficacia":"144B","gittata":"4–6 m","scarica":"≈ 35 s","peso":"≈ 50 kg","tipo":"carrellato"},
    {"taglia":"Carrellato 30 kg","nome":"Estintore CO₂ carrellato 30 kg","codice":null,"pressione":"150 bar","efficacia":"233B","gittata":"4–6 m","scarica":"≈ 45 s","peso":"≈ 80 kg","tipo":"carrellato"}
  ]'::jsonb,
  'CO₂ non lascia residui — ideale per server room, archivi, quadri elettrici, laboratori. NON usare in ambienti molto confinati: il gas riduce l''ossigeno e può causare asfissia. Non conduce elettricità.',
  'Agente gassoso, non conduttore, a dispersione rapida. Tubo flessibile certificato EN 853. Codici interni ROST 81: K2 (2 kg), K5 (5 kg), K10 (10 kg).'
),

-- ── SCHEDA 2: Polvere ABC ──────────────────────────────────
(
  'Estintori',
  'Polvere ABC',
  'Estintore a Polvere Polivalente ABC',
  ARRAY[
    'A – Solidi (legno, carta, plastica, tessuti)',
    'B – Liquidi infiammabili (benzina, solventi, vernici)',
    'C – Gas infiammabili (metano, propano, butano)'
  ],
  ARRAY[
    'E – Apparecchiature elettriche (polvere corrosiva e abrasiva, danneggia componenti)',
    'F – Olii da cucina bollenti'
  ],
  ARRAY[
    'EN 3-7:2004 + A1:2007',
    'D.M. 7 gennaio 2005',
    'D.Lgs. 81/2008 – Art. 46',
    'D.M. 10 marzo 1998',
    'UNI 9994-1:2013'
  ],
  '[
    {"freq":"Ogni 6 mesi","desc":"Sorveglianza — ispezione visiva: manometro, sigilli, pesatura indicativa"},
    {"freq":"Ogni 12 mesi","desc":"Controllo periodico — verifica valvola, tubo flessibile e ugello (tecnico abilitato)"},
    {"freq":"Ogni 3 anni","desc":"Revisione — sostituzione polvere ABC e ricarica gas propellente N₂"},
    {"freq":"Ogni 6 anni","desc":"Collaudo — prova idraulica del cilindro"}
  ]'::jsonb,
  '[
    {"taglia":"1 kg","nome":"Estintore Polvere ABC 1 kg","codice":null,"pressione":"15 bar N₂","efficacia":"5A 21B C","gittata":"2–3 m","scarica":"≈ 6 s","peso":"≈ 1,9 kg","tipo":"portatile"},
    {"taglia":"2 kg","nome":"Estintore Polvere ABC 2 kg","codice":null,"pressione":"15 bar N₂","efficacia":"8A 34B C","gittata":"2,5–3,5 m","scarica":"≈ 8 s","peso":"≈ 3,2 kg","tipo":"portatile"},
    {"taglia":"4 kg","nome":"Estintore Polvere ABC 4 kg","codice":null,"pressione":"15 bar N₂","efficacia":"13A 70B C","gittata":"3–5 m","scarica":"≈ 12 s","peso":"≈ 6 kg","tipo":"portatile"},
    {"taglia":"6 kg","nome":"Estintore Polvere ABC 6 kg","codice":null,"pressione":"15 bar N₂","efficacia":"21A 113B C","gittata":"4–5 m","scarica":"≈ 15 s","peso":"≈ 9 kg","tipo":"portatile"},
    {"taglia":"9 kg","nome":"Estintore Polvere ABC 9 kg","codice":null,"pressione":"15 bar N₂","efficacia":"27A 144B C","gittata":"5–6 m","scarica":"≈ 18 s","peso":"≈ 13 kg","tipo":"portatile"},
    {"taglia":"12 kg","nome":"Estintore Polvere ABC 12 kg","codice":null,"pressione":"15 bar N₂","efficacia":"34A 183B C","gittata":"6–7 m","scarica":"≈ 22 s","peso":"≈ 17 kg","tipo":"portatile"},
    {"taglia":"Carrellato 25 kg","nome":"Estintore Polvere ABC carrellato 25 kg","codice":null,"pressione":"15 bar N₂","efficacia":"43A 233B C","gittata":"7–9 m","scarica":"≈ 30 s","peso":"≈ 50 kg","tipo":"carrellato"},
    {"taglia":"Carrellato 50 kg","nome":"Estintore Polvere ABC carrellato 50 kg","codice":null,"pressione":"15 bar N₂","efficacia":"55A 297B C","gittata":"8–10 m","scarica":"≈ 45 s","peso":"≈ 90 kg","tipo":"carrellato"}
  ]'::jsonb,
  'La polvere lascia residui che possono danneggiare gravemente apparecchiature elettroniche e ottiche. Dopo l''utilizzo arieggiare il locale e pulire accuratamente. NON usare su quadri elettrici o server.',
  'L''agente più versatile (A+B+C). Propellente azoto N₂ a pressione permanente. Il più diffuso in ambito civile e industriale. Revisione ogni 3 anni per sostituzione polvere.'
),

-- ── SCHEDA 3: Acqua & Schiuma ──────────────────────────────
(
  'Estintori',
  'Acqua & Schiuma',
  'Estintore ad Acqua e Schiuma AFFF',
  ARRAY[
    'A – Solidi (legno, carta, plastica, tessuti) — tutte le varianti',
    'B – Liquidi infiammabili — Acqua nebulizzata e Schiuma AFFF',
    'E – Apparecchiature elettriche — solo versioni dielettriche nebulizzata'
  ],
  ARRAY[
    'C – Gas infiammabili (acqua non blocca la fonte di gas)',
    'E – Apparecchiature elettriche (acqua standard conduce corrente)',
    'F – Olii da cucina bollenti (rischio esplosione vapore con acqua)'
  ],
  ARRAY[
    'EN 3-7:2004 + A1:2007',
    'D.M. 7 gennaio 2005',
    'D.Lgs. 81/2008 – Art. 46',
    'D.M. 10 marzo 1998',
    'UNI 9994-1:2013'
  ],
  '[
    {"freq":"Ogni 6 mesi","desc":"Sorveglianza — ispezione visiva: sigilli, manometro, boccaglio e supporto"},
    {"freq":"Ogni 12 mesi","desc":"Controllo periodico — verifica concentrazione agente estinguente (tecnico abilitato)"},
    {"freq":"Ogni 3 anni","desc":"Revisione — sostituzione agente estinguente e ricarica gas propellente N₂"},
    {"freq":"Ogni 6 anni","desc":"Collaudo — prova idraulica del cilindro"}
  ]'::jsonb,
  '[
    {"taglia":"Acqua 6 lt","nome":"Estintore Acqua 6 lt","codice":null,"pressione":"13 bar N₂","efficacia":"13A","gittata":"8–10 m","scarica":"≈ 60 s","peso":"≈ 10 kg","tipo":"portatile"},
    {"taglia":"Acqua Nebulizzata 6 lt","nome":"Estintore Acqua Nebulizzata 6 lt","codice":null,"pressione":"13 bar N₂","efficacia":"13A 183B","gittata":"3–5 m","scarica":"≈ 60 s","peso":"≈ 10 kg","tipo":"portatile"},
    {"taglia":"Schiuma AFFF 6 lt","nome":"Estintore Schiuma AFFF 6 lt","codice":null,"pressione":"13 bar N₂","efficacia":"21A 144B","gittata":"4–6 m","scarica":"≈ 60 s","peso":"≈ 10 kg","tipo":"portatile"},
    {"taglia":"Schiuma AFFF 9 lt","nome":"Estintore Schiuma AFFF 9 lt","codice":null,"pressione":"13 bar N₂","efficacia":"27A 183B","gittata":"5–7 m","scarica":"≈ 90 s","peso":"≈ 14,5 kg","tipo":"portatile"}
  ]'::jsonb,
  'MAI usare acqua semplice su fuochi di classe B (rischio esplosione e propagazione) o F (rischio violenta proiezione di olio bollente). La Schiuma AFFF conduce elettricità: non usare su apparecchiature sotto tensione.',
  'Acqua nebulizzata: gocce finissime riducono il rischio di conduzione elettrica (verificare certificazione dielettrica). AFFF forma un film acquoso che soffoca i fuochi di liquidi. Propellente N₂ a pressione permanente.'
),

-- ── SCHEDA 4: Speciali ─────────────────────────────────────
(
  'Estintori',
  'Speciali',
  'Estintori Speciali — Gas Pulito HFC-227ea e Classe F',
  ARRAY[
    'B – Liquidi infiammabili — HFC-227ea',
    'C – Gas infiammabili — HFC-227ea',
    'E – Apparecchiature elettriche sotto tensione — HFC-227ea',
    'F – Olii da cucina bollenti — Estintore Grasso/Classe F',
    'A – Solidi (limitato) — Estintore Grasso/Classe F'
  ],
  ARRAY[
    'A – Solidi — HFC-227ea non efficace su combustibili solidi',
    'F – Olii da cucina — HFC-227ea non adatto',
    'B/C/E – Estintore Grasso: non adatto per liquidi, gas o apparecchiature elettriche'
  ],
  ARRAY[
    'EN 3-7:2004 + A1:2007',
    'ISO 14520 (sistemi a gas pulito)',
    'D.M. 7 gennaio 2005',
    'D.Lgs. 81/2008 – Art. 46',
    'UNI 9994-1:2013',
    'PED 2014/68/UE (collaudo cilindro)'
  ],
  '[
    {"freq":"Ogni 6 mesi","desc":"Sorveglianza — ispezione visiva: sigilli, peso, posizione e manometro"},
    {"freq":"Ogni 12 mesi","desc":"Controllo periodico — verifica peso/pressione e valvola (tecnico abilitato)"},
    {"freq":"Ogni 6 anni","desc":"Revisione — smontaggio, verifica componenti e ricarica agente"},
    {"freq":"Ogni 12 anni","desc":"Collaudo — prova idraulica del cilindro (PED 2014/68/UE)"}
  ]'::jsonb,
  '[
    {"taglia":"Grasso / Classe F 6 lt","nome":"Estintore Grasso Classe F 6 lt","codice":null,"pressione":"13 bar N₂","efficacia":"75F","gittata":"1–2 m","scarica":"≈ 50 s","peso":"≈ 9 kg","tipo":"portatile"},
    {"taglia":"HFC-227ea 2 kg","nome":"Estintore Gas Pulito HFC-227ea 2 kg","codice":null,"pressione":"25 bar N₂","efficacia":"70B","gittata":"1,5–2,5 m","scarica":"≈ 8 s","peso":"≈ 4,5 kg","tipo":"portatile"},
    {"taglia":"HFC-227ea 6 kg","nome":"Estintore Gas Pulito HFC-227ea 6 kg","codice":null,"pressione":"25 bar N₂","efficacia":"144B","gittata":"2–3 m","scarica":"≈ 12 s","peso":"≈ 10,5 kg","tipo":"portatile"}
  ]'::jsonb,
  'GRASSO CLASSE F: MAI usare acqua o polvere su olii bollenti — rischio violenta proiezione e rifiamma. HFC-227ea (FM-200): gas pulito, ODP = 0, non lascia residui. Ideale per server room, sale CED, archivi storici. Tossicità bassa ma ventilare dopo scarica.',
  'HFC-227ea è sostituto dell''Halon, ODP=0, GWP=3220. Pressione di esercizio 25 bar con N₂. Estintore Classe F dotato di beccuccio lungo con schermo per evitare proiezione di olio bollente. Normativa carrellati: EN 1866-1.'
);
