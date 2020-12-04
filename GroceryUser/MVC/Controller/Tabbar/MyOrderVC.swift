//
//  MyOrderVC.swift
//  GroceryUser
//
//  Created by osx on 29/07/20.
//  Copyright © 2020 osx. All rights reserved.
//

import UIKit

class MyOrderVC: UIViewController {
    
    //MARK:- OUTLETS
    @IBOutlet var containerView: UIView!
    @IBOutlet var viewToBeReviwed: UIView!
    @IBOutlet var viewReview: UIView!
    
    //MARK:- SET UP PAGEVIEW CONTROLLER
    lazy var aboutSelfPVC: PageViewController = {
        let viewController = PageViewController(transitionStyle:
            UIPageViewController.TransitionStyle.scroll, navigationOrientation:
            UIPageViewController.NavigationOrientation.horizontal, options: nil)
        
        viewController.pages = {
            return [
                getViewController(withIdentifier: "ToBeReviewedVC"),
                getViewController(withIdentifier: "ReviewedVC")
            ]
        }()
        
        func getViewController(withIdentifier identifier: String) -> UIViewController{
            return UIStoryboard(name: "Tabbar", bundle: nil).instantiateViewController(withIdentifier: identifier)
        }
        return viewController
    }()
    
    //MARK:- LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.add(asChildViewController: self.aboutSelfPVC)
        self.aboutSelfPVC.delegateScroll = self
        
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
    
    //MARK:- ACTION BUITTON
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- PAGEVIEW CONTROLLER
extension MyOrderVC: PageViewControllerDelegate {
    func scroll(index: Int) {
        if index == 0 {
            viewToBeReviwed.backgroundColor = ENUMCOLOUR.themeColour.getColour()
            viewReview.backgroundColor = UIColor.clear
        } else {
            viewToBeReviwed.backgroundColor = UIColor.clear
            viewReview.backgroundColor = ENUMCOLOUR.themeColour.getColour()
        }
    }
}
