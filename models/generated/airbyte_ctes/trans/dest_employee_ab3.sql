{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "_airbyte_trans",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to build a hash column based on the values of this record
-- depends_on: {{ ref('dest_employee_ab2') }}
select
    {{ dbt_utils.surrogate_key([
        'updated_at',
        'employee_id',
        'secondary_skill',
        'last_name',
        'created_at',
        'hire_date',
        'first_name',
        'email',
        'primary_skill',
    ]) }} as _airbyte_dest_employee_hashid,
    tmp.*
from {{ ref('dest_employee_ab2') }} tmp
-- dest_employee
where 1 = 1

