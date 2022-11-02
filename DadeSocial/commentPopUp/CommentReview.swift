//
//  CommentReview.swift
//  DadeSocial
//
//  Created by MAC-27 on 17/05/21.
//

import UIKit

class CommentReview: UIView, FloatRatingViewDelegate,UITextFieldDelegate {

    @IBOutlet weak var RatingView: FloatRatingView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var updatedLbl: UILabel!
    @IBOutlet weak var commentTxtFeild: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    
    var buttonDoneHandler : (() -> Void)?
    var buttonCancelHandler : (() -> Void)?
    var value = String()
    
    class func intitiateFromNib() -> CommentReview {
        let View1 = UINib.init(nibName: "CommentReview", bundle: nil).instantiate(withOwner: self, options: nil).first as! CommentReview
        return View1
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.topView.layer.cornerRadius = 8
        RatingView.delegate = self
        RatingView.contentMode = UIView.ContentMode.scaleAspectFill
        self.commentTxtFeild.setLeftPaddingPoints(15)
        self.commentTxtFeild.layer.cornerRadius = 15
        self.updatedLbl.text = "0"
//        RatingView.type = .wholeRatings
    }
    
    // MARK: FloatRatingViewDelegate
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float) {
        updatedLbl.text = String(format: "%.1f", self.RatingView.rating)
        value = String(self.RatingView.rating)
    }

    @IBAction func sendBtnAction(_ sender: UIButton) {
        if isBlank(self.commentTxtFeild){
            self.topView.makeToast(message: "Please enter your comment")
        }else if self.value == ""{
            self.topView.makeToast(message: "Please give rating")
        }else{
            Config().AppUserDefaults.set(self.commentTxtFeild.text, forKey: "Comment")
            Config().AppUserDefaults.set(self.value, forKey: "Rating")
            buttonDoneHandler?()
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
    
    @IBAction func cancelBtnAction(_ sender: UIButton) {
        buttonCancelHandler?()
    }
    
}
