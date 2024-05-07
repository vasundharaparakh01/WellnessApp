//
//  WaterCupSizeViewController.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 29/11/21.
//

import UIKit

protocol WaterCupSizeViewControllerDelegate {
    func refreshWaterData()
}

private struct CustomTitle {
    static let CupSize = "Custom Cup Size In"
}
private struct CustomMsg {
    static let NoData = "No data found"
}

class WaterCupSizeViewController: UIViewController {
    
    var delegate: WaterCupSizeViewControllerDelegate?

    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var viewCustomCupSize: UIView_Designable!
    @IBOutlet var txtCustomCupSize: UITextField!
    @IBOutlet var btnOK: UIBUtton_Designable!
    
    private var waterViewModel = WaterViewModel()
    
    var arrayPicker: [String]?
    var selectedCupSize = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        waterViewModel.waterCupDelegate = self
        waterViewModel.waterCupSizePostDelegate = self
        
        pickerView.delegate = self
        pickerView.dataSource = self

        setupGUI()
        
        getWaterCupData()
    }
    
    func setupGUI() {
        lblTitle.textColor = UIColor.colorSetup()
        viewCustomCupSize.borderColor = UIColor.colorSetup()
        txtCustomCupSize.textColor = UIColor.colorSetup()
        btnOK.backgroundColor = UIColor.colorSetup()
        
//        pickerView.setValue(UIColor.colorSetup(), forKeyPath: "textColor")
        
        viewCustomCupSize.isHidden = true
    }
    
    func getWaterCupData() {
        //api call here
        let connectionStatus = ConnectionManager.shared.hasConnectivity()
        if (connectionStatus == false) {
            DispatchQueue.main.async {
                self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantInternetConnectionStatus.InternetOffline)
                return
            }
        } else {
//            guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
//                self.view.stopActivityIndicator()
//                return
//            }
            
            self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
            waterViewModel.getWaterCupSize()
        }
    }

    //MARK: - Button Func
    @IBAction func btnOK(_ sender: Any) {
        if selectedCupSize != CustomMsg.NoData {
            print("---->\(selectedCupSize)")
            if selectedCupSize == CustomTitle.CupSize {
                postCupSize(cupSize: txtCustomCupSize.text)
            } else {
                postCupSize(cupSize: selectedCupSize)
            }
        }
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    //MARK: - POST Data
    func postCupSize(cupSize: String?) {
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
            let request = WaterCupSizePostRequest(water: cupSize)
            self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
            waterViewModel.postWaterCupSize(waterCupRequest: request, token: token)
        }
    }
}

extension WaterCupSizeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let arr = arrayPicker else { return 0}
        return arr.count
    }
    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        guard let arr = arrayPicker else { return CustomMsg.NoData}
//        return arr[row]
//    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = view as! UILabel?
        if label == nil {
            label = UILabel()
            label?.textAlignment = .center
            label?.textColor = UIColor.colorSetup()
            label?.font = UIFont(name: "Nunito-Bold", size: 30)
        }
        if let arr = arrayPicker {
            label?.text = "\(arr[row]) ml"
        }
        
        return label!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let arr = arrayPicker else { return }
        print(arr[row])
        
        if arr[row] == CustomTitle.CupSize {
            viewCustomCupSize.isHidden = false
        } else {
            viewCustomCupSize.isHidden = true
        }
        selectedCupSize = arr[row]
    }
}

extension WaterCupSizeViewController: UITextFieldDelegate {
    //MARK: - TextField Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        
        if (textField == txtCustomCupSize) {
            if (range.location == 0 && string == " ") {
                return false
            } else if (newString.count > 4) {
                return false
            } else {
                guard CharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string)) else {
                    return false
                }
            }
        }
        return true
    }
}

//MARK: - Get Water Cup
extension WaterCupSizeViewController: WaterCupDelegate {
    func didReceiveWaterCupDataResponse(waterCupDataResponse: WaterCupSizeResponse?) {
        self.view.stopActivityIndicator()
        
        if(waterCupDataResponse?.status != nil && waterCupDataResponse?.status?.lowercased() == ConstantStatusAPI.success) {
//            dump(waterCupDataResponse)
            if let cupSizes = waterCupDataResponse?.sizes {
                arrayPicker = [String]()
                if cupSizes.count > 0 {
                    for item in cupSizes {
                        arrayPicker?.append("\(item.size ?? 999)")
                    }
                    arrayPicker?.append(CustomTitle.CupSize)
                    pickerView.reloadAllComponents()
                    //Default picker value
                    pickerView.selectRow(0, inComponent: 0, animated: true)
                    if let arr = arrayPicker {
                        selectedCupSize = "\(arr[pickerView.selectedRow(inComponent: 0)])"
                    }
                }
            }
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: waterCupDataResponse?.status ?? ConstantStatusAPI.failed)
        }
    }
    
    func didReceiveWaterCupDataError(statusCode: String?) {
        self.view.stopActivityIndicator()
        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
}
//MARK: - POST Water Cup
extension WaterCupSizeViewController: WaterCupPostDelegate {
    func didReceiveWaterCupPostDataResponse(waterCupPostDataResponse: WaterCupSizePostResponse?) {
        self.view.stopActivityIndicator()
        
        if(waterCupPostDataResponse?.status != nil && waterCupPostDataResponse?.status?.lowercased() == ConstantStatusAPI.success) {
//            dump(waterCupPostDataResponse)
            
            openAlertWithButtonFunc(title: ConstantAlertTitle.LuvoAlertTitle,
                                    message: waterCupPostDataResponse?.message ?? "Success",
                                    alertStyle: .alert,
                                    actionTitles: ["OK"],
                                    actionStyles: [.default],
                                    actions: [
                                        { _ in
                                            //Goto previous page
                                            self.dismiss(animated: true) {
                                                //Do something
                                                self.delegate?.refreshWaterData()
                                            }
                                        }
                                    ])
            
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: waterCupPostDataResponse?.message ?? ConstantStatusAPI.failed)
        }
    }
    
    func didReceiveWaterCupPostDataError(statusCode: String?) {
        self.view.stopActivityIndicator()
        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
}
