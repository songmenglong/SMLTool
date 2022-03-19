//
//  DataConvertVC.swift
//  SMLTool_Example
//
//  Created by SongMengLong on 2022/3/19.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import SMLTool

class DataConvertVC: UIViewController {
    
    private let cellID = "FunctionListCell"
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        return tableView
    }()
    
    private let dataList: [String] = ["Model转字典", "字典转Model", "JSON转字典", "字典转JSON"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupSubViews()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DataConvertVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath)
        cell.textLabel?.text = self.dataList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let text = self.dataList[indexPath.row]
        switch text {
        case "Model转字典":
            let model = People(name: "张三", sex: 0, age: 30)
            guard let dict = ModelEncoder.encoder(toDictionary: model) else {
                return
            }
            debugPrint("", dict)
            break
        case "字典转Model":
            let dict: [String: Any] = ["sex": 1, "age": 32, "name": "李四"]
            guard let model = try? ModelDecoder.decode(People.self, param: dict) else {
                return
            }
            debugPrint("", model)
            break
        case "JSON转字典":
            let json = "{\"name\":\"刘大\",\"age\":25,\"sex\":1}"
            guard let dict = JSONTool.translationJsonToDic(from: json) else {
                return
            }
            debugPrint("", dict)
            break
        case "字典转JSON":
            let dict: [String: Any] = ["sex": 1, "age": 27, "name": "王五"]
            guard let json = JSONTool.translationObjToJson(from: dict) else {
                return
            }
            debugPrint("", json)
            break
        default:
            break
        }
    }
}

extension DataConvertVC {
    
}

extension DataConvertVC {
    private func setupSubViews() -> Void {
        self.view.addSubview(self.tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: self.tableView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: self.tableView, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: self.tableView, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: self.tableView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 0)
        ])
    }
}


struct People: Codable {
    var name: String?
    var sex: Int?
    var age: Int?
}
