//
//  ResultTableCell.swift
//  SignUp-Login-App
//
//  Created by Ivan OSYPENKO on 9/18/18.
//  Copyright © 2018 iosypenk's team. All rights reserved.
//

import UIKit

class ResultTableCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var label: UILabel!
    
    func initCell(text: String) {
        cellView.layer.cornerRadius = 10
         label.text = text
        self.backgroundColor = UIColor(red: 73/255, green: 82/255, blue: 92/255, alpha: 1)
        cellView.backgroundColor = UIColor(red: 59/255, green: 73/255, blue: 91/255, alpha: 1)
    }
}
