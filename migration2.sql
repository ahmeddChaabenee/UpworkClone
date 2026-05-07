-- ==========================================
-- MIGRATION 2: Ajouter category_id à JOBS et FREELANCER_PROFILES
-- ==========================================

USE upwork_clone;

-- ==========================================
-- STEP 1: Ajouter primary_category_id à FREELANCER_PROFILES
-- ==========================================
ALTER TABLE freelancer_profiles ADD COLUMN primary_category_id INT;

-- ==========================================
-- STEP 2: Ajouter la contrainte FOREIGN KEY pour primary_category_id
-- ==========================================
ALTER TABLE freelancer_profiles 
ADD CONSTRAINT fk_freelancer_primary_category 
FOREIGN KEY (primary_category_id) REFERENCES categories(id) ON DELETE SET NULL;

-- ==========================================
-- STEP 3: Ajouter index pour primary_category_id
-- ==========================================
ALTER TABLE freelancer_profiles ADD INDEX idx_primary_category_id (primary_category_id);

-- ==========================================
-- STEP 4: Modifier JOBS - Ajouter category_id
-- ==========================================
ALTER TABLE jobs ADD COLUMN category_id INT;

-- ==========================================
-- STEP 5: Mapper les anciennes catégories aux nouveaux IDs dans JOBS
-- ==========================================
UPDATE jobs j
SET category_id = (
    SELECT id FROM categories c WHERE c.name = j.category
)
WHERE j.category IS NOT NULL;

-- ==========================================
-- STEP 6: Ajouter la contrainte FOREIGN KEY pour jobs.category_id
-- ==========================================
ALTER TABLE jobs 
ADD CONSTRAINT fk_jobs_category 
FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE RESTRICT;

-- ==========================================
-- STEP 7: Ajouter index pour jobs.category_id
-- ==========================================
ALTER TABLE jobs ADD INDEX idx_jobs_category_id (category_id);

-- ==========================================
-- STEP 8: Supprimer l'ancienne colonne category de JOBS
-- ==========================================
ALTER TABLE jobs DROP COLUMN category;

-- ==========================================
-- STEP 9: Affecter une catégorie primaire aux freelancers existants
-- ==========================================
-- Exemple: Assigner la catégorie 1 (Backend) comme catégorie primaire
UPDATE freelancer_profiles SET primary_category_id = 1 WHERE primary_category_id IS NULL;

-- ==========================================
-- VERIFICATION
-- ==========================================
SELECT 'Migration 2 completed successfully!' as status;

-- Afficher la structure modifiée de FREELANCER_PROFILES
DESCRIBE freelancer_profiles;

-- Afficher la structure modifiée de JOBS
DESCRIBE jobs;

-- Afficher les jobs avec leurs catégories
SELECT j.id, j.title, c.name as category 
FROM jobs j
JOIN categories c ON j.category_id = c.id
ORDER BY c.name, j.title;

-- Afficher les freelancers avec leurs catégories primaires
SELECT fp.id, u.first_name, u.last_name, c.name as primary_category 
FROM freelancer_profiles fp
JOIN users u ON fp.user_id = u.id
LEFT JOIN categories c ON fp.primary_category_id = c.id
ORDER BY c.name;
