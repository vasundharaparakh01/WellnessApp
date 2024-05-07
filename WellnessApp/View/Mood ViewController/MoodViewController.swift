//
//  MoodViewController.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 2022-01-31.
//

import UIKit

fileprivate struct MoodDataModel {
    let mood: String?
    
    init(mood: String) {
        self.mood = mood
    }
}

class MoodViewController: UIViewController {
    
    @IBOutlet var lblHeader: UILabel!
    @IBOutlet var btnClose: UIButton!
    @IBOutlet var tblMain: UITableView!
    @IBOutlet var btnSave: UIBUtton_Designable!
    
    var moodViewModel = MoodViewModel()
    fileprivate var arrayMood: [MoodDataModel]?
    fileprivate var selectedMood: MoodDataModel?
    var selectedIndex: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()

        moodViewModel.delegate = self
        
        setupUI()
        setupTableViewCell()
        setupData()
    }
    
    //MARK: ----Setup UI
    fileprivate func setupUI() {
        btnClose.layer.cornerRadius = btnClose.frame.size.width/2
        btnClose.backgroundColor = UIColor.colorSetup()
        lblHeader.textColor = UIColor.colorSetup()
        btnSave.backgroundColor = UIColor.colorSetup()
    }
    
    //MARK: --- Setup TableViewCell
    fileprivate func setupTableViewCell() {
        tblMain.delegate = self
        tblMain.dataSource = self
        tblMain.register(UINib(nibName: "MoodTableViewCell", bundle: nil), forCellReuseIdentifier: "MoodTableViewCell")
    }
    
    //MARK: -----Setup Data
    fileprivate func setupData() {
        arrayMood = [MoodDataModel]()
        arrayMood?.append(MoodDataModel(mood: "HAPPY"))
        arrayMood?.append(MoodDataModel(mood: "EXCITED"))
        arrayMood?.append(MoodDataModel(mood: "CALM"))
        arrayMood?.append(MoodDataModel(mood: "GRATEFUL"))
        arrayMood?.append(MoodDataModel(mood: "GOOD"))
        arrayMood?.append(MoodDataModel(mood: "SAD"))
        arrayMood?.append(MoodDataModel(mood: "ANXIOUS"))
        arrayMood?.append(MoodDataModel(mood: "STRESSED"))
        arrayMood?.append(MoodDataModel(mood: "TIRED"))
        
        tblMain.reloadData()
    }
    
    //MARK: ---- Button Func
    @IBAction func btnClose(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnSave(_ sender: Any) {
        //api call here
        let connectionStatus = ConnectionManager.shared.hasConnectivity()
        if (connectionStatus == false) {
            DispatchQueue.main.async {
                self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantInternetConnectionStatus.InternetOffline)
                return
            }
        } else {
            guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
                self.view.stopActivityIndicator()
                return
            }
            
            guard let selectedData = selectedMood else { return }
            
            let request = MoodRequest(mood: selectedData.mood)
            self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
            moodViewModel.updateMood(token: token, moodRequest: request)
        }
    }
}

extension MoodViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let arrMood = arrayMood else { return 0}
        return arrMood.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoodTableViewCell", for: indexPath) as! MoodTableViewCell
        
        guard let arrMood = arrayMood else { return cell }
        
        cell.lblMood.text = arrMood[indexPath.row].mood
        
        if selectedIndex == indexPath {
            cell.viewBackground.layer.borderColor = UIColor.colorSetup().cgColor
            cell.viewBackground.backgroundColor = UIColor.white
            cell.imgRadio.image = UIImage.init(named: "radioOn")
            cell.imgRadio.tintColor = UIColor.colorSetup()
        } else {
            cell.viewBackground.layer.borderColor = UIColor.gray.cgColor
            cell.viewBackground.backgroundColor = UIColor(hexString: "#FCFCFD")
            cell.imgRadio.image = UIImage.init(named: "radioOff")
            cell.imgRadio.tintColor = UIColor.gray
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedMood = arrayMood?[indexPath.row]

        selectedIndex = indexPath
        tblMain.reloadData()
    }
}

extension MoodViewController: MoodViewModelDelegate {
    func didReceiveMoodResponse(moodResponse: MoodResponse?) {
        self.view.stopActivityIndicator()
        if(moodResponse?.status != nil && moodResponse?.status?.lowercased() == ConstantStatusAPI.success) {
//            dump(moodResponse)
                        
            if let message = moodResponse?.message {
                popToRootVC(msg: message)
            } else {
                popToRootVC(msg: ConstantStatusAPI.success)
            }
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: moodResponse?.message ?? ConstantStatusAPI.failed)
        }
    }
    
    func didReceiveMoodError(statusCode: String?) {
        self.view.stopActivityIndicator()
        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
    
    fileprivate func popToRootVC(msg: String) {
        openAlertWithButtonFunc(title: ConstantAlertTitle.LuvoAlertTitle,
                                message: msg,
                                alertStyle: .alert, actionTitles: ["OK"],
                                actionStyles: [.default],
                                actions: [
                                    {
                                        _ in
                                        
                                        self.dismiss(animated: true)
                                    }])
    }
}
