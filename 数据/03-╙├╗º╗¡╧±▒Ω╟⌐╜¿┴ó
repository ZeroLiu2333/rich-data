-- 此用户画像标签是建立在购买专车经济型的用户之上

-- 创建临时表
DROP TEMPORARY TABLE IF EXISTS buy_econo_tmp;
DROP TEMPORARY TABLE IF EXISTS buy_comfortab_tmp;
DROP TEMPORARY TABLE IF EXISTS buy_luxury_tmp;
DROP TEMPORARY TABLE IF EXISTS buy_business_tmp;

-- 为购买专车经济型的用户打上标签
CREATE TEMPORARY TABLE buy_econo_tmp
select uid, sum(1) as buy_econo_num
          from order_basic_data
          where order_car_type_id is not null
          and order_car_type_id=1
          group by uid ;

-- 为购买专车舒适型的用户打上标签
 CREATE TEMPORARY TABLE buy_comfortab_tmp
 select uid, sum(1) as buy_comfortab_num
          from order_basic_data
          where order_car_type_id is not null
          and order_car_type_id=2
          group by uid;

-- 为购买专车豪华型的用户打上标签
 CREATE TEMPORARY TABLE buy_luxury_tmp 
 select uid, sum(1) as buy_luxury_num
          from order_basic_data
          where order_car_type_id is not null
          and order_car_type_id=3
          group by uid ;

CREATE TEMPORARY TABLE buy_business_tmp        
-- 为购买专车商务型的用户打上标签
  select uid, sum(1) as buy_business_num
          from order_basic_data
          where order_car_type_id is not null
          and order_car_type_id=5
          group by uid ;

SELECT 
buy_econo_tmp.uid `用户唯一标识`,
buy_econo_tmp.buy_econo_num `专车经济型购买次数`, 
buy_comfortab_tmp.buy_comfortab_num `专车舒适型购买次数`, 
buy_luxury_tmp.buy_luxury_num `专车豪华型购买次数`, 
buy_business_tmp.buy_business_num `专车商务型购买次数`

FROM buy_econo_tmp
 left join buy_comfortab_tmp on buy_econo_tmp.uid=buy_comfortab_tmp.uid
 left join buy_luxury_tmp on buy_econo_tmp.uid=buy_luxury_tmp.uid
 left join buy_business_tmp on buy_econo_tmp.uid=buy_business_tmp.uid
where buy_econo_tmp.buy_econo_num is not null 
and buy_comfortab_tmp.buy_comfortab_num is not NULL
and buy_luxury_tmp.buy_luxury_num  is not NULL
and buy_business_tmp.buy_business_num is not NULL
group by buy_econo_tmp.uid ,
buy_econo_tmp.buy_econo_num , 
buy_comfortab_tmp.buy_comfortab_num , 
buy_luxury_tmp.buy_luxury_num , 
buy_business_tmp.buy_business_num
