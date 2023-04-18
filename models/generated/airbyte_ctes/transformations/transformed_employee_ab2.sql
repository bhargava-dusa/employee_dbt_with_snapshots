{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "_airbyte_transformations",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to cast each column to its adequate SQL type converted from the JSON schema type
-- depends_on: {{ ref('transformed_employee_ab1') }}
select
    cast(employee_id as {{ dbt_utils.type_bigint() }}) as employee_id,
    cast(secondary_skill as {{ dbt_utils.type_string() }}) as secondary_skill,
    cast(last_name as {{ dbt_utils.type_string() }}) as last_name,
    cast({{ empty_string_to_null('hire_date') }} as {{ type_date() }}) as hire_date,
    cast(first_name as {{ dbt_utils.type_string() }}) as first_name,
    cast(email as {{ dbt_utils.type_string() }}) as email,
    cast(primary_skill as {{ dbt_utils.type_string() }}) as primary_skill,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('transformed_employee_ab1') }}
-- transformed_employee
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

