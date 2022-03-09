use ccdb;
-- 创建临时表
DROP TEMPORARY TABLE IF EXISTS current_date_360_tmp;
DROP TEMPORARY TABLE IF EXISTS history_order_tmp;
DROP TEMPORARY TABLE IF EXISTS current_date_90_tmp;
DROP TEMPORARY TABLE IF EXISTS d_type_user_tmp;
DROP TEMPORARY TABLE IF EXISTS user_layer_tmp;
DROP TEMPORARY TABLE IF EXISTS a_type_user_tmp;
DROP TEMPORARY TABLE IF EXISTS b_type_user_tmp;
DROP TEMPORARY TABLE IF EXISTS c_type_user_tmp;

CREATE TEMPORARY TABLE current_date_360_tmp
	select t.s_uid,
 		case when t.cnt=1 then t.cnt end as thr_user,
 		case when t.cnt=2 then t.cnt end as two_user,
 		case when t.cnt>=3 then t.cnt end as one_user
   	from
 		(select s_uid, count(1) as cnt
  	 	from user_layer_data a
  	 	where s_createtime between date_add(now(), interval -720 day) and now()
       	and t_driverstatus=4
     	and d_orderstatus in (3,4)
       	group by s_uid
      	)t ;

CREATE TEMPORARY TABLE a_type_user_tmp
	select
 	count(distinct case when thr_user=1 then o.s_uid end) as thr_user_cnt
 	from current_date_360_tmp o ;

CREATE TEMPORARY TABLE b_type_user_tmp
	select
 	count(distinct case when two_user=2 then o.s_uid end) as two_user_cnt
 	from current_date_360_tmp o ;

CREATE TEMPORARY TABLE c_type_user_tmp
	select
 	count(distinct case when one_user>=3 then o.s_uid end) as one_user_cnt
 	from current_date_360_tmp o ;

CREATE TEMPORARY TABLE history_order_tmp
	select s_uid
	from user_layer_data
	where t_driverstatus=4
	and d_orderstatus in (3,4)
	group by s_uid ;

-- 历史有完单，最近90天完单用户
CREATE TEMPORARY TABLE current_date_90_tmp
	select s_uid
	from user_layer_data
	where t_driverstatus=4
	and s_createtime between date_add(now(), interval -90 day) and now()
	and d_orderstatus in (3,4)
	group by s_uid;

-- D 历史有完单，最近90天无完单用户
CREATE TEMPORARY TABLE d_type_user_tmp
	select count(distinct h.s_uid) 90_user_cnt
	from history_order_tmp h
	left join current_date_90_tmp n
	on h.s_uid=n.s_uid
	where n.s_uid is null ;

CREATE TEMPORARY TABLE user_layer_tmp
select * from
(
select 'A类用户' as user_type, '大于等于3单用户' as details,  one_user_cnt as user_cnt from c_type_user_tmp
union all
select 'B类用户' as user_type, '等于2单用户' as details,  two_user_cnt as user_cnt from b_type_user_tmp
union all
select 'C类用户' as user_type , '等于1单用户' as details,  thr_user_cnt as user_cnt from a_type_user_tmp
union all
select 'D类用户' as user_type, '历史有完单，最近90天无完单用户' as details, 90_user_cnt as user_cnt  from d_type_user_tmp
)t ;

select 
user_type `分类`, 
details `打车完成订单量和历史行为`, 
user_cnt `用户数量`
from user_layer_tmp ;

