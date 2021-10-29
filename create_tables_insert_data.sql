-- Creating a data base
create database bi_marathon_test_;
use bi_marathon_test_ ;

-- temp_table_34 has been uploaded using the to_sql() function python

ALTER TABLE temp_table_34 
RENAME COLUMN time TO eng_time;

create table product
	(  lp_id int not null auto_increment                      
	, url varchar(255)
	, product_name varchar(255)
	, provider_company_name varchar(255)
	, ps_function_main varchar(30)
	, ps_function_sub varchar(255)
	, primary key (lp_id)
	)

create table district
(
	pk_district_id int not null auto_increment
	, district_id int NOT NULL UNIQUE 
	, pp_total_raw varchar(255)            
	, state varchar(255)
	, locale varchar(255)
	, pct_black_hispanic varchar(255)
	, pct_free_reduced varchar(255)
	, county_connections_ratio varchar(255)
	, primary key (pk_district_id)
)

create table fact_engagement
( 
	fact_id int not null auto_increment
	, eng_time  varchar(255)                   
	, pct_access varchar(50)              
	, engagement_index varchar(30)
	, corporate boolean
	, higher_ed boolean
	, prek_12 boolean
	, district_id int
	, lp_id int
	, product_name varchar(255)
	, primary key (fact_id)
	, foreign key (district_id) references district (district_id) on delete set null
	, foreign key (lp_id) references product (lp_id) on delete set null
)

-- insert data into product table
insert ignore into product(url, product_name, provider_company_name, ps_function_main, ps_function_sub)
select distinct url, product_name, provider_company_name, ps_function_main, ps_function_sub 
from temp_table_34

-- insert data into district table
insert ignore into district(district_id, state, locale, pct_black_hispanic, pct_free_reduced, county_connections_ratio, pp_total_raw)
select distinct 
	district_id
	, state
	, locale
	, pct_black_hispanic
	, pct_free_reduced
	, county_connections_ratio
	, pp_total_raw
from temp_table_34

-- insert data into fact_engagement table
insert ignore into fact_engagement(eng_time, pct_access, engagement_index, corporate, higher_ed, prek_12, district_id, lp_id, product_name)
select distinct 
	t.eng_time
	, t.pct_access
	, t.engagement_index
	, t.corporate
	, t.higher_ed
	, t.prek_12
	, d.district_id
	, p.lp_id
	, p.product_name
from temp_table_34 t
join district d on d.district_id = t.district_id
join product p on p.product_name = t.product_name

-- validate the tabels
select * from fact_engagement
select * from product
select count(*)
from
(select district_id,
	count(*)
from district
group by 1) a

select * from fact_engagement
select count(*) from fact_engagement
select * from district
select count(*) from district
select * from product
select count(*) from product




