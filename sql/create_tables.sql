-- словари

CREATE TABLE IF NOT EXISTS Breed (
    id_Breed SERIAL PRIMARY KEY,
    Name VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS Day_Times (
    id_Day_times SERIAL PRIMARY KEY,
    Day_time VARCHAR(60)
);

CREATE TABLE IF NOT EXISTS Season (
    id_Season SERIAL PRIMARY KEY,
    Time_of_year VARCHAR(60)
);

CREATE TABLE IF NOT EXISTS Lactation_Phase (
    id_Lactation_phase SERIAL PRIMARY KEY,
    Name VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS Feed_Type (
    id_Feed_type SERIAL PRIMARY KEY,
    Name VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS Livestock_specialist (
    id_Livestock_specialist SERIAL PRIMARY KEY,
    Surname VARCHAR(80),
    First_name VARCHAR(70),
    Patronymic VARCHAR(80),
    Service_length DECIMAL(4,1),
    Phone_number VARCHAR(20),
    Email VARCHAR(255)
);

-- основыные сущности 

CREATE TABLE IF NOT EXISTS Cow (
    id_Cow SERIAL PRIMARY KEY,
    Weight INT,
    Age INT,
    id_Breed INT NOT NULL,
    FOREIGN KEY (id_Breed) REFERENCES Breed(id_Breed)
);


CREATE TABLE IF NOT EXISTS Feeds (
    id_Feeds SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Physical_characteristics TEXT,
    Chemical_properties TEXT,
    id_Feed_type INT NOT NULL,
    FOREIGN KEY (id_Feed_type) REFERENCES Feed_Type(id_Feed_type)
);


CREATE TABLE IF NOT EXISTS Diet (
    id_Diet SERIAL PRIMARY KEY,
    id_Season INT NOT NULL,
    id_Lactation_phase INT NOT NULL,
    id_Livestock_specialist INT NOT NULL,
    FOREIGN KEY (id_Season) REFERENCES Season(id_Season),
    FOREIGN KEY (id_Lactation_phase) REFERENCES Lactation_Phase(id_Lactation_phase),
    FOREIGN KEY (id_Livestock_specialist) REFERENCES Livestock_specialist(id_Livestock_specialist)
);

CREATE TABLE IF NOT EXISTS Lactation (
    id_Lactation SERIAL PRIMARY KEY,
    Number INT,
    Start DATE,
    End DATE,
    id_Cow INT NOT NULL,
    id_Lactation_phase INT NOT NULL,
    FOREIGN KEY (id_Cow) REFERENCES Cow(id_Cow),
    FOREIGN KEY (id_Lactation_phase) REFERENCES Lactation_Phase(id_Lactation_phase)
);

CREATE TABLE IF NOT EXISTS Feeding_plan (
    id_Feeding_plan SERIAL PRIMARY KEY,
    Feed_amount DECIMAL(6,3),
    id_Feeds INT NOT NULL,
    id_Diet INT NOT NULL,
    id_Day_times INT NOT NULL,
    FOREIGN KEY (id_Feeds) REFERENCES Feeds(id_Feeds),
    FOREIGN KEY (id_Diet) REFERENCES Diet(id_Diet),
    FOREIGN KEY (id_Day_times) REFERENCES Day_Times(id_Day_times)
);

CREATE TABLE IF NOT EXISTS Nutrition (
    id_Nutrition SERIAL PRIMARY KEY,
    id_Cow INT NOT NULL,
    id_Feeding_plan INT NOT NULL,
    FOREIGN KEY (id_Cow) REFERENCES Cow(id_Cow),
    FOREIGN KEY (id_Feeding_plan) REFERENCES Feeding_plan(id_Feeding_plan)
);

CREATE TABLE IF NOT EXISTS Cow_lactation_diet_count (
    id_Cow INT PRIMARY KEY,
    Lactation_count INT,
    Diet_count INT
);

-- заполнение таблицы Cow_lactation_diet_count
INSERT INTO Cow_lactation_diet_count (id_Cow, Lactation_count, Diet_count)
SELECT Cow.id_Cow, 
    COUNT(DISTINCT Lactation.id_Lactation), 
    COUNT(DISTINCT Diet.id_Diet)
FROM Cow 
LEFT JOIN Lactation ON Lactation.id_Cow = Cow.id_Cow
LEFT JOIN Nutrition ON Nutrition.id_Cow = Cow.id_Cow
LEFT JOIN Feeding_plan ON Feeding_plan.id_Feeding_plan = Nutrition.id_Feeding_plan
LEFT JOIN Diet ON Diet.id_Diet = Feeding_plan.id_Diet
GROUP BY Cow.id_Cow;
