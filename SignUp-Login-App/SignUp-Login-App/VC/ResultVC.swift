//
//  ResultVC.swift
//  SignUp-Login-App
//
//  Created by Ivan OSYPENKO on 9/18/18.
//  Copyright © 2018 iosypenk's team. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ResultVC: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCellConfiguration()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Show the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

// - Rx Setups
extension ResultVC {
    func setupCellConfiguration() {
        //1
        TextManager.shared.charArr
            .bind(to: tableView
                .rx //2
                .items(cellIdentifier: "cell",
                       cellType: ResultTableCell.self)) { //3
                        row, char, cell in
                        let str: String = String(TextManager.shared.charArr.value[row])
                        if let count = TextManager.shared.dict[TextManager.shared.charArr.value[row]] {
                            if str == " " {
                                cell.initCell(text: "<\"space\" - \(count) times>")
                            } else {
                                cell.initCell(text: "<\"\(str)\" - \(count) times>")
                            }
                        }
        }
            .disposed(by: disposeBag) //5
    }
}
