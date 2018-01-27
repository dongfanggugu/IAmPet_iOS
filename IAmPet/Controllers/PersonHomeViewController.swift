//
//  PersonHomeViewController.swift
//  IAmPet
//
//  Created by 长浩 张 on 2017/10/2.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

import Foundation

class PersonHomeViewController: SBaseViewController
{
    var personName: String?;
    
    weak var tempCell: MyTalkCell?;
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        
        setNavTitle(personName!);
        weak var weakSelf = self;
        setNavBarRight(UIImage(named: "concern")) {
            weakSelf?.clickNavRight();
        };
        initView();
    }
    
    /**
     click navigation right button
     */
    private func clickNavRight()
    {
        print("concern");
    }
    
    /**
     init the view
     
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
        let tableView = UITableView(frame: frame, style:.plain);
        tableView.tableFooterView = UIView(frame: CGRect.zero);
        tableView.dataSource = self;
        tableView.delegate = self;
        self.view.addSubview(tableView);
    }
}

extension PersonHomeViewController: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 10;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCell(withIdentifier: MyTalkCell.identifier) as? MyTalkCell;
        if (nil == cell)
        {
            cell = MyTalkCell.loadNib();
        }
        tempCell = cell;
        
        let urls = [
            "https://gss2.bdstatic.com/-fo3dSag_xI4khGkpoWK1HF6hhy/baike/c0%3Dbaike80%2C5%2C5%2C80%2C26/sign=9cb489038bd4b31ce4319ce9e6bf4c1a/8c1001e93901213f6e57dc9c54e736d12f2e950e.jpg",
            "http://image.tianjimedia.com/uploadImages/2015/131/29/1OZRZ52WJ9T2.jpg",
            "http://image.tianjimedia.com/uploadImages/2015/131/22/59SG53FU0160.jpg"
        ];
        let media = MediaContent(type: MediaContent.picture, urls: urls);
        cell?.mediaContent = media;
        weak var weakSelf = self;
        cell?.showPhoto = {
            (image) -> Void in
            weakSelf?.showPreviewImage(image);
        };
        
        return cell!;
    }
}

extension PersonHomeViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 10;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return CGFloat((tempCell?.cellHeight)!);
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let controller = TalkDetailViewController();
        controller.hidesBottomBarWhenPushed = true;
        self.navigationController?.pushViewController(controller, animated: true);
    }
}
