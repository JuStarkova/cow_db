CREATE USER resultsReader WITH PASSWORD 'reader';
CREATE USER resultsEditor WITH PASSWORD 'editor';

GRANT CONNECT ON DATABASE cows_db TO resultsReader, resultsEditor;
GRANT USAGE ON SCHEMA public TO resultsReader, resultsEditor;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA public TO resultsEditor;

GRANT SELECT ON Cow_lactation_diet_count TO resultsReader;
GRANT SELECT, INSERT, DELETE, UPDATE ON Cow, Lactation, Nutrition TO resultsEditor;

ALTER FUNCTION Cow_insert_trigger_function() SECURITY DEFINER;
ALTER FUNCTION Cow_delete_trigger_function() SECURITY DEFINER;
ALTER FUNCTION Nutrition_insert_trigger_function() SECURITY DEFINER;
ALTER FUNCTION Nutrition_delete_trigger_function() SECURITY DEFINER;
ALTER FUNCTION Nutrition_update_trigger_function() SECURITY DEFINER;
ALTER FUNCTION Lactation_insert_trigger_function() SECURITY DEFINER;
ALTER FUNCTION Lactation_delete_trigger_function() SECURITY DEFINER;
ALTER FUNCTION Lactation_update_trigger_function() SECURITY DEFINER;

-- примеры запросов для проверки
SELECT * FROM Cow_lactation_diet_count LIMIT 5;
SELECT * FROM Cow LIMIT 5;
SELECT * FROM Lactation LIMIT 5;
SELECT * FROM Nutrition LIMIT 5;
INSERT INTO Cow (Weight, Age, id_Breed) VALUES (160, 2, 3);
UPDATE Cow SET Age = 2 WHERE id_Cow = 6584;
DELETE FROM Cow WHERE id_Cow = 6584;