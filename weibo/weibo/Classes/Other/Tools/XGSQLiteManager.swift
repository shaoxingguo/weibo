//
//  XGSQLiteManager.swift
//  weibo
//
//  Created by monkey on 2019/2/12.
//  Copyright © 2019 itcast. All rights reserved.
//

import FMDB

class XGSQLiteManager
{
    // MARK: - 构造方法
    
    init(path:String)
    {
        // 保存路径
        cachePath = path
        
        // 打开数据库
        queue = FMDatabaseQueue(path: path)
        let message = (queue == nil ? "数据库打开失败!" : "数据库打开成功")
        XGPrint(message)
    }
    
    deinit {
        // 关闭数据库
        queue?.close()
    }
    
    // MARK: - 内部私有属性
    
    /// 串行队列 执行sql语句
    private var queue:FMDatabaseQueue?
    /// 数据库缓存路径
    private var cachePath:String
}

// MARK: - 数据库相关

extension XGSQLiteManager
{
    /// 创建数据表
    open func createTables(sql:String) -> Bool
    {
        guard let queue = queue else {
            return false
        }
        
        var isSuccess:Bool = false
        queue.inDatabase { (db) in
            isSuccess = db.executeStatements(sql)
        }
        
        return isSuccess
    }
    
    /// 向数据库中查找数据
    ///
    /// - Parameters:
    ///   - sql: sql语句
    ///   - arguments: 参数
    /// - Returns: 查询结果
    open func query(sql:String,arguments:[Any]? = nil) -> [[String:Any]]
    {
        // 查找结果
        var statusList = [[String:Any]]()
        guard let queue = queue else {
            return statusList
        }

        queue.inDatabase { (db) in
            guard let result = db.executeQuery(sql, withArgumentsIn: arguments ?? []) else {
                return
            }
            
            while result.next() {
                var status = [String:Any]()
                for i in 0..<result.columnCount {
                    if let key = result.columnName(for: i),
                        let value = result.object(forColumnIndex: i) {
                        status[key] = value
                    }
                }
                
                statusList.append(status)
            }
        }
        
        return statusList
    }
    
    /// 向数据库中插入一条记录
    ///
    /// - Parameters:
    ///   - sql: sql语句
    ///   - arguments: 参数
    /// - Returns: 是否成功
    open func insert(sql:String,arguments:[Any]? = nil) -> Bool
    {
        return inTransaction(sql: sql, arguments: arguments)
    }
    
    /// 更新记录
    open func update(sql:String,arguments:[Any]? = nil) -> Bool
    {
        return inTransaction(sql: sql, arguments: arguments)
    }
    
    /// 删除记录
    open func delete(sql:String,arguments:[Any]? = nil) -> Bool
    {
        return inTransaction(sql: sql, arguments: arguments)
    }
    
    /// 事务方式执行sql
    open func inTransaction(sql:String,arguments:[Any]? = nil) -> Bool
    {
        guard let queue = queue else {
            return false
        }
        
        var isSuccess:Bool = false
        queue.inTransaction { (db, rollBack) in
            isSuccess = db.executeUpdate(sql, withArgumentsIn: arguments ?? [])
            isSuccess == false ? rollBack.pointee = true : ()
        }
        
        return isSuccess
    }
}
