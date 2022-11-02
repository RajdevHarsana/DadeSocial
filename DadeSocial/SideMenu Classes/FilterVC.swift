//
//  FilterVC.swift
//  DadeSocial
//
//  Created by MAC-27 on 07/04/21.
//

import UIKit

protocol MyFilterDataSendingDelegate {
    func sendDataToSearchViewController(DistanceFrom: String, DistanceTo: String, Category_Id: String, Category: String)
}

class FilterVC: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, ToolbarPickerViewDelegate {
    
    //MARK:- IBoutlates
    @IBOutlet weak var rangeSlider: RangeSeekSlider!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var ratingTxtFeild: UITextField!
    @IBOutlet weak var applyBtn: UIButton!
//    @IBOutlet weak var pickerView: UIPickerView!
    //MARK:- Variables
    var delegate: MyFilterDataSendingDelegate? = nil
    var pickerData = [String]()
    var SlideminValue = String()
    var SlidemaxValue = String()
    var Category = String()
    var categories = [Any]()
    var categoryId = String()
    var categoryName = String()
    fileprivate let pickerView = ToolbarPickerView()
//    fileprivate let titles = ["0", "1", "2", "3"]
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.pickerData = ["0","1","2","3","4","5"]
//        self.pickerView.isHidden = true
        self.ratingTxtFeild.setLeftPaddingPoints(15)
        self.view.backgroundColor = UIColor.clear
        self.view.isOpaque = false
        let change = Config().AppUserDefaults.value(forKey: "Change") as? String ?? ""
        if change != "true"{
            self.SlideminValue = "0"
            self.SlidemaxValue = "5"
        }else{
            self.SlideminValue = Config().AppUserDefaults.value(forKey: "MINVALUE") as? String ?? ""
            self.SlidemaxValue = Config().AppUserDefaults.value(forKey: "MAXVALUE") as? String ?? ""
        }
        
        self.rangeSlider.delegate = self
        self.rangeSlider.selectedMinValue = StringToFloat(str: self.SlideminValue)
        self.rangeSlider.selectedMaxValue = StringToFloat(str: self.SlidemaxValue)
        self.rangeSlider.numberFormatter.positiveSuffix = " miles"
//        self.ratingTxtFeild.delegate = self
        self.ratingTxtFeild.text = self.Category
        self.bottomView.layer.cornerRadius = 20
        self.ratingTxtFeild.layer.cornerRadius = 15
        self.applyBtn.layer.cornerRadius = 15
        // Shadow color and radius
        self.applyBtn.layer.shadowColor = UIColor(red: 255/255, green: 102/255, blue: 51/255, alpha: 0.25).cgColor
        self.applyBtn.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        self.applyBtn.layer.shadowOpacity = 1.0
        self.applyBtn.layer.shadowRadius = 5.0
        self.applyBtn.layer.masksToBounds = false
        self.ratingTxtFeild.inputView = self.pickerView
        self.ratingTxtFeild.inputAccessoryView = self.pickerView.toolbar

        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        self.pickerView.toolbarDelegate = self

        self.pickerView.reloadAllComponents()
        // Do any additional setup after loading the view.
    }
    //MARK:- PickerView Delegates & Datasource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.categories.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var dict = [String:Any]()
        dict = DataManager.getVal(self.categories[row]) as! [String:Any]
        let categoryName = DataManager.getVal(dict["name"]) as? String ?? ""
        return categoryName
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var dict = [String:Any]()
        dict = DataManager.getVal(self.categories[row]) as! [String:Any]
        let categoryName = DataManager.getVal(dict["name"]) as? String ?? ""
        self.ratingTxtFeild.text = categoryName
//        self.pickerView.isHidden = true
    }
    //MARK:- ToolbarPickerView Delegates
    func didTapDone() {
        if self.categories.count != 0 {
            let row = self.pickerView.selectedRow(inComponent: 0)
            self.pickerView.selectRow(row, inComponent: 0, animated: false)
            var dict = [String:Any]()
            dict = DataManager.getVal(self.categories[row]) as! [String:Any]
            let categoryName = DataManager.getVal(dict["name"]) as? String ?? ""
            self.ratingTxtFeild.text = categoryName
            self.categoryName = categoryName
            self.categoryId = DataManager.getVal(dict["id"]) as? String ?? ""
            self.ratingTxtFeild.resignFirstResponder()
        }else{
            self.ratingTxtFeild.resignFirstResponder()
        }
    }

    func didTapCancel() {
        self.ratingTxtFeild.text = nil
        self.ratingTxtFeild.resignFirstResponder()
    }
    //MARK:- Cross Button Action
    @IBAction func crossBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    //MARK:- Apply Button Action
    @IBAction func applyBtnAction(_ sender: UIButton) {
        if self.delegate != nil{
            self.delegate?.sendDataToSearchViewController(DistanceFrom: SlideminValue, DistanceTo: SlidemaxValue, Category_Id: self.categoryId, Category: self.categoryName)
            self.dismiss(animated: true, completion: nil)
        }
        self.dismiss(animated: true, completion: nil)
    }
    //MARK:- Textfield Delegates
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
//        self.pickerView.isHidden = false
        return false
    }
}
// MARK: - RangeSeekSliderDelegate
extension FilterVC: RangeSeekSliderDelegate {
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        if slider === rangeSlider {
            //            print("Standard slider updated. Min Value: \(minValue) Max Value: \(maxValue)")
            
            Config().AppUserDefaults.set("true", forKey: "Change")
            let MinValue = rangeSlider.numberFormatter.string(from: minValue as NSNumber)
            let newMin = MinValue?.replacingOccurrences(of: " miles", with: "")
            self.SlideminValue = newMin ?? ""
            let MaxValue = rangeSlider.numberFormatter.string(from: maxValue as NSNumber)
            let newMax = MaxValue?.replacingOccurrences(of: " miles", with: "")
            self.SlidemaxValue = newMax ?? ""
            Config().AppUserDefaults.set(newMin, forKey: "MINVALUE")
            Config().AppUserDefaults.set(newMax, forKey: "MAXVALUE")
            print("Formated updated. Min Value: \(String(describing: MinValue)) Max Value: \(String(describing: MaxValue))")
        }else{
            print("Rajesh")
        }
    }
    func didStartTouches(in slider: RangeSeekSlider) {
        print("did start touches")
    }
    
    func StringToFloat(str:String)->(CGFloat){
        let string = str
        var cgFloat:CGFloat = 0
        if let doubleValue = Double(string){
            cgFloat = CGFloat(doubleValue)
        }
        return cgFloat
    }
}
