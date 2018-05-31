//
//  SQLiteManager.swift
//  SQLite
//
//  Created by zhaolin01 on 2018/5/31.
//  Copyright © 2018年 zhaolin01. All rights reserved.
//

import Foundation
import FMDB

class SQLiteManager: NSObject {
    static let shareInstance = SQLiteManager()
    var path = NSHomeDirectory()
    var db: FMDatabase = FMDatabase()
    
    override init() {
        super.init()
        db = initDatabase()
    }
    
    //建数据库
    func initDatabase() -> FMDatabase {
        path = path + "/swiftLearn.sqlite"
        print("数据库的路径 = \(path)")
        return FMDatabase(path: path)
    }
    
    //建表 参数：表名、表字段、表字段类型
    func createTable(tableName: String, tableFields: [String], tableFieldTypes: [String]) {
        if db.open() {
            var sql = "CREATE TABLE IF NOT EXISTS " + tableName + " (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,"
            
            for i in 0..<tableFieldTypes.count {
                if i != tableFieldTypes.count - 1 {
                    sql = sql + tableFields[i] + " " + tableFieldTypes[i] + ","
                } else {
                    sql = sql + tableFields[i] + " " + tableFieldTypes[i] + ")"
                }
            }
            
            do{
                try db.executeUpdate(sql, values: nil)
                print("创建表成功，表名为: \(tableName)")
            } catch {
                print(db.lastErrorMessage())
            }
        }
    }
    
    //插入数据 参数：表名，dicField(字典，key: 表属性，value: 值)
    func insertDataInTable(tableName: String, dicField: Dictionary<String,Any>) {
        if db.open() {
            let dicKeys = [String] (dicField.keys)
            let dicValues = [Any] (dicField.values)
            var firstSql = "INSERT INTO " + tableName + "("
            var lastSql = "VALUES ("
            for i in 0..<dicKeys.count {
                if i != dicKeys.count - 1 {
                    firstSql = firstSql + dicKeys[i] + ","
                    lastSql = lastSql + "?,"
                } else {
                    firstSql = firstSql + dicKeys[i] + ")"
                    lastSql = lastSql + "?)"
                }
            }
            
            do{
                try db.executeUpdate(firstSql + lastSql, values: dicValues)
                print("添加数据成功")
            }catch{
                print(db.lastErrorMessage())
            }
        }
    }
    
    //修改数据
    func updateData(tableName: String, dicFields: Dictionary<String,Any>, conditionKey: String, conditionValue: Any) -> Bool {
        var result: Bool = false
        var dicKeys = [String] (dicFields.keys)
        var dicValues = [Any] (dicFields.values)
        dicValues.append(conditionValue)
        var sqlUpdate = "UPDATE " + tableName + " SET "
        for i in 0..<dicFields.count {
            if i != dicKeys.count - 1 {
                sqlUpdate = sqlUpdate + dicKeys[i] + " = ?,"
            } else {
                sqlUpdate = sqlUpdate + dicKeys[i] + " = ?"
            }
        }
        
        sqlUpdate = sqlUpdate + " WHERE " + conditionKey + " = ?"
        if db.open() {
            do{
                try db.executeUpdate(sqlUpdate, values: dicValues)
                print("数据库修改成功")
                result = true
            }catch{
                print(db.lastErrorMessage())
            }
        }
        return result
    }
    
    //查询数据
    func selectDataFromTable(tableName: String, fieldKeys: Array<Any>) -> [Dictionary<String, Any>] {
        var dicFieldsValue = Dictionary<String, Any>()
        var fieldsValue = [Dictionary<String, Any>]()
        let sql = "SELECT * FROM " + tableName
        if db.open() {
            do{
                let rs = try db.executeQuery(sql, values: nil)
                while rs.next() {
                    for i in 0..<fieldKeys.count {
                        dicFieldsValue[fieldKeys[i] as! String] = rs.string(forColumn: fieldKeys[i] as! String)
                    }
                    fieldsValue.append(dicFieldsValue)
                }
            }catch{
                print(db.lastErrorMessage())
            }
        }
        return fieldsValue
    }
    
    //删除数据
    func deleteDataFromTable(tableName: String, fieldKey: String, fieldValue: Any) {
        if db.open() {
            let sql = "DELETE FROM " + tableName + " WHERE " + fieldKey + " = ?"
            do{
                try db.executeUpdate(sql, values: [fieldValue])
                print("删除成功")
            }catch{
                print(db.lastErrorMessage())
            }
        }
    }
    
    //删除表格
    func dropTable(tableName: String) {
        if db.open() {
            let sql = "DROP TABLE " + tableName
            do{
                try db.executeUpdate(sql, values: nil)
                print("删除表格成功")
            }catch{
                print(db.lastErrorMessage())
            }
        }
    }
    
    //新增加表字段
    func changeTable(tableName: String, addField: String, addFieldType: String) {
        if db.open() {
            let sql = "ALTER TABLE " + tableName + " ADD " + addField + " " + addFieldType
            do{
                try db.executeUpdate(sql, values: nil)
            }catch{
                print(db.lastErrorMessage())
            }
        }
    }
    
}
