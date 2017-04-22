//
//  OnboardingVC.swift
//  Auxcord
//
//  Created by Josica G on 4/22/17.
//  Copyright © 2017 Auxcord. All rights reserved.
//

import UIKit

class OnboardingVC: UIViewController, UIScrollViewDelegate {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //1
        self.scrollView.frame = CGRect(x:0, y:0, width:self.view.frame.width, height:self.view.frame.height)
        let scrollViewWidth:CGFloat = self.scrollView.frame.width
        let scrollViewHeight:CGFloat = self.scrollView.frame.height
        //2
        textView.textAlignment = .center
        textView.text = "An app to visually chronologize and organize travel anecdotes for the modern explorer."
        //3
        let imgOne = UIImageView(frame: CGRect(x:0, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgOne.image = UIImage(named: "Lemonade")
        let imgTwo = UIImageView(frame: CGRect(x:scrollViewWidth, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgTwo.image = UIImage(named: "Desert")
        let imgThree = UIImageView(frame: CGRect(x:scrollViewWidth*2, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgThree.image = UIImage(named: "Helmet")
        let imgFour = UIImageView(frame: CGRect(x:scrollViewWidth*3, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgFour.image = UIImage(named: "Camera")
        
        self.scrollView.addSubview(imgOne)
        self.scrollView.addSubview(imgTwo)
        self.scrollView.addSubview(imgThree)
        self.scrollView.addSubview(imgFour)
        //4
        self.scrollView.contentSize = CGSize(width:self.scrollView.frame.width * 4, height:self.scrollView.frame.height)
        self.scrollView.delegate = self
        self.pageControl.currentPage = 0
        
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(moveToNextPage), userInfo: nil, repeats: true)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView){
        // Test the offset and calculate the current page after scrolling ends
        let pageWidth:CGFloat = scrollView.frame.width
        let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        // Change the indicator
        self.pageControl.currentPage = Int(currentPage);
        // Change the text accordingly
        if Int(currentPage) == 0{
            textView.text = "Constantly fighting with your friends over the aux cord? You need to take several seats and sip some lemonade."
        }else if Int(currentPage) == 1{
            textView.text = "A living time capsule"
        }else if Int(currentPage) == 2{
            textView.text = "Create diary entries, track them on a map, see all your memories laid out."
        }else{
            textView.text = "Register and start cataloging the places you've been."
        }
    }
    
    func moveToNextPage (){
        
        let pageWidth:CGFloat = self.scrollView.frame.width
        let maxWidth:CGFloat = pageWidth * 4
        let contentOffset:CGFloat = self.scrollView.contentOffset.x
        
        var slideToX = contentOffset + pageWidth
        
        if  contentOffset + pageWidth == maxWidth
        {
            slideToX = 0
        }
        self.scrollView.scrollRectToVisible(CGRect(x:slideToX, y:0, width:pageWidth, height:self.scrollView.frame.height), animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
