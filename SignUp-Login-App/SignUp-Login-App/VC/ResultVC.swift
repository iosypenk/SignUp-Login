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

extension ResultVC {
    func setupCellConfiguration() {
        TextManager.shared.charArr
            .bind(to: tableView
                .rx
                .items(cellIdentifier: ResultTableCell.cellIdentifier,
                       cellType: ResultTableCell.self)) {
                        row, char, cell in
                        guard let count = TextManager.shared.dict[char] else { return }
                        
                        if char == " " {
                            cell.initCell(text: "<\"space\" - \(count) times>")
                        } else {
                            cell.initCell(text: "<\"\(char)\" - \(count) times>")
                        }
                        
        }.disposed(by: disposeBag)
    }
}
