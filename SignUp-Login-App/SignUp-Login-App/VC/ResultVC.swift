//
//  ResultVC.swift
//  SignUp-Login-App
//
//  Created by Ivan OSYPENKO on 9/18/18.
//  Copyright © 2018 iosypenk's team. All rights reserved.
//

import UIKit

class ResultVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    var textManger : TextManager?
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Show the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let arr = textManger?.charArr {
            return arr.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ResultTableCell
        
        if let data = textManger {
        
            let str : String = String(data.charArr[indexPath.row])
            if let count = data.dict[data.charArr[indexPath.row]] {
                
                if str == " " {
                    cell.initCell(text: "<\"space\" - \(count) times>")
                } else {
                    cell.initCell(text: "<\"\(str)\" - \(count) times>")
                }
            }
        }
        return cell
    }
    
}
