{% snapshot employee_snapshot %}

{{
    config(
      target_database='mydb',
      target_schema='snapshots',
      unique_key='employee_id',
      strategy='timestamp',
      updated_at='updated_at',
    )
}}

select * from {{ source('trans', '_airbyte_raw_dest_employee') }}
{% endsnapshot %}