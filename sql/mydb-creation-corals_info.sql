use corals_info;
select *
from global_bleaching_env;

-- COUNTRY TABLE ----------------------
create table if not exists country (
country_id int auto_increment,
country  LONGTEXT,
primary key (country_id));

select * from country;

-- lets populate the table by inserting the unique values for that dimension
insert into country(country)
select distinct country  from global_bleaching_env order by country asc;

select * from country;

-- now lets adjust the original table so we will use this table
alter table global_bleaching_env add column country_id int after country;

-- lets set up the foreign key reference
alter table global_bleaching_env ADD CONSTRAINT country_fk FOREIGN KEY (country_id) REFERENCES country (country_id);

-- populate the column using the dimension table we created
update global_bleaching_env, country
set global_bleaching_env.country_id = country.country_id
where global_bleaching_env.country = country.country;

-- lets drop the original column now
alter table global_bleaching_env drop column country;



-- EXPOSURE TABLE ----------------------
create table if not exists exposure (
exposure_id int auto_increment,
exposure  LONGTEXT,
primary key (exposure_id));

select * from exposure;

-- lets populate the table by inserting the unique values for that dimension
insert into exposure(exposure)
select distinct exposure from global_bleaching_env;

select * from exposure;

-- now lets adjust the original table so we will use this table
alter table global_bleaching_env add column exposure_id int after exposure;

-- lets set up the foreign key reference
alter table global_bleaching_env ADD CONSTRAINT exposure_fk FOREIGN KEY (exposure_id) REFERENCES exposure (exposure_id);

-- populate the column using the dimension table we created
update global_bleaching_env, exposure
set global_bleaching_env.exposure_id = exposure.exposure_id
where global_bleaching_env.exposure = exposure.exposure;

-- lets drop the original column now
alter table global_bleaching_env drop column exposure;



-- OCEAN TABLE ----------------------
create table if not exists ocean (
ocean_id int auto_increment,
ocean  LONGTEXT,
primary key (ocean_id));

select * from ocean;

-- lets populate the table by inserting the unique values for that dimension
insert into ocean(ocean)
select distinct ocean  from global_bleaching_env order by ocean asc;

select * from ocean;

-- now lets adjust the original table so we will use this table
alter table global_bleaching_env add column ocean_id int after ocean;

-- lets set up the foreign key reference
alter table global_bleaching_env ADD CONSTRAINT ocean_fk FOREIGN KEY (ocean_id) REFERENCES ocean (ocean_id);

-- populate the column using the dimension table we created
update global_bleaching_env, ocean
set global_bleaching_env.ocean_id = ocean.ocean_id
where global_bleaching_env.ocean = ocean.ocean;

-- lets drop the original column now
alter table global_bleaching_env drop column ocean;


-- BLEACHING_STATUS TABLE ----------------------
create table if not exists bleaching_status (
bleaching_status_id int auto_increment,
bleaching_status  LONGTEXT,
primary key (bleaching_status_id));

select * from bleaching_status;

-- lets populate the table by inserting the unique values for that dimension
insert into bleaching_status(bleaching_status)
select distinct bleaching_status  from global_bleaching_env;

select * from bleaching_status;

-- now lets adjust the original table so we will use this table
alter table global_bleaching_env add column bleaching_status_id int after bleaching_status;

-- lets set up the foreign key reference
alter table global_bleaching_env ADD CONSTRAINT bleaching_status_fk FOREIGN KEY (bleaching_status_id) REFERENCES bleaching_status (bleaching_status_id);

-- populate the column using the dimension table we created
update global_bleaching_env, bleaching_status
set global_bleaching_env.bleaching_status_id = bleaching_status.bleaching_status_id
where global_bleaching_env.bleaching_status = bleaching_status.bleaching_status;

-- lets drop the original column now
alter table global_bleaching_env drop column bleaching_status;

select *
from global_bleaching_env;