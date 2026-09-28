CREATE OR REPLACE FUNCTION Cow_insert_trigger_function()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO Cow_lactation_diet_count (id_Cow, Lactation_count, Diet_count)
    VALUES (NEW.id_Cow, 0, 0);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION Cow_delete_trigger_function()
RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM Cow_lactation_diet_count WHERE id_Cow = OLD.id_Cow;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION Nutrition_insert_trigger_function()
RETURNS TRIGGER AS $$
BEGIN 
    UPDATE Cow_lactation_diet_count 
    SET diet_count = (
        SELECT COUNT(DISTINCT Diet.id_Diet)
        FROM Nutrition
        LEFT JOIN Feeding_plan ON Feeding_plan.id_Feeding_plan = Nutrition.id_Feeding_plan
        LEFT JOIN Diet ON Diet.id_Diet = Feeding_plan.id_Diet
        WHERE Nutrition.id_Cow = NEW.id_Cow
    )
    WHERE id_Cow = NEW.id_Cow; 
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

create or replace function Nutrition_delete_trigger_function()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Cow_lactation_diet_count 
    SET diet_count = (
        SELECT COUNT(DISTINCT Diet.id_Diet)
        FROM Nutrition
        LEFT JOIN Feeding_plan ON Feeding_plan.id_Feeding_plan = Nutrition.id_Feeding_plan
        LEFT JOIN Diet ON Diet.id_Diet = Feeding_plan.id_Diet
        WHERE Nutrition.id_Cow = OLD.id_Cow
    )
    WHERE id_Cow = OLD.id_Cow; 
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- что меняем: id коровы или только план кормления?
-- если меняется id коровы то пересчитывать нужно не только для коровы NEW.id но и для коровы OLD.id
create or replace function Nutrition_update_trigger_function()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Cow_lactation_diet_count 
    SET diet_count = 
        (SELECT COUNT(DISTINCT Diet.id_Diet)
        FROM Nutrition
        LEFT JOIN Feeding_plan ON Feeding_plan.id_Feeding_plan = Nutrition.id_Feeding_plan
        LEFT JOIN Diet ON Diet.id_Diet = Feeding_plan.id_Diet
        WHERE Nutrition.id_Cow = NEW.id_Cow)
    WHERE id_Cow = NEW.id_Cow;
    RETURN NEW; 
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION Lactation_insert_trigger_function()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Cow_lactation_diet_count 
    SET lactation_count = 
        (SELECT COUNT(*) FROM Lactation WHERE id_Cow = NEW.id_Cow)
    WHERE id_Cow = NEW.id_Cow;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

create or replace function Lactation_delete_trigger_function()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Cow_lactation_diet_count 
    SET lactation_count = 
        (SELECT COUNT(*) FROM Lactation WHERE id_Cow = OLD.id_Cow)
    WHERE id_Cow = OLD.id_Cow;  
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION Lactation_update_trigger_function()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Cow_lactation_diet_count 
    SET lactation_count = 
        (SELECT COUNT(*) FROM Lactation WHERE id_Cow = NEW.id_Cow)
    WHERE id_Cow = NEW.id_Cow;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;