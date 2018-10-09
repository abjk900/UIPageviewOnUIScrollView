//
//  ViewController.swift
//  PageViewController
//
//  Created by NIA on 2018. 10. 4..
//  Copyright © 2018년 NIA. All rights reserved.
//

/*
 UIPageController 와 UIScrollView 를 합해 하나의 뷰를 만들었습니다.
 두 파트로 나누어 설명이 되어 있습니다.
 PART1. pagenation 만들기
 PART2. 전체 scrollView 만들기, pagenation 추가하기
 */

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    
    //PART2 - 1. 전체 ScrollView 와 그 안에 들어간 ContentView 선언
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    //PART1 - 1. pagenationScrollView and PageControl 선언 + pagenationView 선언(pagenationScrollView, PageControl 을 넣기 위한)
    let pagenationView = UIView()
    let pagenationScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    let pageController: UIPageControl = {
       let paegeNation = UIPageControl()
        paegeNation.pageIndicatorTintColor = .lightGray
        return paegeNation
    }()
    
    //PART1 - 2. slide nib 제작 및 array 화
    var slides: [Slide] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pagenationScrollView.delegate = self
        view.backgroundColor = .black
        
        slides = createSlides()
        setupSlideOnScrollView(slides: slides)
        setupScrollView()
        setupPageView()
        setupContentView()
    }
    
    //PART1 - 2. slide nib 제작 및 array 화
    func createSlides() -> [Slide]{
        let slide1: Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide1.imgeView.image = UIImage(named: "Unknown.jpeg")
        slide1.labelTitle.text = "햄버그"
        
        let slide2: Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide2.imgeView.image = UIImage(named: "Unknown-1.jpeg")
        slide2.labelTitle.text = "떡볶이"
        
        let slide3: Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide3.imgeView.image = UIImage(named: "Unknown-2.jpeg")
        slide3.labelTitle.text = "연어"
        
        let slide4: Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide4.imgeView.image = UIImage(named: "Unknown-3.jpeg")
        slide4.labelTitle.text = "김치전"
        
        return [slide1, slide2, slide3, slide4]
    }
    
    //PART1 - 3. scrollView에 slides 삽입. *pagenationScrollView 는 자신을 덥고 있는 뷰에 맞춰 frame을 설정해야 함.
    func setupSlideOnScrollView(slides: [Slide]){
        pagenationScrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: pagenationView.frame.height)
        //pagenationScrollView.contentSize 의 너비는 뷰의 너비 * 스라이스의 갯수 이다.
        pagenationScrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: pagenationView.frame.height)
        pagenationScrollView.isPagingEnabled = true
        
        for i in 0..<slides.count {
            //각 slides 의 x 좌표는 순서대로 뷰의 너비만큼 이동한다.
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: pagenationView.frame.height)
            //순서대로 pagenation 에 추가된다.
            pagenationScrollView.addSubview(slides[i])
        }
    }
    
    //PART1 - 4. scroll 이 돌아갈때 pagenation 이 패스되며 돌아가게
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
        pageController.currentPage = Int(pageIndex)
    }
    
    //PART1 - 5. pagenationView에 pagenationScrollView, pageController 추가
    func setupPageView(){
        pagenationView.addSubview(pagenationScrollView)
        pagenationView.addSubview(pageController)
        
        pagenationScrollView.anchor(top: pagenationView.topAnchor, left: pagenationView.leftAnchor, bottom: pagenationView.bottomAnchor, right: pagenationView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        pagenationScrollView.centerXAnchor.constraint(equalTo: pagenationView.centerXAnchor)
        pageController.anchor(top: pagenationScrollView.bottomAnchor, left: pagenationScrollView.leftAnchor, bottom: nil, right: pagenationScrollView.rightAnchor, paddingTop: -40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
        pagenationScrollView.centerXAnchor.constraint(equalTo: pagenationView.centerXAnchor)
        
        pageController.numberOfPages = slides.count
        pageController.currentPage = 0
        pagenationView.bringSubviewToFront(pageController)
    }
    
    //PART2 - 2. 전체 ScrollView 와 ContentView 로드
    func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        //x,w,t,b
        scrollView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        scrollView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        //x,w,t,b
        contentView.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: scrollView.bottomAnchor, right: scrollView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
    }
    
    //PART2 - 3. ContentView 에 pagenationView 와 넣고싶은 뷰 삽입.
    func setupContentView(){
        contentView.addSubview(pagenationView)
        contentView.addSubview(label1)
        contentView.addSubview(label2)
        
        pagenationView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 300)
        label1.anchor(top: pagenationView.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 0)
        label2.anchor(top: label1.bottomAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 40, paddingRight: 40, width: 0, height: 0)
        //x,w,t,b 엑스좌표, 너비, 탑, 바텀 을 지정해주어야 합니다.
    }
    
    let label1: UILabel = {
        let label = UILabel()
        label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborumLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborumLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.............."
        label.numberOfLines = 0
        label.sizeToFit()
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let label2: UILabel = {
        let label = UILabel()
        label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
        label.numberOfLines = 0
        label.sizeToFit()
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()


}

