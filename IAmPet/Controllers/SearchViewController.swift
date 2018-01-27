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
    weak var delegate: MainTabBarViewControllerDelegate?;
    
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
        
        addTitleView();
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
    }
    
    /**
     添加导航栏标题View
     */
    private func addTitleView()
    {
        let searchBar = genSearchbBar();
        let titleView = UIView(frame: CGRect(x: 0,
                                             y: 0,
                                             width: ScreenWidth - 16 - 40,
                                             height: 44));
        titleView.addSubview(searchBar!);
        self.navigationItem.titleView = titleView;
    }
    
    /**
     生成UISearchBar
     
     - returns: UISearchBar
     */
    private func genSearchbBar() -> UISearchBar?
    {
        let searchBar = UISearchBar(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: ScreenWidth - 16 - 40,
                                                  height: 44));
        searchBar.delegate = self as UISearchBarDelegate;
        searchBar.backgroundColor(Utils.getColorByRGB(Color_Main), height: 44);
        searchBar.placeholder = "搜索热门";
        return searchBar;
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

//MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        print(#function);
        dataCount = 20;
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool
    {
        searchBar.resignFirstResponder();
        let controller = SearchDisplayViewController();
        let nav = UINavigationController(rootViewController: controller);
        nav.modalTransitionStyle = .crossDissolve;
        self.present(nav, animated: true, completion: nil);
        
        return false;
    }
}

extension UISearchBar
{
    private func getImageWithColor(_ color: UIColor, height: CGFloat) -> UIImage
    {
        let r = CGRect(x: 0,
                       y: 0,
                       width: 1,
                       height: height);
        UIGraphicsBeginImageContext(r.size);
        let context = UIGraphicsGetCurrentContext();
        context!.setFillColor(color.cgColor);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!;
    }
    
    func backgroundColor(_ color: UIColor, height:CGFloat)
    {
        let image = getImageWithColor(color, height: height);
        self.setBackgroundImage(image, for: .top, barMetrics: .default);
//        self.setSearchFieldBackgroundImage(image, for: .normal);
    }
}
