//
//  SearchDispayViewController.swift
//  IAmPet
//
//  Created by 长浩 张 on 2017/9/28.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

import Foundation

class SearchDisplayViewController: SBaseViewController
{
    var searchBar: UISearchBar?;
    
    var tempCell: OtherTalkCell?;
    
    var tableView: UITableView?;
    
    var dataCount: Int? = 0
    {
        didSet
        {
            tableView?.reloadData();
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        addTitleView();
        initView();
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated);
        searchBar?.becomeFirstResponder();
    }
    
    /**
     导航栏添加TitleView
     */
    private func addTitleView()
    {
        let titleView = UIView(frame: CGRect(x: 0,
                                             y: 0,
                                             width: ScreenWidth - 16,
                                             height: 44));
        searchBar = genSearchBar();
        let btn = genTitleViewBtn();
        titleView.addSubview(searchBar!);
        titleView.addSubview(btn);
        self.navigationItem.titleView = titleView;
    }
    
    /**
     生成UISearchBar
     
     - returns: UISearchBar instance
     */
    private func genSearchBar() -> UISearchBar
    {
        let searchBar = UISearchBar(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: ScreenWidth - 16 - 40,
                                                  height: 44));
        searchBar.backgroundColor(Utils.getColorByRGB(Color_Main), height: 44);
        searchBar.delegate = self as UISearchBarDelegate;
        searchBar.tintColor = UIColor.blue;
        return searchBar
    }
    
    /**
    generation title view button
     
     - returns: UIButton
     */
    private func genTitleViewBtn() -> UIButton
    {
        let btn = UIButton(frame: CGRect(x: ScreenWidth - 16 - 40,
                                         y: 0,
                                         width: 40,
                                         height: 44));
        btn.setTitle("取消", for: .normal);
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13);
        btn.addTarget(self, action: #selector(pop), for: .touchUpInside);
        return btn;
    }
    
    
    /**
     back to previous
     */
    @objc private func pop()
    {
        self.dismiss(animated: true, completion: nil);
    }
    
    /**
     initial the view
     
     - returns: Void
     */
    private func initView()
    {
        self.automaticallyAdjustsScrollViewInsets = false;
        tableView = genTableView();
        view.addSubview(tableView!);
    }
    
    /**
    generater UITableView
     
     - returns: UITableView
     */
    private func genTableView() -> UITableView
    {
        let tableView = UITableView(frame: CGRect(x: 0,
                                                  y: 64,
                                                  width: ScreenWidth,
                                                  height: ScreenHeight - 64),
                                    style: .plain);
        tableView.delegate = self as UITableViewDelegate;
        tableView.dataSource = self as UITableViewDataSource;
        tableView.tableFooterView = UIView(frame: CGRect.zero);
        return tableView;
    }
}

//MARK: - UITableViewDataSource

extension SearchDisplayViewController: UITableViewDataSource
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

extension SearchDisplayViewController: UITableViewDelegate
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
    }
}

//MARK: - UISearchBarDelegate

extension SearchDisplayViewController: UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        let origin = searchBar.text as NSString?;
        let result = origin?.replacingCharacters(in: range, with: text);
        let input = result!.removeInputHightLightSpace;
        
        print("intput:", input);
        dataCount = input.characters.count;
        return true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar)
    {
        let text = searchBar.text;
        dataCount = text!.characters.count;
        jumpToResult(text!);
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder();
    }
    
    /**
     跳转到结果页面
     
     - parameter text: Void
     */
    private func jumpToResult(_ text: String)
    {
        let controller = SearchResultViewController();
        controller.searchText = text;
        self.navigationController?.pushViewController(controller, animated: true);
    }
}
