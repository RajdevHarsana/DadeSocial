//
//  ValidationClass.swift
//  Samksa
//
//  Created by Mac Mini on 17/12/14.
//  Copyright (c) 2014 Fullestop. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l <= r
    default:
        return !(rhs < lhs)
    }
}

@available(iOS 13.0, *)
class ValidationClass: NSObject {
    
    func validateUrl (_ stringURL : String) -> Bool {
        
        let urlRegEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[urlRegEx])
        //let urlTest = NSPredicate.predicateWithSubstitutionVariables(predicate)
        
        return predicate.evaluate(with: stringURL)
    }
    
    func isValidUrl(url: String) -> Bool {
        let urlRegEx = "^(https?|http?://)?(www\\.)?([-a-z0-9]{1,63}\\.)*?[a-z0-9][-a-z0-9]{0,61}[a-z0-9]\\.[a-z]{2,6}(/[-\\w@\\+\\.~#\\?&/=%]*)?$"
        let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
        let result = urlTest.evaluate(with: url)
        if result == true{
            return false
        }else if url == ""{
            return false
        }else{
            return true
        }
        
    }
    
    func isBlank (_ textfield:UITextField) -> Bool {
        
        let thetext = textfield.text
        let trimmedString = thetext!.trimmingCharacters(in: CharacterSet.whitespaces)
        
        if trimmedString.isEmpty {
            return true
        }
        return false
    }
    
    func isTextViewBlank(_ textview:UITextView) -> Bool {
        
        let thetext = textview.text
        let trimmedString = thetext!.trimmingCharacters(in: CharacterSet.whitespaces)
        
        if trimmedString.isEmpty {
            return true
        }
        return false
    }
    
    func isValidEmail(_ EmailStr:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let range = EmailStr.range(of: emailRegEx, options:.regularExpression)
        let result = range != nil ? true : false
        return !result
    }
    
    func isValidPWD(_ PwdStr:String) -> Bool {
        
        let PwdRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{10,}"
        let range = PwdStr.range(of: PwdRegEx, options:.regularExpression)
        let result = range != nil ? true : false
        return !result
    }
//    func ValidateLoginForm(_ loginVCValidateObj:LoginVC) -> Bool {
//        if isBlank(loginVCValidateObj.EmailTxtField) {
//            if loginVCValidateObj.type == "email"{
//                loginVCValidateObj.view.makeToast(message: "Please enter your email address.")
//                loginVCValidateObj.view.endEditing(true)
//            }else{
//                loginVCValidateObj.view.makeToast(message: "Please enter phone number.")
//                loginVCValidateObj.view.endEditing(true)
//            }
//            return false
//        }else if isBlank(loginVCValidateObj.PasswordTxtField) {
//            loginVCValidateObj.view.makeToast(message: "Please enter your password.")
//            loginVCValidateObj.view.endEditing(true)
//            return false
//        }else{
//            return true
//        }
//    }
    
//    func ValidateAddCardForm(_ loginVCValidateObj:AddCardVC) -> Bool {
//        if isBlank(loginVCValidateObj.nameonCardtextField) {
//            loginVCValidateObj.view.makeToast(message: "Please enter name on your card.")
//            loginVCValidateObj.view.endEditing(true)
//            return false
//        }else if isBlank(loginVCValidateObj.cardNumnerTxt) {
//            loginVCValidateObj.view.makeToast(message: "Please enter card number.")
//            loginVCValidateObj.view.endEditing(true)
//            return false
//        }
//        else if isBlank(loginVCValidateObj.monthTxt) {
//            loginVCValidateObj.view.makeToast(message: "Please enter month.")
//            loginVCValidateObj.view.endEditing(true)
//            return false
//        }else if isBlank(loginVCValidateObj.yearTxt) {
//            loginVCValidateObj.view.makeToast(message: "Please enter year.")
//            loginVCValidateObj.view.endEditing(true)
//            return false
//        }else if isBlank(loginVCValidateObj.CVVTxt) {
//            loginVCValidateObj.view.makeToast(message: "Please enter cvv.")
//            loginVCValidateObj.view.endEditing(true)
//            return false
//        }
//        else{
//            return true
//        }
//    }
    
    func ValidateContactUs(_ loginVCValidateObj:ContactUsVC) -> Bool {
        if isBlank(loginVCValidateObj.nameTxtFeild) {
            loginVCValidateObj.view.makeToast(message: "Please enter your name.")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if isBlank(loginVCValidateObj.emailTxtFeild) {
            loginVCValidateObj.view.makeToast(message: "Please enter email.")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if isValidEmail(loginVCValidateObj.emailTxtFeild.text!) {
            loginVCValidateObj.view.makeToast(message: "This is not correct email address")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if isTextViewBlank(loginVCValidateObj.discriptionTxtView) {
            loginVCValidateObj.view.makeToast(message: "Please enter your message.")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else{
            return true
        }
    }
    
    
    func ValidateUserSignUpForm(_ loginVCValidateObj:SignUpVC) -> Bool {
        if isBlank(loginVCValidateObj.firstNameTxtField) {
            loginVCValidateObj.view.makeToast(message: "Please enter your first name.")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if loginVCValidateObj.firstNameTxtField.text!.count < 3 || loginVCValidateObj.firstNameTxtField.text!.count > 30 {
            loginVCValidateObj.view.makeToast(message: "First name should be 3-30 character")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if isBlank(loginVCValidateObj.lastNameTxtField) {
            loginVCValidateObj.view.makeToast(message: "Please enter your last name.")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if loginVCValidateObj.lastNameTxtField.text!.count < 3 || loginVCValidateObj.lastNameTxtField.text!.count > 30 {
            loginVCValidateObj.view.makeToast(message: "Last name should be 3-30 character")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if isBlank(loginVCValidateObj.emailTxtField) {
            loginVCValidateObj.view.makeToast(message: "Please enter your email.")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if isValidEmail(loginVCValidateObj.emailTxtField.text!) {
            loginVCValidateObj.view.makeToast(message: "This is not correct email address")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if isBlank(loginVCValidateObj.ageTxtField) {
            loginVCValidateObj.view.makeToast(message: "Please enter your age.")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if isBlank(loginVCValidateObj.genderTxtFeild) {
            loginVCValidateObj.view.makeToast(message: "Please enter your gender.")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if isBlank(loginVCValidateObj.mobileNumTxtField) {
            loginVCValidateObj.view.makeToast(message: "Please enter your phone number.")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if loginVCValidateObj.mobileNumTxtField.text!.count < 7 || loginVCValidateObj.mobileNumTxtField.text!.count > 15 {
            loginVCValidateObj.view.makeToast(message: "Phone number should be 7-15 digits")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if isBlank(loginVCValidateObj.passwordTxtField) {
            loginVCValidateObj.view.makeToast(message: "Please enter your password.")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if loginVCValidateObj.passwordTxtField.text!.count < 7 || loginVCValidateObj.passwordTxtField.text!.count > 16 {
            loginVCValidateObj.view.makeToast(message: "Your password should be 7-16 characters.")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if isBlank(loginVCValidateObj.confirmPasswordTxtField) {
            loginVCValidateObj.view.makeToast(message: "Please enter your confirm password.")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if loginVCValidateObj.confirmPasswordTxtField.text!.count < 7 || loginVCValidateObj.confirmPasswordTxtField.text!.count > 16 {
            loginVCValidateObj.view.makeToast(message: "Confirm Password should be 7-16 character")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if loginVCValidateObj.passwordTxtField.text! != loginVCValidateObj.confirmPasswordTxtField.text!{
            loginVCValidateObj.view.makeToast(message: "Password and confirm password does not match.")
            return false
        }else if !loginVCValidateObj.accepte{
            loginVCValidateObj.view.makeToast(message: "Please accept the Terms & Condition.")
            return false
        }else{
            return true
        }
    }
    
    
    func ValidateUserRegisterBusiness(_ loginVCValidateObj:RegisterBusinessVC) -> Bool {
        if isBlank(loginVCValidateObj.nameTxtFeild) {
            loginVCValidateObj.view.makeToast(message: "Please enter your business name.")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if loginVCValidateObj.nameTxtFeild.text!.count < 3 || loginVCValidateObj.nameTxtFeild.text!.count > 55 {
            loginVCValidateObj.view.makeToast(message: "Business name should be 3-55 character")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if isBlank(loginVCValidateObj.emailTxtFeild) {
            loginVCValidateObj.view.makeToast(message: "Please enter your email.")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if isValidEmail(loginVCValidateObj.emailTxtFeild.text!) {
            loginVCValidateObj.view.makeToast(message: "This is not correct email address")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if isBlank(loginVCValidateObj.phoneTxtFeild) {
            loginVCValidateObj.view.makeToast(message: "Please enter your phone number.")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if loginVCValidateObj.phoneTxtFeild.text!.count < 7 || loginVCValidateObj.phoneTxtFeild.text!.count > 15 {
            loginVCValidateObj.view.makeToast(message: "Phone number should be 7-15 digits")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if isBlank(loginVCValidateObj.categaryTxtFeild){
            loginVCValidateObj.view.makeToast(message: "Please enter your category.")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if isBlank(loginVCValidateObj.addressTxtFeild){
            loginVCValidateObj.view.makeToast(message: "Please enter your address.")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if isValidUrl(url: loginVCValidateObj.webSiteTxtFeild.text!) {
            loginVCValidateObj.view.makeToast(message: "This is not correct web address")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if isValidUrl(url: loginVCValidateObj.twitterProfileTxtFeild.text!) {
            loginVCValidateObj.view.makeToast(message: "This is not correct twitter address")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if isValidUrl(url: loginVCValidateObj.fbProfileTxtFeild.text!) {
            loginVCValidateObj.view.makeToast(message: "This is not correct facebook address")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if isValidUrl(url: loginVCValidateObj.instaProfileTxtFeild.text!) {
            loginVCValidateObj.view.makeToast(message: "This is not correct instagram address")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else if isTextViewBlank(loginVCValidateObj.discriptionTxtView){
            loginVCValidateObj.view.makeToast(message: "Please enter your business discription.")
            loginVCValidateObj.view.endEditing(true)
            return false
        }else{
            return true
        }
    }
    
    
//        func ReSet_Password_Form(_ loginVCValidateObj:ResetPasswordVC) -> Bool {
//            if isBlank(loginVCValidateObj.PasswordTxtField) {
//            loginVCValidateObj.view.makeToast(message: "Please enter your new password.")
//            loginVCValidateObj.view.endEditing(true)
//            return false
//        }else if loginVCValidateObj.PasswordTxtField.text!.count < 7 || loginVCValidateObj.ConfirmPasswordTxtField.text!.count > 16 {
//            loginVCValidateObj.view.makeToast(message: "New Password should be 7-16 character")
//            loginVCValidateObj.view.endEditing(true)
//            return false
//        }else if isBlank(loginVCValidateObj.ConfirmPasswordTxtField) {
//            loginVCValidateObj.view.makeToast(message: "Please enter your confirm password.")
//            loginVCValidateObj.view.endEditing(true)
//            return false
//        }else if loginVCValidateObj.ConfirmPasswordTxtField.text!.count < 7 || loginVCValidateObj.ConfirmPasswordTxtField.text!.count > 16 {
//            loginVCValidateObj.view.makeToast(message: "Confirm Pass should be 7-16 character")
//            loginVCValidateObj.view.endEditing(true)
//            return false
//        }else if loginVCValidateObj.PasswordTxtField.text! != loginVCValidateObj.ConfirmPasswordTxtField.text!{
//            loginVCValidateObj.view.makeToast(message: "Your password and confirm password does not match.")
//            return false
//        }else{
//            return true
//        }
//    }
//    func Profile_update_Form(_ loginVCValidateObj:ProfileVC) -> Bool {
//        if loginVCValidateObj.ProfileImgView.image == nil{
//            loginVCValidateObj.view.makeToast(message: "Please select profile photo.")
//            loginVCValidateObj.view.endEditing(true)
//            return false
//        }else if loginVCValidateObj.UploadvideoArray.count == 0 {
//            loginVCValidateObj.view.makeToast(message: "Please select video for profile.")
//            loginVCValidateObj.view.endEditing(true)
//            return false
//        }else if loginVCValidateObj.UploadimageArray.count == 0{
//            loginVCValidateObj.view.makeToast(message: "Please select images for profile.")
//            loginVCValidateObj.view.endEditing(true)
//            return false
//        }else if isBlank(loginVCValidateObj.FullNameTxtField) {
//            loginVCValidateObj.view.makeToast(message: "Please enter full name.")
//            loginVCValidateObj.view.endEditing(true)
//            return false
//        }else if isBlank(loginVCValidateObj.DOBtxtField) {
//            loginVCValidateObj.view.makeToast(message: "Please enter your DOB first.")
//            loginVCValidateObj.view.endEditing(true)
//            return false
//        }else if isBlank(loginVCValidateObj.CountryTxtField) {
//            loginVCValidateObj.view.makeToast(message: "Please enter your country.")
//            loginVCValidateObj.view.endEditing(true)
//            return false
////        }else if isBlank(loginVCValidateObj.StateTxtField) {
////            loginVCValidateObj.view.makeToast(message: "Please enter your state.")
////            loginVCValidateObj.view.endEditing(true)
////            return false
////        }else if isBlank(loginVCValidateObj.CityTxtField) {
////            loginVCValidateObj.view.makeToast(message: "Please enter your city.")
////            loginVCValidateObj.view.endEditing(true)
////            return false
//        }else if isBlank(loginVCValidateObj.EducationSearchTxtField) {
//            loginVCValidateObj.view.makeToast(message: "Please enter your education detail.")
//            loginVCValidateObj.view.endEditing(true)
//            return false
//        }else if isBlank(loginVCValidateObj.EthnicityTxtField) {
//            loginVCValidateObj.view.makeToast(message: "Please enter your ethnicity detail.")
//            loginVCValidateObj.view.endEditing(true)
//            return false
//        }
//        else if isBlank(loginVCValidateObj.ReligionTxtField) {
//            loginVCValidateObj.view.makeToast(message: "Please enter your religion.")
//            loginVCValidateObj.view.endEditing(true)
//            return false
//        }
//        else if isBlank(loginVCValidateObj.MatrialStatusTxtField) {
//            loginVCValidateObj.view.makeToast(message: "Please enter your matrial status.")
//            loginVCValidateObj.view.endEditing(true)
//            return false
//        }else if isBlank(loginVCValidateObj.BuildTxtField) {
//            loginVCValidateObj.view.makeToast(message: "Please set your build.")
//            loginVCValidateObj.view.endEditing(true)
//            return false
//        }else if loginVCValidateObj.AboutTxtView.text == ""{
//            loginVCValidateObj.view.makeToast(message: "Please enter about your self.")
//            loginVCValidateObj.view.endEditing(true)
//            return false
//        }else{
//            return true
//        }
//    }
//    func ValidateChangePasswordForm(_ loginVCValidateObj:ChangePasswordVC) -> Bool {
//        if isBlank(loginVCValidateObj.OldPasswordTxtField) {
//            loginVCValidateObj.view.makeToast(message: "Please enter your old password.")
//            loginVCValidateObj.view.endEditing(true)
//            return false
//        }else if isBlank(loginVCValidateObj.NewPasswordTxtField) {
//            loginVCValidateObj.view.makeToast(message: "Please enter your new password.")
//            loginVCValidateObj.view.endEditing(true)
//            return false
//        }else if isBlank(loginVCValidateObj.ConfirmPasswordTxtField) {
//            loginVCValidateObj.view.makeToast(message: "Please enter your confirm password.")
//            loginVCValidateObj.view.endEditing(true)
//            return false
//        }else if loginVCValidateObj.NewPasswordTxtField.text! != loginVCValidateObj.ConfirmPasswordTxtField.text!{
//            loginVCValidateObj.view.makeToast(message: "Your password and confirm password does not match.")
//            return false
//        }else{
//            return true
//        }
//    }
}


