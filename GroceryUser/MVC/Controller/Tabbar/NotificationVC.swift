//
//  NotificationVC.swift
//  GroceryUser
//
//  Created by osx on 29/07/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit

class NotificationVC: UIViewController {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var viewAlert: UIView!
    @IBOutlet var viewOffers: UIView!
    
    lazy var aboutSelfPVC: PageViewController = {
        let viewController = PageViewController(transitionStyle:
            UIPageViewController.TransitionStyle.scroll, navigationOrientation:
            UIPageViewController.NavigationOrientation.horizontal, options: nil)
        
        viewController.pages = {
            return [
                getViewController(withIdentifier: "AlertVC"),
                getViewController(withIdentifier: "OffersVC")
            ]
        }()
        
        func getViewController(withIdentifier identifier: String) -> UIViewController{
            return UIStoryboard(name: "Tabbar", bundle: nil).instantiateViewController(withIdentifier: identifier)
        }
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.add(asChildViewController: self.aboutSelfPVC)
        self.aboutSelfPVC.delegateScroll = self
        self.tabBarController?.tabBar.isHidden = true
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChild(viewController)
        
        // Add Child View as Subview
        containerView.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParent: self)
    }
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnAlert(_ sender: Any) {
        aboutSelfPVC.showIndexedPage(0)
        viewAlert.backgroundColor = ENUMCOLOUR.themeColour.getColour()
        viewOffers.backgroundColor = UIColor.clear
    }
    @IBAction func btnOffers(_ sender: Any) {
        aboutSelfPVC.showIndexedPage(1)
        viewAlert.backgroundColor = UIColor.clear
        viewOffers.backgroundColor = ENUMCOLOUR.themeColour.getColour()
    }
}

//MARK:- PAGEVIEW CONTROLLER
extension NotificationVC: PageViewControllerDelegate {
    func scroll(index: Int) {
        if index == 0 {
            viewAlert.backgroundColor = ENUMCOLOUR.themeColour.getColour()
            viewOffers.backgroundColor = UIColor.clear
        } else {
            viewAlert.backgroundColor = UIColor.clear
            viewOffers.backgroundColor = ENUMCOLOUR.themeColour.getColour()
        }
    }
}
