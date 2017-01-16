//
//  OnboardingViewController.swift
//  Falcon
//
//  Created by Tayson on 2016-01-06.
//  Copyright © 2016 Tayson Nguyen. All rights reserved.
//

import Foundation

open class OnboardingViewController: UIViewController {
    
    @IBOutlet open weak var scrollView: UIScrollView!
    @IBOutlet open weak var pageControl: UIPageControl!
    
    open var pages: [OnboardingPageView] = []
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public init () {
        let bundle = Bundle(for: type(of: self))
        super.init(nibName: "OnboardingViewController", bundle: bundle)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        for page in pages {
            scrollView.addSubview(page)
        }
        
        pageControl.numberOfPages = pages.count
    }
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        for page in pages {
            let pageIndex = CGFloat(pages.index(of: page)!)
            page.frame = CGRect(x: scrollView.frame.width * pageIndex, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height)
        }
        
        self.scrollView.contentSize = CGSize(width: scrollView.frame.size.width * CGFloat(pages.count), height: scrollView.frame.size.height);
    }
}

extension OnboardingViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1
        pageControl.currentPage = Int(page)
    }
}
