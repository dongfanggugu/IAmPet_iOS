//
//  SearchResultViewController.swift
//  IAmPet
//
//  Created by changhaozhang on 2017/9/29.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

import Foundation

class SearchResultViewController: SBaseViewController
{
    var searchText: String?
    
    var tableView: UITableView?
    
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
        
        if let searchText = searchText
        {
            setNavTitle(searchText);
        }
        initView();
    }
    
    /**
     初始化视图
     
     - returns: Void
     */
    private func initView()
    {
        self.automaticallyAdjustsScrollViewInsets = false;
        addTableView();
    }
    
    /**
     添加UITableView
     */
    private func addTableView()
    {
        tableView = UITableView(frame: CGRect(x: 0,
                                              y: 64,
                                              width: ScreenWidth,
                                              height: ScreenHeight - 64),
                                style: .plain);
        tableView?.delegate = self as UITableViewDelegate;
        tableView?.dataSource = self as UITableViewDataSource;
        tableView?.tableFooterView = UIView(frame: CGRect.zero);
        view.addSubview(tableView!);
    }
    
}

//MARK: - UITableViewDataSource

extension SearchResultViewController: UITableViewDataSource
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

extension SearchResultViewController: UITableViewDelegate
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
        navigationController?.pushViewController(controller, animated: true);
    }
}
