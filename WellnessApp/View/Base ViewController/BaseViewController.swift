//
//  BaseViewController.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 02/09/21.
//

import UIKit

class BaseViewController: UIViewController {
    
    let stackView = UIStackView()
    let button1 = UIButton()
    let button2 = UIButton()
    let button3 = UIButton()
    let button4 = UIButton()
    let button5 = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SetupBottomBar()
        SetupFloatingButton(imageName: "home", height: 80, width: 80, cornerRadius: 40, bottomPadding: 30) //-30
        
    }
    
    //MARK: - Setup Bottom Bar
    private func SetupBottomBar() {
        //Stack View
        stackView.axis = NSLayoutConstraint.Axis.horizontal
        stackView.distribution = UIStackView.Distribution.fillEqually
        stackView.alignment = UIStackView.Alignment.fill
        //        stackView.spacing = 16.0
        self.view.addSubview(stackView)
        
        //Constraints
        let leadingConstraint = stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let trailingConstraint = stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let bottomConstraint = stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        //        let verticalConstraint = newView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        //        let widthConstraint = stackView.widthAnchor.constraint(equalToConstant: view.frame.width)
        let heightConstraint = stackView.heightAnchor.constraint(equalToConstant: 75)
        view.addConstraints([leadingConstraint, trailingConstraint, bottomConstraint, heightConstraint])
        
        
        //Button
//        button1.setTitle("btn 1", for: .normal)
//        button1.backgroundColor = UIColor.red
        button1.setImage(UIImage.init(named: "meditation"), for: .normal)
//        button1.contentMode = .scaleAspectFit
        button1.translatesAutoresizingMaskIntoConstraints = false
        button1.addTarget(self, action: #selector(btnMeditation), for: .touchUpInside)
        
        button2.setTitle("btn 2", for: .normal)
        button2.backgroundColor = UIColor.green
        button2.translatesAutoresizingMaskIntoConstraints = false
        
        let viewBlank = UIView()
        viewBlank.backgroundColor = .white
        viewBlank.translatesAutoresizingMaskIntoConstraints = false
        
        button4.setTitle("btn 4", for: .normal)
        button4.backgroundColor = UIColor.yellow
        button4.translatesAutoresizingMaskIntoConstraints = false
        
        button5.setTitle("btn 5", for: .normal)
        button5.backgroundColor = UIColor.purple
        button5.translatesAutoresizingMaskIntoConstraints = false
        
        
        stackView.addArrangedSubview(button1)
        stackView.addArrangedSubview(button2)
        stackView.addArrangedSubview(viewBlank)
        stackView.addArrangedSubview(button4)
        stackView.addArrangedSubview(button5)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    //MARK: - Floating Button
    private func SetupFloatingButton(imageName: String, height: CGFloat, width: CGFloat, cornerRadius: CGFloat, bottomPadding: CGFloat) {
        //Floating Button
        button3.backgroundColor = .red
        button3.setImage(UIImage.init(named: imageName), for: .normal)
        button3.layer.cornerRadius = cornerRadius
        button3.addTarget(self, action: #selector(btnMeditation), for: .touchUpInside)
        self.view.addSubview(button3)
        button3.translatesAutoresizingMaskIntoConstraints = false
        
        button3.widthAnchor.constraint(equalToConstant: width).isActive = true
        button3.heightAnchor.constraint(equalToConstant: height).isActive = true
        button3.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        button3.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: bottomPadding).isActive = true
        button3.bottomAnchor.constraint(equalTo: self.stackView.layoutMarginsGuide.topAnchor, constant: bottomPadding).isActive = true
    }
    
    //MARK: - Button Func
    @objc func btnMeditation() {
        debugPrint("Hello")
        //change btn image accordingly. If not working then you need to call the extension functions from the viewController.
    }

}

extension BaseViewController {
    //Internal Func
    func baseVCSelectedMeditation() {
        debugPrint("Hello")
        
    }
    func baseVCSelectedExercise() {
        debugPrint("Hello")
        
    }
    func baseVCSelectedHome() {
        button3.backgroundColor = .green
    }
    func baseVCSelectedWaterIntake() {
        
    }
    func baseVCSelectedSleep() {
        
    }
}
