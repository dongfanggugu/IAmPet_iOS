//
//  FollowsViewController.swift
//  IAmPet
//
//  Created by 长浩 张 on 2017/10/3.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

import Foundation

class FollowsViewController: SBaseViewController
{
    var tableView: UITableView?;
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        setNavTitle("正在关注")
        initView();
    }
    
    var dataCount: Int? = 5;
    
    /**
     init view
     
     - returns: Void
     */
    private func initView()
    {
        self.automaticallyAdjustsScrollViewInsets = false;
        addTableView();
    }
    
    /**
     add tableview
     */
    private func addTableView()
    {
        let frame = CGRect(x: 0,
                           y: 64,
                           width: ScreenWidth,
                           height: ScreenHeight - 64);
        tableView = UITableView(frame: frame, style:.plain);
        tableView?.delegate = self;
        tableView?.dataSource = self;
        tableView?.tableFooterView = UIView(frame: CGRect.zero);
        view.addSubview(tableView!);
    }
}

//MARK: - UITableViewDataSource

extension FollowsViewController: UITableViewDataSource
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
        var cell = tableView.dequeueReusableCell(withIdentifier: FansCell.identifier) as? FollowsCell;
        if (nil == cell)
        {
            cell = FollowsCell.loadNib();
        }
        
        cell?.imgHead = UIImage(named: "icon_icon.jpg");
        cell?.nickName = "不吃鱼的喵";
        cell?.talk = "今天再次去钓鱼了";
        
        weak var weakSelf = self;
        cell?.changeConcern = {
//            weakSelf?.dataCount! -= 1;
//            weakSelf?.tableView?.deleteRows(at: [indexPath], with: .automatic);
        };
        
        return cell!;
    }
}

//MARK: - UITableViewDelegate

extension FollowsViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return FollowsCell.cellHeight;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let controller = PersonHomeViewController();
        controller.hidesBottomBarWhenPushed = true;
        controller.personName = "不吃鱼的喵";
        self.navigationController?.pushViewController(controller, animated: true);
    }
}
