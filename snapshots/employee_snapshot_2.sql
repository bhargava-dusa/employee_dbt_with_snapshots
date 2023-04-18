{% snapshot employee_snapshot_2 %}

{{
    config(
      target_database='mydb',
      target_schema='snapshots',
      unique_key='employee_id',
      strategy='timestamp',
      updated_at='updated_at',
    )
}}

with employee_json as (
    select _airbyte_data as employee_json from {{ source('trans', '_airbyte_raw_dest_employee') }}
),

select 
    utils.get_path(employee_json, 'employee_id') as employee_id,
    utils.get_path(employee_json, 'first_name') as first_name,
    utils.get_path(employee_json, 'last_name') as last_name
from employee_json

{% endsnapshot %}