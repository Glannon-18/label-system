package com.ruoyi.common.constant;

/**
 * 任务状态常量类（使用字符串）
 */
public final class TaskStatus {

    // 私有构造函数，防止实例化
    private TaskStatus() {
        throw new UnsupportedOperationException("This is a utility class and cannot be instantiated.");
    }

    /**
     * 未开始
     */
    public static final String UNSTART = "unstart";

    /**
     * 标注中
     */
    public static final String UNDERWAY = "underway";

    /**
     * 待审核
     */
    public static final String PENDING_REVIEW = "pending_review";


    /**
     * 已驳回
     */
    public static final String REJECT = "reject";

    /**
     * 审核通过
     */
    public static final String PASS = "pass";


}
