-- 创建数据表
CREATE TABLE IF NOT EXISTS "T_status" (
"userId" text NOT NULL,
"statusId" text NOT NULL,
"status" text,
PRIMARY KEY("userId","statusId")
);

-- 插入数据
INSERT OR REPLACE INTO T_status (userId,statusId,status) VALUES ('1','101','hello world');

-- 查找数据
SELECT userId,statusId,status FROM T_status
WHERE userId = 1 AND statusId > 100
ORDER BY statusId DESC LIMIT 20;
