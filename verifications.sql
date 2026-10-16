-- ETAPE 1 : verification des platq du plus cher au moins cher-- 
SELECT current_database();
SELECT * FROM plat ORDER BY prix DESC;