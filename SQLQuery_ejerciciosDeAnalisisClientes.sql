
--a. Cantidad de órdenes y monto total de las órdenes, por ciudad, país a nivelaño-mes.
select year(o.order_date) as anio, month(o.order_date)  as mes, o.country, o.city, sum(o.order_amount)  as ventas from orders o
group by year(o.order_date), month(o.oder_date), o.country, o.city
order by anio, mes asc

--b. Cantidad de restaurantes en Uruguay, según categoría del restaurante, que
--tienen por lo menos un monto mensual (order_amount) en abril 2017 mayor a 1000.

select r.category, count(o.id) as cantidad from restaurants R 
inner join orders o on r.id=o.restaurant_id
where o.country="Uruguay" and year(o.order_date)=2017 and month(o.order_date)=4
group by r.category

--c. Usando todas las órdenes en la base:
--a. Calcular el promedio de días entre una orden y la siguiente a nivel usuario,
--solo para usuarios con al menos 5 órdenes totales.
--b. De ese resultado, quedarse solo con usuarios con un promedio mayor a
--20 días.


select t1.user_id, avg(datediff(day,t1.dia_anterior,t1.order_date)) as avg_dias  
from  
    (select o.user_id, t2.cantidad, o.order_date, lag(o.order_date) over (partition by o.user_id order by o.order_date) as dia_anterior from orders o
    inner join
        (select user_id, count(id) as cantidad from orders
        group by user_id) t2 on t2.user_id=o.user_id
    where t2.cantidad>4
) t1
group by t1.user_id
having avg(datediff(day,t1.dia_anterior,t1.order_date))>20


--d. Calcular a nivel usuario qué porcentaje de sus órdenes confirmadas se realizaron
--en restaurantes que pertenecen al “Top 100” restaurantes (según cantidad de
--órdenes confirmadas).

select u.id, (cast(t2.tops as float)/t3.total)*100 as porcentaje_top from users u
inner join
    (select u.id, count(o.id) as total from users u
    inner join orders o on o.user_id=u.id
    group by u.id) t3 on t3.id=u.id
inner join
    (select u.id, count(o.id) as tops from users u
    inner join orders o on o.user_id=u.id
    inner join 
    (
        select top 100 r.id as id, count(o.id) pedidos from restaurants r
        inner join orders o on o.restaurant_id=r.id
        where o.delivered_date is not NULL
        group by r.id
    ) t1 on t1.id=o.restaurant_id
    group by u.id) 
t2 on t2.id=u.id
order by u.id desc





