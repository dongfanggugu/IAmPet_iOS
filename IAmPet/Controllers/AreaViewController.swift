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
    weak var delegate: MainTabBarViewControllerDelegate?;
    
    var tableView: UITableView?
    
    var headerView: AreaHeaderView?
    
    weak var tempCell: OtherTalkCell?
    
    var arrayData: [Any] = [Any]();
    
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
    }
    
    /**
     初始化视图 
     
     - returns: Void
     */
    private func initView()
    {
        self.automaticallyAdjustsScrollViewInsets = false;
        addTableView();
        addHeaderView();
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
        
        let header = MJRefreshNormalHeader {
           [weak self] in
            self?.getTalks();
        };
        
        let footer = MJRefreshBackNormalFooter {
            [weak self] in
            self?.getMoreTalks();
        };
        tableView?.mj_header = header;
        tableView?.mj_footer = footer;
        
    }
    
    /**
     get talks
     */
    func getTalks()
    {
        let category = headerView?.category;
        
        switch category!
        {
        case .Latest:
            getCurTalks();
            
        case .Concern:
            getConcernTalks();
            
        case .DayHot:
            getDayHotTalks();
            
        case .WeekHot:
            getWeekHotTalks();
        } 
    }
    
    /**
     get more talks
     */
    func getMoreTalks()
    {
        let category = headerView?.category;
        
        switch category!
        {
        case .Latest:
            getMoreCurTalks();
            
        case .Concern:
            getMoreConcernTalks();
            
        case .DayHot:
            getMoreDayHotTalks();
            
        case .WeekHot:
            getMoreWeekHotTalks();
        } 
    }
}

//MARK: - AreaHeaderViewDelegate

extension AreaViewController: AreaHeaderViewDelegate
{
    func initChooseView(_ view: AreaHeaderView, category: AreaHeaderCategory)
    {
        getCurTalks();
    }
    
    func chooseView(_ view: AreaHeaderView, category: AreaHeaderCategory)
    {
        getTalks();
    }
    /**
     get current talks from server
     */
    func getCurTalks()
    {
        HttpClient.share().fgPost(URL_TALKS_ALL, parameters: nil, success: { (task, responseObject) in
            let body = (responseObject as? [String: Any])?["body"] as! [Any];
            self.refreshTalks(body);
        }) { (task, error) in
        }
    }
    
    /**
     get More current talks
     */
    func getMoreCurTalks()
    {
        var params = [String: Any]();
        params["createTime"] = ((arrayData.last as? [String: Any])?["createTime"])!;
        HttpClient.share().fgPost(URL_TALKS_ALL, parameters: params, success: { (task, responseObject) in
            let body = (responseObject as? [String: Any])?["body"] as! [Any];
            self.loadMoreTalks(body);
        }) { (task, error) in
        }
    }
    
    /**
     get concern talks
     */
    func getConcernTalks()
    {
        HttpClient.share().fgPost(URL_TALKS_ALL, parameters: nil, success: { (task, responseObject) in
            let body = (responseObject as? [String: Any])?["body"] as! [Any];
            self.refreshTalks(body);
        }) { (task, error) in
        }
    }
    
    /**
     get more concern talks
     */
    func getMoreConcernTalks()
    {
        var params = [String: Any]();
        params["createTime"] = ((arrayData.last as? [String: Any])?["createTime"])!;
        HttpClient.share().fgPost(URL_TALKS_ALL, parameters: params, success: { (task, responseObject) in
            let body = (responseObject as? [String: Any])?["body"] as! [Any];
            self.loadMoreTalks(body);
        }) { (task, error) in
        }
    }
    /**
     get day hot talks
     */
    func getDayHotTalks()
    {
        HttpClient.share().fgPost(URL_TALKS_ALL, parameters: nil, success: { (task, responseObject) in
            let body = (responseObject as? [String: Any])?["body"] as! [Any];
            self.refreshTalks(body);
        }) { (task, error) in
        }
    }
    
    /**
     get more day hot talks
     */
    func getMoreDayHotTalks()
    {
        var params = [String: Any]();
        params["createTime"] = ((arrayData.last as? [String: Any])?["createTime"])!;
        HttpClient.share().fgPost(URL_TALKS_ALL, parameters: params, success: { (task, responseObject) in
            let body = (responseObject as? [String: Any])?["body"] as! [Any];
            self.loadMoreTalks(body);
        }) { (task, error) in
        }
    }
    /**
     get week hot talks
     */
    func getWeekHotTalks()
    {
        HttpClient.share().fgPost(URL_TALKS_ALL, parameters: nil, success: { (task, responseObject) in
            let body = (responseObject as? [String: Any])?["body"] as! [Any];
            self.refreshTalks(body);
        }) { (task, error) in
        }
    }
    
    /**
     get more week hot talks
     */
    func getMoreWeekHotTalks()
    {
        var params = [String: Any]();
        params["createTime"] = ((arrayData.last as? [String: Any])?["createTime"])!;
        HttpClient.share().fgPost(URL_TALKS_ALL, parameters: params, success: { (task, responseObject) in
            let body = (responseObject as? [String: Any])?["body"] as! [Any];
            self.loadMoreTalks(body);
        }) { (task, error) in
        }
    }
    
    /**
     after get talks 
     
     - parameter talks: talks
     */
    private func refreshTalks(_ talks: [Any])
    {
        if ((tableView?.mj_header?.isRefreshing())!)
        {
            tableView?.mj_header?.endRefreshing();
            tableView?.mj_footer?.endRefreshing();
        }
        arrayData.removeAll();
        arrayData.append(contentsOf: talks);
        tableView?.reloadData();
    }
    
    /**
     load more talks
     
     - parameter talks: talk
     */
    private func loadMoreTalks(_ talks: [Any])
    {
        if ((tableView?.mj_footer?.isRefreshing())!)
        {
            if (0 == talks.count)
            {
                tableView?.mj_footer?.endRefreshingWithNoMoreData();
            }
            else
            {
                tableView?.mj_footer?.endRefreshing();
            }
        }
        arrayData.append(contentsOf: talks);
        tableView?.reloadData();
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
        return arrayData.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCell(withIdentifier: OtherTalkCell.identifier) as? OtherTalkCell;
        if (nil == cell)
        {
            cell = OtherTalkCell.loadNib();
        }
        tempCell = cell;
        let dicTalk = arrayData[indexPath.row] as? [String: Any];
        let talkInfo = TalkInfo(dictionary: dicTalk!);
        
        assignOtherTalkCell(cell!, talk: talkInfo!, index: indexPath.row);
        return cell!;
    }
    
    /**
     generator OtherTalkCell
     
     - parameter talk: talkInfo
     
     - parameter cell: OtherTalkCell
     
     - returns: OtherTalkCell
     */
    private func assignOtherTalkCell(_ cell: OtherTalkCell, talk: TalkInfo, index: Int)
    {
        cell.talkContent = talk.content;
        cell.mediaContent = talk.mediaContent;
        
        cell.playVideo = {
            [weak self] (url) in
            self?.playVideo(url);
        };
        
        cell.showPhoto = {
            [weak self] (image) in
            self?.showPreviewImage(image);
        };
        
        cell.addFavor = {
            [weak self, weak cell] in
            self?.addFavor(talk: talk, cell: cell!, index: index);
        }
        
        cell.addLikes = {
            [weak self, weak cell] in
            self?.addLikes(talk: talk, cell: cell!, index: index);
        }
        
        cell.favor = talk.favor;
        cell.likes = talk.likes;
        showFavorCount(cell: cell, count: talk.favorCount);
        showCommentCount(cell: cell, count: talk.commentCount);
        showLikesCount(cell: cell, count: talk.likesCount);
    }
   
    
    /**
     show favor count
     
     - parameter cell:  cell
     - parameter count: count
     */
    private func showFavorCount(cell: OtherTalkCell, count: Int)
    {
        cell.favorCount = count;
    }
    
    private func showCommentCount(cell: OtherTalkCell, count: Int)
    {
        cell.commentCount = count;
    }
    
    private func showLikesCount(cell: OtherTalkCell, count: Int)
    {
        cell.likesCount = count;
    }
    
    /**
     add favor
     
     - parameter talkId: talk id
     */
    private func addFavor(talk: TalkInfo, cell: OtherTalkCell, index: Int)
    {
        if (1 == cell.favor!)
        {
            self.showAlertMsg("您已经收藏过", dismiss: nil);
            return;
        }
        var params = [String: Any]();
        params["talkId"] = talk.id;
        
        HttpClient.share().bgPost(URL_TALK_FAVOR, parameters: params, success: { (task, responseObject) in
            self.showAlertMsg("收藏成功", dismiss: nil);
            self.updateFavorCount(cell: cell, index: index);
        }) { (task, error) in
            let code = (error! as NSError).code;
            if (11 == code)
            {
                self.showAlertMsg("您已经收藏过", dismiss: nil);
            }
        };
    }
    
    /**
     update the favor count of the cell
     
     - parameter _index: index
     */
    private func updateFavorCount(cell: OtherTalkCell, index: Int)
    {
        cell.favorCount =  cell.favorCount! + 1;
        cell.favor = 1;
        var dic = arrayData[index] as! [String: Any];
        dic["favorCount"] = cell.favorCount!;
        dic["favor"] = 1;
    }
    
    /**
     add likes
     
     - parameter talk:  talk id
     - parameter cell:  cell
     - parameter index: index
     */
    private func addLikes(talk: TalkInfo, cell: OtherTalkCell, index: Int)
    {
        if (1 == cell.likes!)
        {
            self.showAlertMsg("您已经点赞过", dismiss: nil);
            return;
        }
        var params = [String: Any]();
        params["talkId"] = talk.id;
        
        HttpClient.share().bgPost(URL_ADD_LIKES, parameters: params, success: { (task, responseObject) in
            self.showAlertMsg("点赞成功", dismiss: nil);
            self.updateLikesCount(cell: cell, index: index);
        }) { (task, error) in
            let code = (error! as NSError).code;
            if (12 == code)
            {
                self.showAlertMsg("您已经点赞过", dismiss: nil);
            }
        }
    }
    
    /**
     update the likes count
     
     - parameter cell:  cell
     - parameter index: index
     */
    private func updateLikesCount(cell: OtherTalkCell, index: Int)
    {
        cell.likesCount = cell.likesCount! + 1;
        cell.likes = 1;
        var dic = arrayData[index] as! [String: Any];
        dic["likesCount"] = cell.favorCount!;
        dic["likes"] = 1;
    }
    
    /**
     play video
     
     - parameter url: video url
     */
    private func playVideo(_ url: String)
    {
        let controller = VideoPlayerController();
        controller.hidesBottomBarWhenPushed = true;
        controller.urlStr = url;
        self.navigationController?.pushViewController(controller, animated: true);
    }
    
    /**
     显示个人信息
     */
    private func showPersonInfo()
    {
        let controller = PersonHomeViewController();
        controller.personName = "天空的鱼";
        controller.hidesBottomBarWhenPushed = true;
        self.navigationController?.pushViewController(controller, animated: true);
    }
}

// MARK: - UITableViewDelegate

extension AreaViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 250;
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
        let dicTalk = arrayData[indexPath.row] as? [String: Any];
        let talkInfo = TalkInfo(dictionary: dicTalk!);
        
        let controller = TalkDetailViewController();
        controller.talkInfo = talkInfo!;
        controller.hidesBottomBarWhenPushed = true;
        self.navigationController?.pushViewController(controller, animated: true);
    }
}
