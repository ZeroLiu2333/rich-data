-- 品牌规则-8点服务下线预告-接送机
use ccdb;
DROP TEMPORARY TABLE IF EXISTS goods_upper_and_lower_data_tmp;
DROP TEMPORARY TABLE IF EXISTS goods_upper_and_lower_data2_tmp;


CREATE TEMPORARY TABLE goods_upper_and_lower_data_tmp
select
t.hidden_start_time `日期`,
t.ota_name `品牌`,
t.city_name `城市`,
t.hidden_reason `下线原因`,
t.punish_score `罚分`,
t.earliest_recoverable_time `最早恢复时间`
from
(
 select hidden_start_time, ota_name, city_name,hidden_reason,
 punish_score, earliest_recoverable_time 
from goods_upper_and_lower_data
where hidden_status=1
and hidden_start_time >= '2018/5/26'
and hidden_start_time <='2019/6/4'
and service_type_simple=1 
) t
where 1=1
group by  t.hidden_start_time,
t.ota_name,
t.city_name,
t.hidden_reason,
t.punish_score,
t.earliest_recoverable_time
order by t.hidden_start_time desc ;


-- 品牌规则-8点服务下线预告-接送站
CREATE TEMPORARY TABLE goods_upper_and_lower_data2_tmp
select
t.hidden_start_time `日期`,
t.ota_name `品牌`,
t.city_name `城市`,
t.hidden_reason `下线原因`,
t.punish_score `罚分`,
t.earliest_recoverable_time `最早恢复时间`
from
(
 select hidden_start_time, ota_name, city_name, hidden_reason,
 punish_score, earliest_recoverable_time 
from goods_upper_and_lower_data
where hidden_status=1
and hidden_start_time >= '2018/5/26'
and hidden_start_time <='2019/6/4'
and service_type_simple=4 
) t
where 1=1
group by  t.hidden_start_time,
t.ota_name,
t.city_name,
t.hidden_reason,
t.punish_score,
t.earliest_recoverable_time
order by t.hidden_start_time desc ;


select * from goods_upper_and_lower_data_tmp
union all
select * from goods_upper_and_lower_data2_tmp
