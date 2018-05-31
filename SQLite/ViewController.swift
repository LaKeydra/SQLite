//
//  ViewController.swift
//  SQLite
//
//  Created by zhaolin01 on 2018/5/31.
//  Copyright © 2018年 zhaolin01. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let sqliteManager = SQLiteManager.shareInstance
    let tableName: String = "Person"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addAction(_ sender: Any) {
        let dicField: [String: Any] = ["name": "asd", "age": 3, "height": 165]
        self.sqliteManager.insertDataInTable(tableName: tableName, dicField: dicField)
    }
    
    @IBAction func updateAction(_ sender: Any) {
        let dicFields: [String : Any] = ["name": "haha", "age": 90]
        let res = self.sqliteManager.updateData(tableName: tableName, dicFields: dicFields, conditionKey: "age", conditionValue: 2)
        print(res)
    }
    
    @IBAction func searchAction(_ sender: Any) {
        let fieldKeys = ["name","height"]
        let res = self.sqliteManager.selectDataFromTable(tableName: tableName, fieldKeys: fieldKeys)
        print(res)
    }
    
    @IBAction func deteleAction(_ sender: Any) {
        self.sqliteManager.deleteDataFromTable(tableName: tableName, fieldKey: "age", fieldValue: 3)
    }
    
    @IBAction func createTableAction(_ sender: Any) {
        let tableField: [String] = ["name","age","height"]
        let tableProperties: [String] = ["TEXT","INTEGER","REAL"]
        self.sqliteManager.createTable(tableName: tableName, tableFields: tableField, tableFieldTypes: tableProperties)
    }
    
    @IBAction func addTableField(_ sender: Any) {
        self.sqliteManager.changeTable(tableName: tableName, addField: "role", addFieldType: "TEXT")
    }
    
    @IBAction func deleteTable(_ sender: Any) {
        self.sqliteManager.dropTable(tableName: tableName)
    }
    
    
}

