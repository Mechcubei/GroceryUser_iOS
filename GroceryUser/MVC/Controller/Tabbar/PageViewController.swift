//
//  AboutSelfViewController.swift
//  Flipper App
//
//  Created by Amit Garg on 21/07/20.
//  Copyright © 2020 Amit Garg. All rights reserved.
//

import UIKit

protocol PageViewControllerDelegate {
    func scroll(index:Int)
}


class PageViewController: UIPageViewController {
    
    lazy var pages = [UIViewController]()
    
    var delegateScroll:PageViewControllerDelegate? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate   = self
        let firstVC = pages[0]
        setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
    }
    
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
            let firstViewControllerIndex = pages.firstIndex(of: firstViewController) else {
                return 0
        }
        return firstViewControllerIndex
        
    }
    
    func showIndexedPage(_ targetIndex: Int) -> Void {
        let currentIndex = presentationIndex(for: self)
        guard targetIndex != currentIndex else {
            return
        }
            setViewControllers([pages[targetIndex]], direction: targetIndex < currentIndex ? .reverse : .forward, animated: true) { _ in
        }
    }
    
}

extension PageViewController: UIPageViewControllerDataSource{
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0  else { return nil }
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < pages.count else { return nil }
        
        return pages[nextIndex]
    }
}

extension PageViewController: UIPageViewControllerDelegate {
    
    // MARK: Delegate functions
           func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
               let pageContentViewController = pageViewController.viewControllers![0]
               let ind = self.pages.firstIndex(of: pageContentViewController)!
               delegateScroll?.scroll(index: ind)
           }
    
}
