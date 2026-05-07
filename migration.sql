-- ==========================================
-- MIGRATION: Ajouter la table CATEGORIES
-- et modifier la table SKILLS
-- ==========================================

-- Utiliser la base de données existante
USE upwork_clone;

-- ==========================================
-- STEP 1: Créer la table CATEGORIES
-- ==========================================
CREATE TABLE categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ==========================================
-- STEP 2: Insérer les catégories
-- ==========================================
INSERT INTO categories (name, description) VALUES
('Backend', 'Server-side development and APIs'),
('Frontend', 'Client-side development and UI'),
('Database', 'Database design and management'),
('Design', 'UI/UX and graphic design'),
('Full Stack', 'Complete web development'),
('Mobile', 'Mobile app development'),
('CMS', 'Content Management Systems');

-- ==========================================
-- STEP 3: Ajouter la colonne category_id à SKILLS
-- ==========================================
ALTER TABLE skills ADD COLUMN category_id INT;

-- ==========================================
-- STEP 4: Mapper les anciennes catégories aux nouveaux IDs
-- ==========================================
UPDATE skills s
SET category_id = (
    SELECT id FROM categories c WHERE c.name = s.category
)
WHERE s.category IS NOT NULL;

-- ==========================================
-- STEP 5: Définir la contrainte FOREIGN KEY
-- ==========================================
ALTER TABLE skills 
ADD CONSTRAINT fk_skills_category 
FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE RESTRICT;

-- ==========================================
-- STEP 6: Ajouter un index pour améliorer les performances
-- ==========================================
ALTER TABLE skills ADD INDEX idx_category_id (category_id);

-- ==========================================
-- STEP 7: Supprimer l'ancienne colonne category (optionnel)
-- ==========================================
-- Décommentez si vous voulez supprimer l'ancienne colonne
-- ALTER TABLE skills DROP COLUMN category;

-- ==========================================
-- VERIFICATION
-- ==========================================
SELECT 'Migration completed successfully!' as status;

-- Afficher la structure modifiée de SKILLS
DESCRIBE skills;

-- Afficher les catégories créées
SELECT * FROM categories;

-- Afficher les skills avec leurs catégories
SELECT s.id, s.name, c.name as category 
FROM skills s
JOIN categories c ON s.category_id = c.id
ORDER BY c.name, s.name;
