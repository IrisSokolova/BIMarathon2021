use bi_marathon_test_

#  Open source:
-- 'Connecticut','[18000, 20000[' 
-- 'California','[12000, 14000[' 
-- 'Ohio','[12000, 14000[' 
-- 'New York','[22000, 24000[' 
-- 'North Dakota','[12000, 14000[' 
-- 'Arizona','[8000, 10000[' 
-- 'New Hampshire','[16000, 18000[' 

SET SQL_SAFE_UPDATES = 0

-- update district.pp_total_raw using CASE WHEN scenario using open source
update district
set pp_total_raw =
	case 
	when state = 'Connecticut' then COALESCE(pp_total_raw, '[18000, 20000[') 
	when state = 'California' then COALESCE(pp_total_raw, '[12000, 14000[') 
	when state = 'Ohio' then COALESCE(pp_total_raw, '[12000, 14000[')
	when state = 'New York' then COALESCE(pp_total_raw, '[22000, 24000[')
	when state = 'North Dakota' then COALESCE(pp_total_raw, '[12000, 14000[')
	when state = 'Arizona' then COALESCE(pp_total_raw, '[8000, 10000[')
	when state = 'New Hampshire' then COALESCE(pp_total_raw, '[16000, 18000[')
	else pp_total_raw
	end 
where state in ('Connecticut', 'California', 'Ohio', 'New York', 'North Dakota', 'Arizona', 'New Hampshire')

# update district.county_connections_ratio by median
update district
set county_connections_ratio = '[0.18, 1['
where county_connections_ratio is null

# update district.pct_free_reduced by value from open source
update district
set pct_free_reduced = '[0.4, 0.6['
where pct_free_reduced is null


# MULTI-TABLE UPDATE
# Update engagement_index by min values for each district 
# The typical way to handle a situation like this is a multi-table update.        
Update
  fact_engagement as f
  inner join (
	select 
	fact_id
	, coalesce(engagement_index, min_ind) as engagement_index_new
	from 
		(select * 
		, min(engagement_index) over (partition by district_id, product_name) as min_ind
		from fact_engagement) a) b
	on f.fact_id = b.fact_id
   
set f.engagement_index = b.engagement_index_new

Update
  fact_engagement as f
  inner join (
	select 
	fact_id
    , coalesce(pct_access, min_pct) as pct_access_new
	from 
		(select * 
        , min(pct_access) over (partition by district_id) as min_pct
		from fact_engagement) a) b
	on f.fact_id = b.fact_id
   
set f.pct_access = b.pct_access_new

# checking a null values 
select count(engagement_index) 
from fact_engagement 
where engagement_index is null

select count(pct_access) 
from fact_engagement 
where pct_access is null

select count(pct_access) 
from fact_engagement 
where pct_access is null

	





    
        
	
	

