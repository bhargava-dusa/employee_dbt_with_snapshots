{{ config(
    indexes = [{'columns':['_airbyte_unique_key'],'unique':True}],
    unique_key = "_airbyte_unique_key",
    schema = "transformations",
    tags = [ "top-level" ]
) }}
-- Final base SQL model
-- depends_on: {{ ref('transformed_employee_scd') }}
select
    _airbyte_unique_key,
    employee_id,
    secondary_skill,
    last_name,
    hire_date,
    first_name,
    email,
    primary_skill,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at,
    _airbyte_transformed_employee_hashid
from {{ ref('transformed_employee_scd') }}
-- transformed_employee from {{ source('transformations', '_airbyte_raw_transformed_employee') }}
where 1 = 1
and _airbyte_active_row = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

