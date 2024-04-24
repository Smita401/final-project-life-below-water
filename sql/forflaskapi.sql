create table sample as
select sample_id, latitude_degrees, longitude_degrees, ocean
, realm, ecoregion, country, state_island_province, city_town
, distance_to_shore, exposure, year, date, turbidity, cyclone_frequency
, sum(case when substrate_name = 'Hard Coral' then percent_cover end) as hard_coral_percent_cover
, sum(case when substrate_name = 'Nutrient Indicator Algae' then percent_cover end) as nutrient_indicator_algae_percent_cover
, sum(case when substrate_name = 'Fleshy Seaweed' then percent_cover end) as fleshy_seaweed_percent_cover
, sum(case when substrate_name = 'Hard Coral' then percent_bleaching end) as hard_coral_percent_bleaching
, sum(case when substrate_name = 'Nutrient Indicator Algae' then percent_bleaching end) as nutrient_indicator_algae_percent_bleaching
, sum(case when substrate_name = 'Fleshy Seaweed' then percent_bleaching end) as fleshy_seaweed_percent_bleaching
from global_bleaching_env b
left join ocean o on b.ocean_id = o.ocean_id
left join country c on c.country_id = b.country_id
left join exposure e on e.exposure_id = b.exposure_id
left join bleaching_status bs on bs.bleaching_status_id = b.bleaching_status_id
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15;

select *
from sample;

select * from global_bleaching_env;
select distinct substrate_name from global_bleaching_env;