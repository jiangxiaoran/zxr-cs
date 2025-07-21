-- 作业定义表
CREATE TABLE job_def (
    job_id         BIGINT PRIMARY KEY AUTO_INCREMENT,
    job_code       VARCHAR(100) NOT NULL UNIQUE COMMENT '作业编码',
    job_name       VARCHAR(200) NOT NULL COMMENT '作业名称',
    job_group      VARCHAR(200) NOT NULL COMMENT '作业组',
    job_order      VARCHAR(200) NOT NULL COMMENT '作业序号',
    group_order    VARCHAR(200) NOT NULL COMMENT '组序号',
    proc_name      VARCHAR(200) COMMENT '存储过程名',
    job_type       VARCHAR(50) COMMENT '作业类型（PROC/SCRIPT）',
    schedule_time  TIME,
    status         VARCHAR(20) DEFAULT 'active',
    timeout_sec    INT DEFAULT 1800 COMMENT '超时时间（秒）',
    retry_count    INT DEFAULT 0 COMMENT '失败重试次数',
    notify_email   VARCHAR(500) COMMENT '失败通知邮箱',
    is_depend      TINYINT(1) DEFAULT 1 COMMENT '1 有依赖 0 没有依赖',
    is_active      TINYINT(1) DEFAULT 1,
    last_run_time  DATETIME,
    next_run_time  DATETIME,
    create_time    DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time    DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT='作业定义表';



-- 作业执行日志表
CREATE TABLE job_execution_logs (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    job_code                VARCHAR(100) NOT NULL UNIQUE COMMENT '作业编码',
    executor_proc           VARCHAR(255)        DEFAULT NULL COMMENT '执行进程',
    executor_address        VARCHAR(255)        DEFAULT NULL COMMENT '执行地址',
    start_time              DATETIME,
    end_time                DATETIME,
    status                  VARCHAR(20),  -- success / failed --执行状态
    error_message           TEXT,
    duration                INT,  -- 执行耗时（秒）
    notify_status           VARCHAR(20),  -- NOTIFIED / UNNOTIFIED --通知状态
    retry_count             INT --重试次数
);

-- 邮件通知表
CREATE TABLE email_notifications (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    job_code       VARCHAR(100) NOT NULL UNIQUE COMMENT '作业编码',
    recipient_email VARCHAR(255) NOT NULL,
    subject VARCHAR(255) NOT NULL,
    body TEXT NOT NULL,
    status ENUM('pending', 'sent', 'failed') NOT NULL DEFAULT 'pending',
    send_time DATETIME NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    fail_reason TEXT NULL,
    type VARCHAR(50) NULL,
    retry_count INT NOT NULL DEFAULT 0,
    is_system BOOLEAN NOT NULL DEFAULT TRUE

);


执行逻辑
1. 从作业定义表job_def获取待执行的存储过程。分组按顺序把作业放入队列。
2. 按照作业顺序调用队列中相应过程执行，记录执行日志
3. 执行结束后发送作业通知给相关人员。
