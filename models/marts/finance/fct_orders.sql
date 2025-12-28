with orders as (

    select * from {{ ref('stg_jaffle_shop__orders') }}

),

payments as (

    select * from {{ ref('stg_stripe__payments') }}
    where status = 'success'

),

final as (

    select
        orders.order_id,
        orders.customer_id,
        sum(payments.amount) as amount
    from orders
    left join payments
        on orders.order_id = payments.order_id
    group by 1, 2

)

select * from final
