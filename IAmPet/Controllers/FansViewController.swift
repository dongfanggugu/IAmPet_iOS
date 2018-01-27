//
//  FansViewController.swift
//  IAmPet
//
//  Created by 长浩 张 on 2017/10/3.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

import Foundation

class FansViewController: SBaseViewController
{
    var tableView: UITableView?;
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        setNavTitle("关注者")
        initView();
    }
    
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

extension FansViewController: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 20;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCell(withIdentifier: FansCell.identifier) as? FansCell;
        if (nil == cell)
        {
            cell = FansCell.loadNib();
        }
        
        cell?.imgHead = UIImage(named: "icon_icon.jpg");
        cell?.nickName = "不吃鱼的喵";
        cell?.introduce = "本喵是个素食主义喵";
        
        weak var weakCell = cell;
        cell?.changeConcerned = {
            (isConcerned: Bool) -> Void in
            if (isConcerned)
            {
                weakCell?.isConcerned = false;
            }
            else
            {
                weakCell?.isConcerned = true;
            }
        };
        
        if (0 == indexPath.row % 2)
        {
            cell?.isConcerned = true;
        }
        else
        {
            cell?.isConcerned = false;
        }
        
        return cell!;
    }
}

//MARK: - UITableViewDelegate

extension FansViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return FansCell.cellHeight;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let controller = PersonHomeViewController();
        controller.hidesBottomBarWhenPushed = true;
        controller.personName = "不吃鱼的喵";
        self.navigationController?.pushViewController(controller, animated: true);
    }
}
