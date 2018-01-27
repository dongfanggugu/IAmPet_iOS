//
//  ChatListViewController.swift
//  IAmPet
//
//  Created by changhaozhang on 2017/9/30.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

import Foundation

class ChatListViewController: SBaseViewController
{
    weak var delegate: MainTabBarViewControllerDelegate?;
    
    var tableView: UITableView?;
    
    var searchController: UISearchController?;
    
    var searchActived: Bool? = false
    
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
        
        setNavTitle("私信");
        weak var weakSelf = self;
        self.setNavBarLeft(UIImage(named: "icon_person")!) {
            weakSelf?.delegate?.clickNavLeft();
        };
        
        initView();
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated);
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
        
        addSearchView();
    }
    
    /**
     添加搜索
     */
    private func addSearchView()
    {
        searchController = UISearchController(searchResultsController: nil);
        searchController?.searchResultsUpdater = self as UISearchResultsUpdating;
        searchController?.searchBar.placeholder = "联系人";
        searchController?.searchBar.searchBarStyle = .minimal;
        searchController?.dimsBackgroundDuringPresentation = false;
        searchController?.hidesNavigationBarDuringPresentation = true;
        searchController?.searchBar.delegate = self;
        searchController?.delegate = self;
        self.definesPresentationContext = true;
        tableView?.tableHeaderView = searchController?.searchBar;
    }
}

//MARK: - UITableViewDataSource

extension ChatListViewController: UITableViewDataSource
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
        var cell = tableView.dequeueReusableCell(withIdentifier: ChatCell.identifier) as? ChatCell;
        if (nil == cell)
        {
            cell = ChatCell.loadNib();
        }
        cell?.imgHead = UIImage(named: "0.jpeg");
        return cell!;
    }
}

// MARK: - UITableViewDelegate

extension ChatListViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return ChatCell.cellHeight;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true);
        if (searchActived!)
        {
            jumpToChat();
        }
        else
        {
            jumpToChat()
        }
    }
    
    /**
     跳转到聊天页面
     */
    private func jumpToChat()
    {
        let controller = ChatViewController();
        controller.hidesBottomBarWhenPushed = true;
        self.navigationController?.pushViewController(controller, animated: true);
    }
}

//MARK: - UISearchControllerDelegate

extension ChatListViewController: UISearchControllerDelegate
{
    func willPresentSearchController(_ searchController: UISearchController)
    {
        print(#function);
    }
    
    func didPresentSearchController(_ searchController: UISearchController)
    {
        print(#function);
    }
    
    func willDismissSearchController(_ searchController: UISearchController)
    {
        print(#function);
    }
    
    func didDismissSearchController(_ searchController: UISearchController)
    {
        print(#function);
        dataCount = 20;
    }
    
    
    // Called after the search controller's search bar has agreed to begin editing or when 'active' is set to YES. If you choose not to present the controller yourself or do not implement this method, a default presentation is performed on your behalf.
    func presentSearchController(_ searchController: UISearchController)
    {
        print(#function);
    }
}

//MARK: - UISearchBarDelegate

extension ChatListViewController: UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        print(#function);
        dataCount = 20;
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool
    {
//        searchBar.resignFirstResponder();
//        let controller = SearchDisplayViewController();
//        let nav = UINavigationController(rootViewController: controller);
//        nav.modalTransitionStyle = .crossDissolve;
//        self.present(nav, animated: true, completion: nil);
        
        return true;
    }
    
}

//MARK: - UISearchResultsUpdating

extension ChatListViewController: UISearchResultsUpdating
{
    func updateSearchResults(for searchController: UISearchController)
    {
        dataCount = searchController.searchBar.text?.characters.count;
    }
}
