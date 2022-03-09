use ccdb;
-- 如果存在临时表，则删除临时表
DROP TEMPORARY TABLE IF EXISTS history_user_tmp;
DROP TEMPORARY TABLE IF EXISTS new_user_tmp;
DROP TEMPORARY TABLE IF EXISTS 201611_2016131_user_cnt_tmp;
DROP TEMPORARY TABLE IF EXISTS new_user_cnt_tmp;
DROP TEMPORARY TABLE IF EXISTS user_avg_day_90_tmp;
DROP TEMPORARY TABLE IF EXISTS user_avg_day_180_tmp;
DROP TEMPORARY TABLE IF EXISTS user_avg_day_270_tmp;
DROP TEMPORARY TABLE IF EXISTS user_avg_day_360_tmp;

-- 获取订单状态为完成单，服务类型为接机，送机，接站，送站 下单时间在'2016/1/1' 之前的历史用户
CREATE TEMPORARY TABLE history_user_tmp
-- 用户进行去重
	select distinct uid
	from order_basic_data a
-- 订单状态为完成单
	where order_status in (6,7)
-- 服务类型为接机，送机，接站，送站
	and service_type in (1,2,4,5)
-- 在'2016/1/1' 之前的历史用户
	and book_day < '2016/1/1' ;


-- 获取订单状态为完成单，服务类型为接机，送机，接站，送站 下单时间在 '2016/1/1' 到 '2016/1/31' 出现的用户
CREATE TEMPORARY TABLE new_user_tmp
-- 用户进行去重
	select   distinct uid
	from order_basic_data a
-- 订单状态为完成单
	where order_status in (6,7)
-- 服务类型为接机，送机，接站，送站
	and service_type in (1,2,4,5)
-- 在 '2016/1/1' 到 '2016/1/31' 出现的用户
	and book_day between '2016/1/1' and '2016/1/31';



-- 获取订单状态为完成单，服务类型为接机，送机，接站，送站 下单时间在 2016/1月 所有的用户数
CREATE TEMPORARY TABLE 201611_2016131_user_cnt_tmp
	select   '2016.1' as dt, count(distinct uid) as user_cnt
	from order_basic_data a
-- 订单状态为完成单
	where order_status in (6,7)
-- 服务类型为接机，送机，接站，送站
	and service_type in (1,2,4,5)
-- 在 '2016/1/1' 到 '2016/1/31' 出现的用户
	and book_day  between '2016/1/1' and '2016/1/31';


-- 统计 '2016/1/1' 到 '2016/1/31' 出现的新用户
CREATE TEMPORARY TABLE new_user_cnt_tmp
	select b.uid
	from history_user_tmp b 
	left join new_user_tmp a on a.uid = b.uid
	where a.uid is null  ;


-- 统计在'2016/1/1' 在 '2016/1/31' 出现的新用户的基础上，最近90天下单的用户 下面的180，270，360 天逻辑同90天
CREATE TEMPORARY TABLE user_avg_day_90_tmp
	select '2016.1' as dt, 
-- 总天数/总用户 得到用户平均生命周期
	sum(day_cnt)  / count(distinct uid)   user_avg_rate, 
-- 总订单数/总用户 得到生命周期内频次
	sum(order_cnt)  / count(distinct uid)    order_user_avg_rate
	from
		(select 
		t.uid, datediff(max_book_day, min_book_day) as day_cnt ,max_book_day, t.order_cnt
		from
			(
-- 在'2016/1/1' 在 '2016/1/31' 出现的新用户的基础上，得到最大下单时间，最小下单时间，已经订单数
			select  n.uid, max(book_day) as max_book_day, 
	 			min(book_day) as min_book_day, 
	 			count(distinct c.trade_order_id) as order_cnt
			from new_user_cnt_tmp n
			join order_basic_data c
			on n.uid=c.uid
			where order_status in (6,7)
			and service_type in (1,2,4,5) 
			group by n.uid
	
	 		) t
-- 当前时间和最大下单时间比较大于等于90天
		where datediff(now(), t.max_book_day)>=90
		) t1  ;

-- '2016/1/1' 在 '2016/1/31' 出现的新用户，最近180天下单的用户
CREATE TEMPORARY TABLE user_avg_day_180_tmp 
	select '2016.1' as dt, 
	sum(day_cnt)  / count(distinct uid)   user_avg_rate, 
	sum(order_cnt)  / count(distinct uid)    order_user_avg_rate
	from
		(select 
		t.uid, datediff(max_book_day, min_book_day) as day_cnt ,max_book_day, t.order_cnt
		from
			(
			select  n.uid, max(book_day) as max_book_day, 
	 		min(book_day) as min_book_day, 
	 		count(distinct c.trade_order_id) as order_cnt
			from new_user_cnt_tmp n
			join order_basic_data c
			on n.uid=c.uid
			where order_status in (6,7)
			and service_type in (1,2,4,5) 
			group by n.uid
	
	 		) t
		where datediff(now(), t.max_book_day)>=180
		) t1  ;

-- '2016/1/1' 到 '2016/1/31'出现的新用户，最近270天下单的用户
CREATE TEMPORARY TABLE user_avg_day_270_tmp
	select '2016.1' as dt, 
	sum(day_cnt)  / count(distinct uid)   user_avg_rate, 
	sum(order_cnt)  / count(distinct uid)    order_user_avg_rate
	from
		(select 
		t.uid, datediff(max_book_day, min_book_day) as day_cnt ,max_book_day, t.order_cnt
		from
			(
			select  n.uid, max(book_day) as max_book_day, 
	 		min(book_day) as min_book_day, 
	 		count(distinct c.trade_order_id) as order_cnt
			from new_user_cnt_tmp n
			join order_basic_data c
			on n.uid=c.uid
			where order_status in (6,7)
			and service_type in (1,2,4,5) 
			group by n.uid
	
	 		) t
		where datediff(now(), t.max_book_day)>=270
		) t1 ;

-- '2016/1/1' 到 '2016/1/31' 出现的新用户，最近360天下单的用户
CREATE TEMPORARY TABLE user_avg_day_360_tmp
	select '2016.1' as dt, 
	sum(day_cnt)  / count(distinct uid)   user_avg_rate, 
	sum(order_cnt)  / count(distinct uid)    order_user_avg_rate
	from
		(select 
		t.uid, datediff(max_book_day, min_book_day) as day_cnt ,max_book_day, t.order_cnt
		from
			(
			select  n.uid, max(book_day) as max_book_day, 
	 		min(book_day) as min_book_day, 
	 		count(distinct c.trade_order_id) as order_cnt
			from new_user_cnt_tmp n
			join order_basic_data c
			on n.uid=c.uid
			where order_status in (6,7)
			and service_type in (1,2,4,5) 
			group by n.uid
	
	 		) t
		where datediff(now(), t.max_book_day)>=360
		) t1 ;

-- 将所有的结果进行合并展示
select  
c.dt, c.user_cnt `完单用户数`, 
round(u.user_avg_rate,2) `90天用户平均生命周期`, 
round(u.order_user_avg_rate,2) `90天生命周期内频次`,
round(u1.user_avg_rate,2) `180天用户平均生命周期`, 
round(u1.order_user_avg_rate,2) `180天生命周期内频次`,
round(u2.user_avg_rate,2) `270天用户平均生命周期`, 
round(u2.order_user_avg_rate,2) `270天生命周期内频次`,
round(u3.user_avg_rate,2) `360天用户平均生命周期`, 
round(u3.order_user_avg_rate,2 ) `360天生命周期内频次`
from user_avg_day_90_tmp u
left join 201611_2016131_user_cnt_tmp c
on c.dt=u.dt
left join user_avg_day_180_tmp u1
on c.dt=u1.dt
left join user_avg_day_270_tmp u2
on c.dt=u2.dt
left join user_avg_day_360_tmp u3
on c.dt=u3.dt
