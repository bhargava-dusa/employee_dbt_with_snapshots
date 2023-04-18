{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "trans",
    post_hook = ["
                    {%
                        set scd_table_relation = adapter.get_relation(
                            database=this.database,
                            schema=this.schema,
                            identifier='dest_employee_scd'
                        )
                    %}
                    {%
                        if scd_table_relation is not none
                    %}
                    {%
                            do adapter.drop_relation(scd_table_relation)
                    %}
                    {% endif %}
                        "],
    tags = [ "top-level" ]
) }}
-- Final base SQL model
-- depends_on: {{ ref('dest_employee_ab3') }}
select
    updated_at,
    employee_id,
    secondary_skill,
    last_name,
    created_at,
    hire_date,
    first_name,
    email,
    primary_skill,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at,
    _airbyte_dest_employee_hashid
from {{ ref('dest_employee_ab3') }}
-- dest_employee from {{ source('trans', '_airbyte_raw_dest_employee') }}
where 1 = 1

