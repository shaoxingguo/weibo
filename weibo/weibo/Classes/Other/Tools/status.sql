-- 创建数据表
CREATE TABLE IF NOT EXISTS "T_status" (
"userId" text NOT NULL,
"statusId" integer NOT NULL,
"status" text,
"createTime" TEXT DEFAULT (datetime('now', 'localtime')),
PRIMARY KEY("userId","statusId")
);
