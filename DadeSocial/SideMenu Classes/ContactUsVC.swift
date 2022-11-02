//
//  ContactUsVC.swift
//  DadeSocial
//
//  Created by MAC-27 on 07/04/21.
//

import UIKit

class ContactUsVC: UIViewController,UITextViewDelegate {
    
    //MARK:- IBoutlates
    @IBOutlet weak var nameTxtFeild: UITextField!
    @IBOutlet weak var emailTxtFeild: UITextField!
    @IBOutlet weak var discriptionTxtView: UITextView!
    @IBOutlet weak var submitBtn: UIButton!
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.nameTxtFeild.layer.cornerRadius = 15
        self.emailTxtFeild.layer.cornerRadius = 15
        self.discriptionTxtView.layer.cornerRadius = 15
        self.nameTxtFeild.setLeftPaddingPoints(15)
        self.emailTxtFeild.setLeftPaddingPoints(15)
        self.discriptionTxtView.leftSpace(10)
        self.submitBtn.layer.cornerRadius = 15
        // Shadow color and radius
        self.submitBtn.layer.shadowColor = UIColor(red: 255/255, green: 102/255, blue: 51/255, alpha: 0.25).cgColor
        self.submitBtn.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        self.submitBtn.layer.shadowOpacity = 1.0
        self.submitBtn.layer.shadowRadius = 5.0
        self.submitBtn.layer.masksToBounds = false
        discriptionTxtView.text = "Message"
        self.discriptionTxtView.delegate = self
        discriptionTxtView.textColor = UIColor.lightGray
        discriptionTxtView.selectedTextRange = discriptionTxtView.textRange(from: discriptionTxtView.beginningOfDocument, to: discriptionTxtView.beginningOfDocument)
        // Do any additional setup after loading the view.
    }
    //MARK:- Menu Button Action
    @IBAction func menuBtnAction(_ sender: UIButton) {
        self.slideMenuController()?.toggleLeft()
    }
    //MARK:- Text View Datasource
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 250    // 10 Limit Value
    }
    //MARK:- Text View Delegates
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Message" {
            discriptionTxtView.text = ""
            discriptionTxtView.textColor = UIColor.black
        }
        textView.becomeFirstResponder()
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            discriptionTxtView.text = "Message"
            discriptionTxtView.textColor = UIColor.lightGray
        }
        textView.resignFirstResponder()
    }
    //MARK:- Submit Button Action
    @IBAction func submitBtnAction(_ sender: UIButton) {
        
        if self.discriptionTxtView.text == "Message" {
            self.view.makeToast(message: "Please enter your message.")
        }else if ValidationClass().ValidateContactUs(self){
//            self.pleaseWait()
            self.showSpinner(onView: self.view)
            let dict = NSMutableDictionary()
            dict.setValue(DataManager.getVal(nameTxtFeild.text!), forKey: "name")
            dict.setValue(DataManager.getVal(emailTxtFeild.text!), forKey: "email")
            dict.setValue(DataManager.getVal(discriptionTxtView.text!), forKey: "message")
            
            let methodName = "ContactUs"
            
            DataManager.getAPIResponse(dict, methodName: methodName, methodType: "POST"){(responseData,error)-> Void in
                
                let status = DataManager.getVal(responseData?["status"]) as? String ?? ""
                let message = DataManager.getVal(responseData?["message"]) as? String ?? ""
                if status == "1"{
                    self.view.makeToast(message: message)
                    self.nameTxtFeild.text = ""
                    self.emailTxtFeild.text = ""
                    self.discriptionTxtView.text = ""
                }else{
                    self.view.makeToast(message: message)
                }
//                self.clearAllNotice()
                self.removeSpinner()
            }
        }
    }
    
}
