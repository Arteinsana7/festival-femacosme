-- Festival Femacosme --
-- ============================================================
-- Chaque table est suivie de son RLS (Row Level Security).
-- ============================================================
 
 
-- ============================================================
-- scene — 
-- ============================================================
CREATE TABLE IF NOT EXISTS public. 
scene (
    id_scene        INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nom             VARCHAR(100) NOT NULL,
    lieu            VARCHAR(150),
    description     TEXT,
    ordre_affichage INTEGER NOT NULL DEFAULT 0
);
 
ALTER TABLE scene ENABLE ROW LEVEL SECURITY;
CREATE POLICY "lecture publique" ON scene
    FOR SELECT TO anon, authenticated USING (true);
 
 
-- ============================================================
-- jour — 
-- ============================================================
CREATE TABLE jour (
    id_jour   INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    date_jour DATE NOT NULL UNIQUE,
    libelle   VARCHAR(50) NOT NULL
);
 
ALTER TABLE jour ENABLE ROW LEVEL SECURITY;
CREATE POLICY "lecture publique" ON jour
    FOR SELECT TO anon, authenticated USING (true);
 
 
-- ============================================================
-- categorie — 
-- ============================================================
CREATE TABLE categorie (
    id_categorie INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    libelle      VARCHAR(80) NOT NULL UNIQUE
);
 
ALTER TABLE categorie ENABLE ROW LEVEL SECURITY;
CREATE POLICY "lecture publique" ON categorie
    FOR SELECT TO anon, authenticated USING (true);
 
 
-- ============================================================
-- artiste — 
-- ============================================================
CREATE TABLE artiste (
    id_artiste INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nom        VARCHAR(150) NOT NULL,
    bio        TEXT,
    photo_url  VARCHAR(500)
);
 
ALTER TABLE artiste ENABLE ROW LEVEL SECURITY;
CREATE POLICY "lecture publique" ON artiste
    FOR SELECT TO anon, authenticated USING (true);
 
 
-- ============================================================
-- pass — 
-- ============================================================
CREATE TABLE pass (
    id_pass         INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    libelle         VARCHAR(80) NOT NULL,
    prix            NUMERIC(8,2) NOT NULL CHECK (prix >= 0),
    url_billetterie VARCHAR(500) NOT NULL
);
 
ALTER TABLE pass ENABLE ROW LEVEL SECURITY;
CREATE POLICY "lecture publique" ON pass
    FOR SELECT TO anon, authenticated USING (true);
 
 
-- ============================================================
-- concert (dépend de scene et jour) — 
-- ============================================================
CREATE TABLE concert (
    id_concert  INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    heure_debut TIME NOT NULL,
    heure_fin   TIME NOT NULL,
    titre       VARCHAR(150),
    id_scene    INTEGER NOT NULL REFERENCES scene(id_scene),
    id_jour     INTEGER NOT NULL REFERENCES jour(id_jour),
    CHECK (heure_fin > heure_debut)
);
 
CREATE INDEX idx_concert_jour_scene ON concert(id_jour, id_scene);
CREATE INDEX idx_concert_debut ON concert(heure_debut);
 
ALTER TABLE concert ENABLE ROW LEVEL SECURITY;
CREATE POLICY "lecture publique" ON concert
    FOR SELECT TO anon, authenticated USING (true);
 
 
-- ============================================================
-- extrait_audio (dépend de artiste) — 
-- ============================================================
CREATE TABLE extrait_audio (
    id_extrait INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    titre      VARCHAR(150) NOT NULL,
    url        VARCHAR(500) NOT NULL,
    duree      INTEGER,  -- en secondes
    -- tout extrait appartient à un artiste (son nom s'affiche sur le player)
    id_artiste INTEGER NOT NULL REFERENCES artiste(id_artiste) ON DELETE CASCADE
);
 
CREATE INDEX idx_extrait_artiste ON extrait_audio(id_artiste);
 
ALTER TABLE extrait_audio ENABLE ROW LEVEL SECURITY;
CREATE POLICY "lecture publique" ON extrait_audio
    FOR SELECT TO anon, authenticated USING (true);
 
 
-- ============================================================
-- concert_artiste (liaison) — 
-- ============================================================
CREATE TABLE concert_artiste (
    id_concert INTEGER NOT NULL REFERENCES concert(id_concert) ON DELETE CASCADE,
    id_artiste INTEGER NOT NULL REFERENCES artiste(id_artiste) ON DELETE CASCADE,
    PRIMARY KEY (id_concert, id_artiste)
);
 
ALTER TABLE concert_artiste ENABLE ROW LEVEL SECURITY;
CREATE POLICY "lecture publique" ON concert_artiste
    FOR SELECT TO anon, authenticated USING (true);
 
 
-- ============================================================
-- artiste_categorie (liaison) — 
-- ============================================================
CREATE TABLE artiste_categorie (
    id_artiste   INTEGER NOT NULL REFERENCES artiste(id_artiste) ON DELETE CASCADE,
    id_categorie INTEGER NOT NULL REFERENCES categorie(id_categorie) ON DELETE CASCADE,
    PRIMARY KEY (id_artiste, id_categorie)
);
 
ALTER TABLE artiste_categorie ENABLE ROW LEVEL SECURITY;
CREATE POLICY "lecture publique" ON artiste_categorie
    FOR SELECT TO anon, authenticated USING (true);
 
 
-- ============================================================
-- pass_jour (liaison) — 
-- ============================================================
CREATE TABLE pass_jour (
    id_pass INTEGER NOT NULL REFERENCES pass(id_pass) ON DELETE CASCADE,
    id_jour INTEGER NOT NULL REFERENCES jour(id_jour) ON DELETE CASCADE,
    PRIMARY KEY (id_pass, id_jour)
);
 
ALTER TABLE pass_jour ENABLE ROW LEVEL SECURITY;
CREATE POLICY "lecture publique" ON pass_jour
    FOR SELECT TO anon, authenticated USING (true);
 
 
-- ============================================================
-- utilisateur (liée à auth.users de Supabase) — 
-- L'email vit dans auth.users, pas ici.
-- ============================================================
CREATE TABLE utilisateur (
    id_user       UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    pseudo        VARCHAR(80),
    date_creation TIMESTAMP NOT NULL DEFAULT NOW()
);
 
ALTER TABLE utilisateur ENABLE ROW LEVEL SECURITY;
CREATE POLICY "mon profil" ON utilisateur
    FOR ALL TO authenticated
    USING (id_user = (SELECT auth.uid()))
    WITH CHECK (id_user = (SELECT auth.uid()));
 
-- Crée automatiquement la ligne utilisateur quand un compte est créé
-- (y compris un compte anonyme, au premier favori)

CREATE FUNCTION public.creer_utilisateur()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER SET search_path = ''
AS $$
BEGIN
    INSERT INTO public.utilisateur (id_user) VALUES (NEW.id);
    RETURN NEW;
END;
$$;
 
CREATE TRIGGER apres_creation_compte
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.creer_utilisateur();
 
 
-- ============================================================
-- favori (liaison utilisateur / concert) — 
-- ============================================================
CREATE TABLE favori (
    id_user      UUID NOT NULL REFERENCES utilisateur(id_user) ON DELETE CASCADE,
    id_concert   INTEGER NOT NULL REFERENCES concert(id_concert) ON DELETE CASCADE,
    date_ajout   TIMESTAMP NOT NULL DEFAULT NOW(),
    rappel_actif BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id_user, id_concert)
);
 
CREATE INDEX idx_favori_concert ON favori(id_concert);
 
ALTER TABLE favori ENABLE ROW LEVEL SECURITY;
CREATE POLICY "mes favoris" ON favori
    FOR ALL TO authenticated
    USING (id_user = (SELECT auth.uid()))
    WITH CHECK (id_user = (SELECT auth.uid()));
 
 
-- ============================================================
-- abonnement_push (notifications PWA) — 
-- ============================================================
CREATE TABLE abonnement_push (
    id_abonnement INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    endpoint      VARCHAR(500) NOT NULL UNIQUE,
    cle_p256dh    VARCHAR(255) NOT NULL,
    cle_auth      VARCHAR(255) NOT NULL,
    date_creation TIMESTAMP NOT NULL DEFAULT NOW(),
    id_user       UUID NOT NULL REFERENCES utilisateur(id_user) ON DELETE CASCADE
);
 
ALTER TABLE abonnement_push ENABLE ROW LEVEL SECURITY;
CREATE POLICY "mes abonnements" ON abonnement_push
    FOR ALL TO authenticated
    USING (id_user = (SELECT auth.uid()))
    WITH CHECK (id_user = (SELECT auth.uid()));
 
 
-- ============================================================
-- données de départ (optionelle) — 
-- ============================================================
INSERT INTO scene (nom, lieu, description, ordre_affichage) VALUES
    ('Scène 1', 'Amphithéâtre des vestiges du château', 'Électronique et électro-acoustique', 1),
    ('Scène 2', 'Église de Noyers-sur-Serein', 'Musique vocale et acoustique', 2);
 
INSERT INTO categorie (libelle) VALUES
    ('Première'), ('Électro-acoustique'), ('Acoustique');
 


