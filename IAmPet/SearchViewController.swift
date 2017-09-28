//
//  SearchViewController.swift
//  IAmPet
//
//  Created by changhaozhang on 2017/9/28.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

import Foundation

class SearchViewController: SBaseViewController
{
    var delegate: MainTabBarViewControllerDelegate?;
    
    var tableView: UITableView?
    
    var headerView: AreaHeaderView?
    
    var searchBar: UISearchBar?
    
    weak var tempCell: OtherTalkCell?
    
    var dataCount: Int? = 0
    {
        didSet
        {
            tableView?.reloadData();
        }
    };
    
//    override func loadView()
//    {
//        self.view = UIScrollView(frame: CGRect(x: 0,
//                                               y: 0,
//                                               width: ScreenWidth,
//                                               height: ScreenHeight));
//    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        self.setNavTitle("搜索");
        
        weak var weakSelf = self;
        self.setNavBarLeft(UIImage(named: "icon_person")!) {
            weakSelf?.delegate?.clickNavLeft();
        };
        
        initView();
    }
    
    private func initView()
    {
        self.automaticallyAdjustsScrollViewInsets = false;
        addTableView();
    }
    
    private func addTableView()
    {
        tableView = UITableView(frame: CGRect(x: 0,
                                              y: 64 + 44,
                                              width: ScreenWidth,
                                              height: ScreenHeight - 64 - 49 - 44),
                                style: .plain);
        tableView?.delegate = self as UITableViewDelegate;
        tableView?.dataSource = self as UITableViewDataSource;
        tableView?.tableFooterView = UIView(frame: CGRect.zero);
        view.addSubview(tableView!);
        
        addSearchView();
    }
    
    private func addSearchView()
    {
        searchBar = UISearchBar(frame: CGRect(x: 0,
                                              y: 64,
                                              width: ScreenWidth,
                                              height: 44));
        searchBar?.delegate = self as UISearchBarDelegate;
        view.addSubview(searchBar!);
//        searchController = UISearchController(searchResultsController: nil);
//        
//        searchController?.searchResultsUpdater = self as UISearchResultsUpdating;
//        tableView?.tableHeaderView = searchController?.searchBar;
//        searchController?.dimsBackgroundDuringPresentation = false;
//        searchController?.delegate = self as UISearchControllerDelegate;
//        searchController?.hidesNavigationBarDuringPresentation = false;
//        definesPresentationContext = true;
//        
//        searchController?.searchBar.delegate = self as UISearchBarDelegate;
    }
}

extension SearchViewController: UISearchResultsUpdating
{
    func updateSearchResults(for searchController: UISearchController)
    {
//        let text = searchController.searchBar.text;
//        dataCount = text?.characters.count;
    }
}

//MARK: - UITableViewDataSource

extension SearchViewController: UITableViewDataSource
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

extension SearchViewController: UITableViewDelegate
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
}

//MARK: - UISearchControllerDelegate

extension SearchViewController: UISearchControllerDelegate
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
    }
    
    
    // Called after the search controller's search bar has agreed to begin editing or when 'active' is set to YES. If you choose not to present the controller yourself or do not implement this method, a default presentation is performed on your behalf.
    func presentSearchController(_ searchController: UISearchController)
    {
        print(#function);
    }
}

extension SearchViewController: UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        print(#function);
        dataCount = 20;
    }
}
