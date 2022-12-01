{{ config(materialized='view') }}

--- https://earthquake.usgs.gov/data/comcat/index.php#mag

--- when the id's are the same, and the updated times are different,
--- the most recent updated id takes precedent. 
with equake_data as 
(
  select *,
  row_number() over(partition by id order by updated desc) as rn
  from {{ source('staging','geo_json') }}
)

select 
  id as eventid,
  mag as magnitude,
  place as location_description,
  time as time,
  updated as date_updated,
  tz as timezone,
  url as feed_url,
  detail as geojson_detail_feed_url,
  felt as dyfi_felt_count,
  cdi as dyfi_max_intensity,
  mmi as shakemap_max_instrumental_intensity,
  alert as alert_level,
  status as status,
  tsunami as tsunami,
  sig as significance,
  net as prefered_network_id,
  code as source_code_id,
  ids as event_ids_associated,
  sources as source_network_contributors,
  types as  product_types_associated,
  nst as seismic_station_report_count,
  dmin as horizontal_distance_degrees_epicenter,
  rms as root_mean_time_travel_time_residual_seconds,
  gap as max_azimuthal_gap,
  magType as magnitude_type,
  type as siesmic_type,
  title as feed_title,
  geometry as geometry
  -- cdc_hash
  -- inserted_at
from equake_data
where rn=1

-- dbt build --m <model.sql> --var 'is_test_run: false'
-- {% if var('is_test_run', default=true) %}

--  limit 100

-- {% endif %}