use global_bleaching_env;
select *
from global_main;

-- COUNTRY TABLE ----------------------
create table if not exists country (
country_id int auto_increment,
country  LONGTEXT,
primary key (country_id));

select * from country;
-- lets populate the table by inserting the unique values for that dimension
insert into country(country)
select distinct country_name  from global_main order by country_name asc;

select * from country;

-- now lets adjust the original table so we will use this table
alter table global_main add column country_id int after country_name;

-- lets set up the foreign key reference
alter table global_main ADD CONSTRAINT country_fk FOREIGN KEY (country_id) REFERENCES country (country_id);

-- populate the column using the dimension table we created
update global_main, country
set global_main.country_id = country.country_id
where global_main.country_name = country.country;

-- lets drop the original column now
alter table global_main drop column country_name;


-- EXPOSURE TABLE ----------------------
create table if not exists exposure (
exposure_id int auto_increment,
exposure  LONGTEXT,
primary key (exposure_id));

select * from exposure;

-- lets populate the table by inserting the unique values for that dimension
insert into exposure(exposure)
select distinct exposure from global_main;

select * from exposure;

-- now lets adjust the original table so we will use this table
alter table global_main add column exposure_id int after exposure;

-- lets set up the foreign key reference
alter table global_main ADD CONSTRAINT exposure_fk FOREIGN KEY (exposure_id) REFERENCES exposure (exposure_id);

-- populate the column using the dimension table we created
update global_main, exposure
set global_main.exposure_id = exposure.exposure_id
where global_main.exposure = exposure.exposure;

-- lets drop the original column now
alter table global_main drop column exposure;



-- OCEAN TABLE ----------------------
create table if not exists ocean (
ocean_id int auto_increment,
ocean  LONGTEXT,
primary key (ocean_id));

select * from ocean;

-- lets populate the table by inserting the unique values for that dimension
insert into ocean(ocean)
select distinct ocean_name  from global_main order by ocean_name asc;

select * from ocean;

-- now lets adjust the original table so we will use this table
alter table global_main add column ocean_id int after ocean_name;

-- lets set up the foreign key reference
alter table global_main ADD CONSTRAINT ocean_fk FOREIGN KEY (ocean_id) REFERENCES ocean (ocean_id);

-- populate the column using the dimension table we created
update global_main, ocean
set global_main.ocean_id = ocean.ocean_id
where global_main.ocean_name = ocean.ocean;

-- lets drop the original column now
alter table global_main drop column ocean_name;