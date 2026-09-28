


-- 1
SELECT DISTINCT Cow.id_Cow, Breed.Name AS Breed_Name, Lactation_Phase.Name AS Lactation_Phase_Name, 
Livestock_specialist.First_name, 
Livestock_specialist.Surname, Feed_type.Name AS Feed_type_Name
FROM Cow
JOIN Breed ON Cow.id_Breed = Breed.id_Breed
JOIN Lactation ON Cow.id_Cow = Lactation.id_Cow
JOIN Lactation_Phase ON Lactation.id_Lactation_Phase = Lactation_Phase.id_Lactation_Phase
JOIN Diet ON Lactation_Phase.id_Lactation_Phase = Diet.id_Lactation_Phase
JOIN Livestock_specialist ON Diet.id_Livestock_specialist = Livestock_specialist.id_Livestock_specialist
JOIN Feeding_plan ON Diet.id_Diet = Feeding_plan.id_Diet
JOIN Feeds ON Feeding_plan.id_Feeds = Feeds.id_Feeds
JOIN Feed_type ON Feeds.id_Feed_type = Feed_type.id_Feed_type
WHERE Breed.Name = 'Рязанская'
  AND Lactation_Phase.Name = 'Середина лактации'
  AND Livestock_specialist.First_name = 'Артем' 
  AND Livestock_specialist.Surname = 'Новиков'
  AND Feed_type.Name = 'Солома';

-- 2
SELECT COUNT(DISTINCT Nutrition.id_Cow) 
FROM Livestock_specialist 
JOIN Diet ON Livestock_specialist.id_Livestock_specialist = Diet.id_Livestock_specialist
JOIN Feeding_plan ON Diet.id_Diet = Feeding_plan.id_Diet
JOIN Nutrition ON Feeding_plan.id_Feeding_plan = Nutrition.id_Feeding_plan
WHERE Livestock_specialist.Surname = 'Смирнова' 
  AND Livestock_specialist.First_name = 'Екатерина';

-- 3 для каждой породы вычислить количество коров и количество лактаций
SELECT 
    Breed.Name AS Breed_name, 
    COUNT(DISTINCT Cow.id_Cow) AS Cow_count,  
    COUNT(Lactation.id_Lactation) AS Lactation_count 
FROM Breed 
LEFT JOIN Cow ON Breed.id_Breed = Cow.id_Breed
LEFT JOIN Lactation ON Cow.id_Cow = Lactation.id_Cow
GROUP BY Breed.id_Breed, Breed.Name;

-- 4.1 Виды кормов с максимальным числом питания коров
SELECT Feed_type.Name AS Feed_type_Name, COUNT(DISTINCT Nutrition.id_Cow) AS Cow_count
FROM Feed_type
JOIN Feeds ON Feed_type.id_Feed_type = Feeds.id_Feed_type
JOIN Feeding_plan ON Feeds.id_Feeds = Feeding_plan.id_Feeds
JOIN Nutrition ON Feeding_plan.id_Feeding_plan = Nutrition.id_Feeding_plan
GROUP BY Feed_type.id_Feed_type, Feed_type.Name -- количетсво коров которые питались каждым типом корма
HAVING COUNT(DISTINCT Nutrition.id_Cow) = ( -- количество коров макс
    SELECT MAX(cow_count) FROM ( -- поиск максимума среди cow_count 
        SELECT COUNT(DISTINCT Nutrition.id_Cow) AS cow_count -- поиск cow_count
        FROM Feed_type
        JOIN Feeds ON Feed_type.id_Feed_type = Feeds.id_Feed_type
        JOIN Feeding_plan ON Feeds.id_Feeds = Feeding_plan.id_Feeds
        JOIN Nutrition ON Feeding_plan.id_Feeding_plan = Nutrition.id_Feeding_plan
        GROUP BY Feed_type.id_Feed_type
    ) AS counts
);

-- 4.1
SELECT Feed_type.Name AS Feed_type_Name, COUNT(DISTINCT Nutrition.id_Cow) AS Cow_count
FROM Feed_type
JOIN Feeds ON Feed_type.id_Feed_type = Feeds.id_Feed_type
JOIN Feeding_plan ON Feeds.id_Feeds = Feeding_plan.id_Feeds
JOIN Nutrition ON Feeding_plan.id_Feeding_plan = Nutrition.id_Feeding_plan
GROUP BY Feed_type.id_Feed_type, Feed_type.Name
HAVING COUNT(DISTINCT Nutrition.id_Cow) = (
    SELECT MAX(cow_count) FROM (
        SELECT COUNT(DISTINCT Nutrition.id_Cow) AS cow_count
        FROM Feed_type
        JOIN Feeds ON Feed_type.id_Feed_type = Feeds.id_Feed_type
        JOIN Feeding_plan ON Feeds.id_Feeds = Feeding_plan.id_Feeds
        JOIN Nutrition ON Feeding_plan.id_Feeding_plan = Nutrition.id_Feeding_plan
        GROUP BY Feed_type.id_Feed_type
    ) AS counts
);

-- 4.2 Виды кормов с минимальным числом питания коров
SELECT Feed_type.Name AS Feed_type_Name, COUNT(DISTINCT Nutrition.id_Cow) AS cow_count
FROM Feed_type
JOIN Feeds ON Feed_type.id_Feed_type = Feeds.id_Feed_type
JOIN Feeding_plan ON Feeds.id_Feeds = Feeding_plan.id_Feeds
JOIN Nutrition ON Feeding_plan.id_Feeding_plan = Nutrition.id_Feeding_plan
GROUP BY Feed_type.id_Feed_type, Feed_type.Name
HAVING COUNT(DISTINCT Nutrition.id_Cow) = (
    SELECT MIN(cow_count)
    FROM (
        SELECT COUNT(DISTINCT Nutrition.id_Cow) AS cow_count
        FROM Feed_type
        JOIN Feeds ON Feed_type.id_Feed_type = Feeds.id_Feed_type
        JOIN Feeding_plan ON Feeds.id_Feeds = Feeding_plan.id_Feeds
        JOIN Nutrition ON Feeding_plan.id_Feeding_plan = Nutrition.id_Feeding_plan
        GROUP BY Feed_type.id_Feed_type
    ) AS counts
);

--5 посчитать число коров с равным числом лактаций 
SELECT lactation_count, COUNT(id_Cow) AS cow_count -- количество лактаций, количество коров с этим числом лактаций 
FROM (SELECT Cow.id_Cow, COUNT(DISTINCT Lactation.id_Lactation) AS lactation_count
    FROM Cow
    JOIN Lactation ON Cow.id_Cow = Lactation.id_Cow
    GROUP BY Cow.id_Cow -- получается таблица в которой количество лакатций кажджой коровы 
) AS cow_lactations
GROUP BY lactation_count;

SELECT lactation_count, COUNT(id_Cow) AS cow_count
FROM (SELECT Cow.id_Cow, COUNT(DISTINCT Lactation.id_Lactation) AS lactation_count
    FROM Cow
    JOIN Lactation ON Cow.id_Cow = Lactation.id_Cow
    GROUP BY Cow.id_Cow
) AS cow_lactations
GROUP BY lactation_count;

-- в одной лактации 5 записей (5 фаз)

-- 6 найти рационы по которым питалось больше коров чем по рациону с id_Diet = 1
SELECT Diet.id_Diet, COUNT(DISTINCT Nutrition.id_Cow) AS cow_count
FROM Diet
JOIN Feeding_plan ON Diet.id_Diet = Feeding_plan.id_Diet
JOIN Nutrition ON Feeding_plan.id_Feeding_plan = Nutrition.id_Feeding_plan
GROUP BY Diet.id_Diet -- получение таблицы в которой количетсво коров которые питались по каждому рациону 
HAVING COUNT(DISTINCT Nutrition.id_Cow) > -- фильтрация
(
    SELECT COUNT(DISTINCT Nutrition.id_Cow)
    FROM Diet
    JOIN Feeding_plan ON Diet.id_Diet = Feeding_plan.id_Diet
    JOIN Nutrition ON Feeding_plan.id_Feeding_plan = Nutrition.id_Feeding_plan
    WHERE Diet.id_Diet = 1 -- поиск количетсва коров которые питались по рациону 1
);

SELECT Diet.id_Diet, COUNT(DISTINCT Nutrition.id_Cow) AS cow_count
FROM Diet
JOIN Feeding_plan ON Diet.id_Diet = Feeding_plan.id_Diet
JOIN Nutrition ON Feeding_plan.id_Feeding_plan = Nutrition.id_Feeding_plan
GROUP BY Diet.id_Diet 
HAVING COUNT(DISTINCT Nutrition.id_Cow) > (
    SELECT COUNT(DISTINCT Nutrition.id_Cow)
    FROM Diet
    JOIN Feeding_plan ON Diet.id_Diet = Feeding_plan.id_Diet
    JOIN Nutrition ON Feeding_plan.id_Feeding_plan = Nutrition.id_Feeding_plan
    WHERE Diet.id_Diet = 1
);

-- 7 найти корма которые ни разу не попадали в питание коровы 
SELECT Feeds.id_Feeds, Feeds.Name
FROM Feeds
LEFT JOIN Feeding_plan ON Feeds.id_Feeds = Feeding_plan.id_Feeds
LEFT JOIN Nutrition ON Feeding_plan.id_Feeding_plan = Nutrition.id_Feeding_plan
WHERE Nutrition.id_Cow IS NULL;

-- чтобы вывод 7 не был пуст добавляем корма для которых не составляли рационы
INSERT INTO Feeds (Name, Physical_characteristics, Chemical_properties, id_Feed_type)
VALUES
('Экспериментальная добавка', 'Порошок белый', 'Не сертифицировано',
 (SELECT id_Feed_type FROM Feed_Type LIMIT 1)),

('Просроченный комбикорм', 'Слежавшийся, комки', 'Пониженная питательность',
 (SELECT id_Feed_type FROM Feed_Type LIMIT 1)),

('Корм на тестировании', 'Гранулы серые', 'Состав уточняется',
 (SELECT id_Feed_type FROM Feed_Type LIMIT 1));

-- 8 Для каждой фазы лакатции и породы посчитать число коров
SELECT Lactation_Phase.Name AS Lactation_Phase_Name, Breed.Name AS Breed_Name,
    COUNT(DISTINCT Cow.id_Cow) AS cow_count
FROM Lactation_Phase CROSS JOIN Breed -- все комбинации фазы и породы
LEFT JOIN Cow ON Breed.id_Breed = Cow.id_Breed -- соединяем id коров с породами (в новой таблице) записываем id
-- получилась таблица из породы фазы и id коровы которая имеет эту породу
LEFT JOIN Lactation ON Cow.id_Cow = Lactation.id_Cow 
    AND Lactation_Phase.id_Lactation_phase = Lactation.id_Lactation_phase -- добавляем столбец с id фаз лактаций в которых была корва 
-- 
GROUP BY Lactation_Phase.id_Lactation_phase, Lactation_Phase.Name,
         Breed.id_Breed, Breed.Name;
-- группируем строки где совпадают и порода и фаза

SELECT Lactation_Phase.Name AS Lactation_Phase_Name, Breed.Name AS Breed_Name,
    COUNT(Cow.id_Cow) AS cow_count
FROM Lactation_Phase CROSS JOIN Breed 
LEFT JOIN Cow ON Breed.id_Breed = Cow.id_Breed
LEFT JOIN Lactation ON Cow.id_Cow = Lactation.id_Cow 
    AND Lactation_Phase.id_Lactation_phase = Lactation.id_Lactation_phase
GROUP BY Lactation_Phase.id_Lactation_phase, Lactation_Phase.Name,
         Breed.id_Breed, Breed.Name;

-- 9 во всех рационах заменить зоотехника Иванов Алексей на Петров Иван


UPDATE Diet 
SET id_Livestock_specialist = 1 
WHERE id_Livestock_specialist = 2; 

-- VIEW
-- 10 для каждой коровы посчитать количество лактаций и количество рационов 

CREATE VIEW Cow_Lactation_Diet_Count AS
SELECT Cow.id_Cow, COUNT(DISTINCT Lactation.id_Lactation) AS lactation_count, 
    COUNT(DISTINCT Diet.id_Diet) AS diet_count
FROM Cow 
LEFT JOIN Lactation ON Lactation.id_Cow = Cow.id_Cow
LEFT JOIN Nutrition ON Nutrition.id_Cow = Cow.id_Cow
LEFT JOIN Feeding_plan ON Feeding_plan.id_Feeding_plan = Nutrition.id_Feeding_plan
LEFT JOIN Diet ON Diet.id_Diet = Feeding_plan.id_Diet
GROUP BY Cow.id_Cow;

-- вывести количество коров у которых было больше 2 лактаций

select count(*) from Cow_Lactation_Diet_Count where lactation_count > 2;

-- вывести возраст каждой коровы, количество лактаций,
-- количество рационов и количество кормов по которым она питалась
EXPLAIN
SELECT Cow.id_Cow, Cow.Age, Cow_Lactation_Diet_Count.lactation_count, 
    Cow_Lactation_Diet_Count.diet_count, COUNT(DISTINCT Feeds.id_Feeds) AS feed_count
FROM Cow_Lactation_Diet_Count 
JOIN Cow ON Cow.id_cow = Cow_Lactation_Diet_Count.id_cow
LEFT JOIN Nutrition ON Nutrition.id_cow = Cow.id_cow
LEFT JOIN Feeding_plan ON Feeding_plan.id_Feeding_plan = Nutrition.id_Feeding_plan
LEFT JOIN Feeds ON Feeds.id_feeds = Feeding_plan.id_feeds
GROUP BY Cow.id_Cow, Cow.Age, Cow_Lactation_Diet_Count.lactation_count, Cow_Lactation_Diet_Count.diet_count;

