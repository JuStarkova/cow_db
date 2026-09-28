create user resultsReader with password 'reader';
create user resultsEditor with password 'editor';

GRANT CONNECT ON DATABASE cows_db TO resultsReader, resultsEditor;
GRANT USAGE ON SCHEMA public TO resultsReader, resultsEditor;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA public TO resultsEditor;

grant select on Cow_lactation_diet_count to resultsReader;
grant select, insert, delete, update on Cow, Lactation, Nutrition to resultsEditor;

select * from Cow_lactation_diet_count limit 5;
select * from cow limit 5;
select * Lactation limit 5;
select from Nutrition limit 5;
insert into Cow (Weight, Age, id_Breed) values (160, 2, 3);
