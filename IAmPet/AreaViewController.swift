//
//  AreaViewController.swift
//  IAmPet
//
//  Created by changhaozhang on 2017/9/27.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

import Foundation

@objc protocol AreaViewControllerDelegate
{
    func clickNavLeft();
}

class AreaViewController: BaseViewController
{
    var delegate: AreaViewControllerDelegate?;
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        self.setNavTitle("广场");
        
        weak var weakSelf = self;
        self.setNavBarLeft(UIImage(named: "icon_person")!) {
            weakSelf?.delegate?.clickNavLeft();
        };
        
        initView();
    }
    
    private func initView()
    {
        self.automaticallyAdjustsScrollViewInsets = false;
        let headerView = AreaHeaderView.loadNib();
        headerView.delegate = self as AreaHeaderViewDelegate;
        headerView.frame = CGRect(x: 0,
                                  y: 68,
                                  width: ScreenWidth,
                                  height: headerView.bounds.size.height);
        self.view.addSubview(headerView);
    }
    
}

extension AreaViewController: AreaHeaderViewDelegate
{
    func initChooseView(_ view: AreaHeaderView, category: AreaHeaderCategory)
    {
        
    }
    
    func chooseView(_ view: AreaHeaderView, category: AreaHeaderCategory)
    {
        
        print(category);
    }
}
