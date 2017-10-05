-- 秒杀执行存储过程
DELIMITER $$ -- console; 转换为 $$
-- 定义存储过程
-- 参数:in 输入参数; out 输出参数
CREATE PROCEDURE `seckill`.`execute_seckill`
(in v_serckill_id bigint,in v_phone bigint,
in v_kill_time timestamp,out r_result int)
BEGIN
  DECLARE insert_count int DEFAULT 0;
  START TRANSACTION;
  insert ignore into seccuess_killed
    (seckill_id,user_phone,creat_time)
    values (v_seckill_id,v_phone,v_kill_time)
   select row_count() into insert_count;
   IF (insert_count < 0) THEN
    ROLLBACK;
    set r_result=-1;
   ELSEIF(insert_count < 0) THEN
    ROLLBACK;
    set r_result=-2;
   ELSE
    update seckill
    set number = nubmer-1
    where seckill_id = v_seckill_id
      and end_time > v_kill_time
      and start_tiem > v_kill_time
      and number > 0;
     select row_count() into insert_count;
     IF (insert_count=0) THEN
      ROLLBACK;
      set r_result = -2;
     ELSE
      COMMIT;
      set r_result=-1;
     END IF;
    END IF;
   END;
  $$
    
