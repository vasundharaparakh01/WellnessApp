//
//  UpcomingSessionVC.swift
//  Luvo
//
//  Created by BEASiMAC on 10/02/23.
//

import UIKit

class UpcomingSessionVC: UIViewController,UITableViewDelegate,UITableViewDataSource, CoachUpcomingModelDelegate {
    func didReceiveCoachupComingSessionResponse(coachUpcomingSession: CoachResponse?) {
        
    }
    
    func didReceiveCoachupComingSessionError(statusCode: String?) {
        
    }
    
    
    private var sideMenu:CoachSideViewController!
    private var drawerTransition:DrawerTransition!
    
    //Custom Navbar
    @IBOutlet var viewCustomNavBar: UIView!
    @IBOutlet var viewNotificationCount: UIView_Designable!
    @IBOutlet var lblNotificationLabel: UILabel!
    var coachViewUpcomingModel = UpcomingSesionModel()
    @IBOutlet weak var tblViewUpcoming: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomNavBar()
        setupSideMenu()
        coachViewUpcomingModel.upcomingsessiondelegate = self
        guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
            self.view.stopActivityIndicator()
            return
        }
        debugPrint("token--->",token)
        coachViewUpcomingModel.getCoachUpcomingSessionData(token: token, text: "")
        

        // Do any additional setup after loading the view.
    }
    
    func setupSideMenu() {
//        sideMenu = ConstantStoryboard.CoachSideMenu.instantiateViewController(withIdentifier: "CoachSideViewController") as? CoachSideViewController
//        sideMenu.delegate = self
//        drawerTransition = DrawerTransition(target: self, drawer: sideMenu)
    }
    
    func setupCustomNavBar() {
        //Hide navigation bar
        navigationController?.setNavigationBarHidden(true, animated: true)
        viewCustomNavBar.roundCornersBottomLeftRight(radius: 15)
    }
    @IBAction func btnBack(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

       return 5
       // return arrId.count // Here also
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if tableView == tblViewUpcoming,
            let cell = tableView.dequeueReusableCell(withIdentifier: "UpcomingTableViewCell") as? UpcomingTableViewCell {
            
            cell.imgVwicon.layer.cornerRadius = cell.imgVwicon.frame.height/2
           
            
            return cell
        }
        return UITableViewCell()
    }

}
