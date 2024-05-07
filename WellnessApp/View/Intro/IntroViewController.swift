//
//  IntroViewController.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 09/09/21.
//

import UIKit

class IntroViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnNext(_ sender: Any) {
        let questionVC = ConstantStoryboard.mainStoryboard.instantiateViewController(identifier: "QuestionOneViewController") as! QuestionOneViewController
        self.navigationController?.pushViewController(questionVC, animated: true)
    }
}
