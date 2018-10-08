//
//  ViewController.swift
//  SwiftSlideShow
//
//  Created by Malek Trabelsi on 11/29/17.
//  Copyright © 2017 Malek Trabelsi. All rights reserved.
//

import UIKit

class SliderViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    let arrSlider = ["Slide 1","Slide 2","Slide 3","Slide 4","Slide 2","Slide 1"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //1
        self.scrollView.frame = CGRect(x:0, y:0, width:self.view.frame.width, height:self.view.frame.height)
        let scrollViewWidth:CGFloat = self.scrollView.frame.width
        let scrollViewHeight:CGFloat = 350
        //self.scrollView.frame.height
    
        self.startButton.layer.cornerRadius = 4.0
        //3
        
        for i in 0...arrSlider.count-1{
            var img = UIImageView()
            if i == 0{
                img = UIImageView(frame: CGRect(x:0, y:0,width:scrollViewWidth, height:scrollViewHeight))
            }
            else{
                img = UIImageView(frame: CGRect(x: scrollViewWidth*CGFloat(i), y:0,width:scrollViewWidth, height:scrollViewHeight))

            }
            img.image = UIImage(named: arrSlider[i])
            self.scrollView.addSubview(img)
        }
        //4
        self.scrollView.contentSize = CGSize(width:self.scrollView.frame.width * 6, height:self.scrollView.frame.height)
        self.scrollView.delegate = self
        self.pageControl.currentPage = 0
        
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(moveToNextPage), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func moveToNextPage (){
        
        let pageWidth:CGFloat = self.scrollView.frame.width
        let maxWidth:CGFloat = pageWidth * CGFloat(arrSlider.count)
        let contentOffset:CGFloat = self.scrollView.contentOffset.x
        
        var slideToX = contentOffset + pageWidth
        
        if  contentOffset + pageWidth == maxWidth
        {
            slideToX = 0
        }
        self.scrollView.scrollRectToVisible(CGRect(x:slideToX, y:0, width:pageWidth, height:self.scrollView.frame.height), animated: true)
    }
}
private typealias ScrollView = SliderViewController
extension ScrollView
{
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView){
        // Test the offset and calculate the current page after scrolling ends
        let pageWidth:CGFloat = scrollView.frame.width
        let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        // Change the indicator
        self.pageControl.currentPage = Int(currentPage);
        // Change the text accordingly
        if Int(currentPage) == 0{
           // textView.text = "Sweettutos.com is your blog of choice for Mobile tutorials"
        }else if Int(currentPage) == 1{
           // textView.text = "I write mobile tutorials mainly targeting iOS"
        }else if Int(currentPage) == 2{
         //   textView.text = "And sometimes I write games tutorials about Unity"
        }else if Int(currentPage) == 6{
          //  textView.text = "Keep visiting sweettutos.com for new coming tutorials, and don't forget to subscribe to be notified by email :)"
            // Show the "Let's Start" button in the last slide (with a fade in animation)
            UIView.animate(withDuration: 1.0, animations: { () -> Void in
                self.startButton.alpha = 1.0
            })
        }
    }
}
