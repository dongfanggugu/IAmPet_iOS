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
    var searchBar: UISearchBar?
    
    var tempCell: OtherTalkCell?
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        addSearchBar();
        initView();
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated);
    }
    
    private func addSearchBar()
    {
        searchBar = UISearchBar(frame: CGRect(x: 0,
                                              y: 0,
                                              width: ScreenWidth - 16 - 40,
                                              height: 44));
        searchBar?.backgroundColor(Utils.getColorByRGB(Color_Main), height: 44);
        
        let btn = UIButton(frame: CGRect(x: ScreenWidth - 16 - 40,
                                         y: 0,
                                         width: 40,
                                         height: 44));
        btn.setTitle("取消", for: .normal);
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13);
        btn.addTarget(self, action: #selector(pop), for: .touchUpInside);
        
        let titleView = UIView(frame: CGRect(x: 0,
                                             y: 0,
                                             width: ScreenWidth - 16,
                                             height: 44));
        //        titleView.layer.masksToBounds = true;
        titleView.addSubview(searchBar!);
        titleView.addSubview(btn);
        
        self.navigationItem.titleView = titleView;
    }
    
    @objc private func pop()
    {
        self.dismiss(animated: true, completion: nil);
    }
    
    private func initView()
    {
        self.automaticallyAdjustsScrollViewInsets = false;
        let tableView = UITableView(frame: CGRect(x: 0,
                                              y: 64,
                                              width: ScreenWidth,
                                              height: ScreenHeight - 64),
                                style: .plain);
        tableView.delegate = self as UITableViewDelegate;
        tableView.dataSource = self as UITableViewDataSource;
        tableView.tableFooterView = UIView(frame: CGRect.zero);
        view.addSubview(tableView);
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
        return 5;
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
}

//extension UISearchBar
//{
//    private func getImageWithColor(_ color: UIColor, height: CGFloat) -> UIImage
//    {
//        let r = CGRect(x: 0,
//                       y: 0,
//                       width: 1,
//                       height: height);
//        UIGraphicsBeginImageContext(r.size);
//        let context = UIGraphicsGetCurrentContext();
//        context!.setFillColor(color.cgColor);
//        let image = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        return image!;
//    }
//    
//    func backgroundColor(_ color: UIColor, height:CGFloat)
//    {
//        let image = getImageWithColor(color, height: height);
//        self.setBackgroundImage(image, for: .top, barMetrics: .default);
//    }
//}

