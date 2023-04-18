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
    select _airbyte_data as employee_json_column from {{ source('trans', '_airbyte_raw_dest_employee') }}
)

select 
 {{ json_extract_scalar('employee_json_column', ['employee_id'], ['employee_id']) }} as employee_id,
 {{ json_extract_scalar('employee_json_column', ['first_name'], ['first_name']) }} as first_name,
 {{ json_extract_scalar('employee_json_column', ['last_name'], ['last_name']) }} as last_name,
 {{ json_extract_scalar('employee_json_column', ['updated_at'], ['updated_at']) }} as updated_at
from employee_json

{% endsnapshot %}