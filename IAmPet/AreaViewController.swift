//
//  AreaViewController.swift
//  IAmPet
//
//  Created by changhaozhang on 2017/9/27.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

import Foundation


class AreaViewController: BaseViewController
{
    var delegate: MainTabBarViewControllerDelegate?;
    
    var tableView: UITableView?
    
    var headerView: AreaHeaderView?
    
    weak var tempCell: OtherTalkCell?
    
    var dataCount: Int? = 5
    {
        didSet
        {
            tableView?.reloadData();
        }
    };
    
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
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated);
//        headerView?.initView();
    }
    
    /**
     初始化视图 
     
     - returns: Void
     */
    private func initView()
    {
        self.automaticallyAdjustsScrollViewInsets = false;
        addHeaderView();
        addTableView();
    }
    
    /**
     添加标题view
     */
    private func addHeaderView()
    {
        headerView = AreaHeaderView.loadNib();
        headerView?.delegate = self as AreaHeaderViewDelegate;
        headerView?.frame = CGRect(x: 0,
                                  y: 68,
                                  width: ScreenWidth,
                                  height: 44);
        view.addSubview(headerView!);
    }
    
    /**
     添加UITableView
     */
    private func addTableView()
    {
        let frame = CGRect(x: 0,
                           y: 68 + 44 + 8,
                           width: ScreenWidth,
                           height: ScreenHeight - (68 + 44 + 8 + 49));
        tableView = UITableView(frame:frame, style:.plain);
        tableView?.delegate = self as UITableViewDelegate;
        tableView?.dataSource = self as UITableViewDataSource;
        tableView?.tableFooterView = UIView(frame: CGRect.zero);
        view.addSubview(tableView!);
        
        weak var weakSelf = self;
        let header = MJRefreshNormalHeader {
            weakSelf?.dataCount = 2;
            weakSelf?.tableView?.reloadData();
            weakSelf?.tableView?.mj_header.endRefreshing();
        };
        
        let footer = MJRefreshBackNormalFooter {
            weakSelf?.dataCount = (weakSelf?.dataCount)! + 5;
            weakSelf?.tableView?.reloadData();
            weakSelf?.tableView?.mj_footer.endRefreshing();
        };
        tableView?.mj_header = header;
        tableView?.mj_footer = footer;
    }
    
}

//MARK: - AreaHeaderViewDelegate

extension AreaViewController: AreaHeaderViewDelegate
{
    func initChooseView(_ view: AreaHeaderView, category: AreaHeaderCategory)
    {
        dataCount = 100;
    }
    
    func chooseView(_ view: AreaHeaderView, category: AreaHeaderCategory)
    {
        switch category
        {
        case .Latest:
            dataCount = 5;
            
        case .Concern:
            dataCount = 3;
            
        case .DayHot:
            dataCount = 15;
            
        case .WeekHot:
            dataCount = 20;
        }
    }
}

//MARK: - UITableViewDataSource

extension AreaViewController: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return dataCount!;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCell(withIdentifier: OtherTalkCell.identifier) as? OtherTalkCell;
        if (nil == cell)
        {
            cell = OtherTalkCell.loadNib();
        }
        tempCell = cell;
        cell?.talkContent = "哎呀，这里非常好看啊，我想在这里歇着睡觉！";
        return cell!;
    }
}

// MARK: - UITableViewDelegate

extension AreaViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 10;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if let tempCell = tempCell
        {
            return CGFloat(tempCell.cellHeight);
        }
        
        return 0;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let controller = TalkDetailViewController();
        controller.hidesBottomBarWhenPushed = true;
        self.navigationController?.pushViewController(controller, animated: true);
    }
}
