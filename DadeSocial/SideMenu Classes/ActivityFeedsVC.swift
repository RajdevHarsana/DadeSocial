//
//  ActivityFeedsVC.swift
//  DadeSocial
//
//  Created by MAC-27 on 07/04/21.
//

import UIKit

class ActivityFeedsVC: UIViewController {
    
    //MARK:- IBoutlates
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var View_Main: UIView!
    @IBOutlet weak var View_Main_TopConstraint: NSLayoutConstraint!
    //MARK:- Variables
    var type = String()
    var TwitterData = [Any]()
    var TwitIds = [String]()
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.contentView.layer.cornerRadius = 15
        self.type = "instagram"
        // Segment Controller
        segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(red: 255/255, green: 102/255, blue: 51/255, alpha: 1.0)], for: UIControl.State.normal)
        segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(red: 255/255, green: 102/255, blue: 51/255, alpha: 1.0)], for: UIControl.State.selected)
        if self.children.count > 0{
            let viewControllers:[UIViewController] = self.children
            for viewContoller in viewControllers{
                viewContoller.willMove(toParent: nil)
                viewContoller.view.removeFromSuperview()
                viewContoller.removeFromParent()
            }
        }
//        self.View_Main_TopConstraint.constant = -90
        let controller4 = storyboard?.instantiateViewController(withIdentifier: "InstagramFeedsVC") as! InstagramFeedsVC
        controller4.type = self.type
        controller4.view.frame = CGRect(x: 0, y: 0, width: self.View_Main.frame.size.width, height: self.View_Main.frame.size.height)
        controller4.willMove(toParent: self)
        self.View_Main.addSubview(controller4.view)
        self.addChild(controller4)
        controller4.didMove(toParent: self)
        // Do any additional setup after loading the view.
    }
    //MARK:- Segment Control Action
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        switch segmentControl.selectedSegmentIndex
        {
        case 0:
            if self.children.count > 0{
                let viewControllers:[UIViewController] = self.children
                for viewContoller in viewControllers{
                    viewContoller.willMove(toParent: nil)
                     viewContoller.view.removeFromSuperview()
                    viewContoller.removeFromParent()
                }
            }
            self.type = "instagram"
//            self.View_Main_TopConstraint.constant = 8
            let controller4 = storyboard?.instantiateViewController(withIdentifier: "InstagramFeedsVC") as! InstagramFeedsVC
            controller4.type = self.type
            controller4.view.frame = CGRect(x: 0, y: 0, width: self.View_Main.frame.size.width, height: self.View_Main.frame.size.height)
            controller4.willMove(toParent: self)
            self.View_Main.addSubview(controller4.view)
            self.addChild(controller4)
            controller4.didMove(toParent: self)
        case 1:
            
            if self.children.count > 0{
                let viewControllers:[UIViewController] = self.children
                for viewContoller in viewControllers{
                    viewContoller.willMove(toParent: nil)
                    viewContoller.view.removeFromSuperview()
                    viewContoller.removeFromParent()
                }
            }
            self.type = "twitter"
//            self.View_Main_TopConstraint.constant = -90
            let controller4 = storyboard?.instantiateViewController(withIdentifier: "TwitterFeedsVC") as! TwitterFeedsVC
            controller4.type = self.type
            controller4.view.frame = CGRect(x: 0, y: 0, width: self.View_Main.frame.size.width, height: self.View_Main.frame.size.height)
            controller4.willMove(toParent: self)
            self.View_Main.addSubview(controller4.view)
            self.addChild(controller4)
            controller4.didMove(toParent: self)
        default:
            break
        }
    }
    //MARK:- Menu Button Action
    @IBAction func menuBtnAction(_ sender: UIButton) {
        self.slideMenuController()?.toggleLeft()
    }
    
}
