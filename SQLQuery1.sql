select *
from brands_v2 

select *
from finance

select *
from reviews_v2 

select *
from traffic_v3 


select b.product_id,b.brand,f.sale_price,f.revenue
from brands_v2 as b
inner join finance as f
on b.product_id=f.product_id


select b.brand,round(sum(f.revenue),0) AS Total_revenue
from brands_v2 as b
inner join finance as f
on b.product_id=f.product_id
where b.brand is not NULL
group by b.brand 


select  b.brand , sum(r.rating) 
from brands_v2 as b
inner join reviews_v2 as r
on b.product_id = r.product_id
where b.brand is not NULL
group by b.brand


select min(last_visited),max(last_visited)
from traffic_v3

select  top 5 b.product_id , b.brand ,i.product_name , round(sum(f.revenue),0) as total
from brands_v2 as b
inner join info_v2 as i
on b.product_id = i.product_id
inner join traffic_v3 as t
on b.product_id = t.product_id
inner join finance as f
on b.product_id = f.product_id
where i.product_name is not null
group by  b.product_id , b.brand,i.product_name
order by total DESC


--Is there a difference in the amount of discount offered between the brands?
select b.brand , avg(discount)*100
from brands_v2 as b
inner join finance as f 
on b.product_id = f.product_id
where brand is not null
group by b.brand;



--Is there any correlation between revenue and reviews? And if so, how strong is it?
WITH Stats AS (
    SELECT
        COUNT(*) AS n,
        SUM(f.revenue) AS sum_X,
        SUM(r.reviews) AS sum_Y,
        SUM(f.revenue * r.reviews) AS sum_XY,
        SUM(f.revenue * f.revenue) AS sum_X2,
        SUM(r.reviews * r.reviews) AS sum_Y2
    FROM finance as f
	inner join reviews_v2 as r
	on f.product_id = r.product_id
)
SELECT
    (n * sum_XY - sum_X * sum_Y) /
    (SQRT(n * sum_X2 - sum_X * sum_X) * SQRT(n * sum_Y2 - sum_Y * sum_Y)) AS correlation
FROM Stats;


--Are there any trends or gaps in the volume of reviews by month?
select brand ,month(t.last_visited) as month_number , count(reviews) As count_reviews
from traffic_v3 as t 
inner join reviews_v2 as r
on t.product_id = r.product_id
inner join brands_v2 as b
on t.product_id = b.product_id
where brand is not null and month(t.last_visited) is not null
group by brand ,month(t.last_visited)
order by brand , month_number ;


