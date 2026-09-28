CREATE TRIGGER Cow_insert_trigger
    AFTER INSERT ON Cow 
    FOR EACH ROW EXECUTE FUNCTION Cow_insert_trigger_function();

CREATE TRIGGER Cow_delete_trigger 
    AFTER DELETE ON Cow 
    FOR EACH ROW EXECUTE FUNCTION Cow_delete_trigger_function();


CREATE TRIGGER Nutrition_insert_trigger
    After INSERT ON Nutrition 
    FOR EACH ROW EXECUTE FUNCTION Nutrition_insert_trigger_function();

CREATE TRIGGER Nutrition_delete_trigger
    AFTER DELETE ON Nutrition
    FOR EACH ROW EXECUTE FUNCTION Nutrition_delete_trigger_function();

CREATE TRIGGER Nutrition_update_trigger
    AFTER UPDATE ON Nutrition 
    FOR EACH ROW EXECUTE FUNCTION Nutrition_update_trigger_function();


CREATE TRIGGER Lactation_insert_trigger
    AFTER INSERT ON Lactation 
    FOR EACH ROW EXECUTE FUNCTION Lactation_insert_trigger_function();

CREATE TRIGGER Lactation_delete_trigger
    AFTER DELETE ON Lactation
    FOR EACH ROW EXECUTE FUNCTION Lactation_delete_trigger_function();

CREATE TRIGGER Lactation_update_trigger
    AFTER UPDATE ON Lactation 
    FOR EACH ROW EXECUTE FUNCTION Lactation_update_trigger_function();