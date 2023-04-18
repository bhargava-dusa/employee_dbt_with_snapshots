{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "_airbyte_transformations",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to build a hash column based on the values of this record
-- depends_on: {{ ref('transformed_employee_ab2') }}
select
    {{ dbt_utils.surrogate_key([
        'employee_id',
        'secondary_skill',
        'last_name',
        'hire_date',
        'first_name',
        'email',
        'primary_skill',
    ]) }} as _airbyte_transformed_employee_hashid,
    tmp.*
from {{ ref('transformed_employee_ab2') }} tmp
-- transformed_employee
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at', this) }}

