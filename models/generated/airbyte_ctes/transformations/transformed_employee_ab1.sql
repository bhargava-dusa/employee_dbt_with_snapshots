{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "_airbyte_transformations",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: {{ source('transformations', '_airbyte_raw_transformed_employee') }}
select
    {{ json_extract_scalar('_airbyte_data', ['employee_id'], ['employee_id']) }} as employee_id,
    {{ json_extract_scalar('_airbyte_data', ['secondary_skill'], ['secondary_skill']) }} as secondary_skill,
    {{ json_extract_scalar('_airbyte_data', ['last_name'], ['last_name']) }} as last_name,
    {{ json_extract_scalar('_airbyte_data', ['hire_date'], ['hire_date']) }} as hire_date,
    {{ json_extract_scalar('_airbyte_data', ['first_name'], ['first_name']) }} as first_name,
    {{ json_extract_scalar('_airbyte_data', ['email'], ['email']) }} as email,
    {{ json_extract_scalar('_airbyte_data', ['primary_skill'], ['primary_skill']) }} as primary_skill,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ source('transformations', '_airbyte_raw_transformed_employee') }} as table_alias
-- transformed_employee
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

