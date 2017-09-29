//
//  TalkDetailViewController.swift
//  IAmPet
//
//  Created by changhaozhang on 2017/9/26.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

import Foundation


class TalkDetailViewController: SBaseViewController
{
    /**
     操作状态
     
     - Favor:   收藏
     - Comment: 评价
     - Likes:   点赞
     */
    enum OperationState
    {
        case Favor, Comment, Likes;
    }
    
    private var tableView: UITableView?
    
    weak var tempCell: UITableViewCell?;    //临时cell，用来计算高度使用
    
    var detailCell: TalkDetailCell?;
    
    var operationCell: TalkOperationCell?;
    
    var opState: OperationState! = .Comment   //操作状态
    {
        didSet
        {
            switchOperation();
        }
    }
    var itemCount: Int? = 0; //item 数量
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        initView();
    }
    
    /**
     初始化view
     */
    func initView()
    {
        self.automaticallyAdjustsScrollViewInsets = false;
        
        tableView = UITableView(frame: CGRect(x: 0,
                                              y: 64,
                                              width:ScreenWidth,
                                              height:ScreenHeight - 49 - 64),
                                style: UITableViewStyle.grouped);
        
        tableView?.delegate = self as UITableViewDelegate;
        tableView?.dataSource = self as UITableViewDataSource;
        tableView?.tableFooterView = UIView(frame: CGRect.zero);
        self.view.addSubview(tableView!);

        //添加底部
        let bottomView = DetailBottomView.loadNib();
        bottomView.delegate = self as DetailBottomViewDelegate;
        bottomView.frame = CGRect(x: 0,
                                  y: ScreenHeight - 49,
                                  width: ScreenWidth,
                                  height: 49);
        self.view.addSubview(bottomView);
    }
    
    /**
     回调，view显示
     
     - parameter animated: animated
     */
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated);
        opState = .Comment;
    }
    
    /**
     切换收藏、评论、点赞
     */
    private func switchOperation()
    {
        if (opState! == .Favor)
        {
            itemCount = 20;
        }
        else if (opState! == .Comment)
        {
            itemCount = 20;
        }
        else if (opState! == .Likes)
        {
            itemCount = 20;
        }
        
        let indexSet = IndexSet(integer: 2);
        tableView?.reloadSections(indexSet, with: .none);
    }
}

// MARK: - UITableViewDataSource

extension TalkDetailViewController: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 3;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (0 == section || 1 == section)
        {
            return 1;
        }
        else
        {
            return itemCount!;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = getCell(tableView: tableView, indexPath: indexPath);
        tempCell = cell;
        return cell!;
    }
    
    /**
     获取UITableViewCell
     
     - parameter indexPath: indexPath
     
     - returns: UITableViewCell
     */
    private func getCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell?
    {
        if (0 == indexPath.section)
        {
            return genTalkDetailCell();
        }
        else if (1 == indexPath.section)
        {
            return genTalkOperationCell();
        }
        else
        {
            if (opState == .Comment)
            {
                return genTalkCommentCell(tableView: tableView);
            }
            else
            {
                return genTalkFavorCell(tableView: tableView);
            }
        }
    }
    
    /**
     获取详情cell
     
     - returns: TalkDetailCell
     */
    private func genTalkDetailCell() -> TalkDetailCell
    {
        if let dCell = detailCell
        {
            return dCell;
        }
        
        let cell = TalkDetailCell.cellFromNib();
        detailCell = cell;
        cell.talkContent = "爽肤水放松放松爽肤水放松放松放松放松放松放松法爽肤水放松放松方式发送方舒服舒服";
        let urls = [
            "https://gss2.bdstatic.com/-fo3dSag_xI4khGkpoWK1HF6hhy/baike/c0%3Dbaike80%2C5%2C5%2C80%2C26/sign=9cb489038bd4b31ce4319ce9e6bf4c1a/8c1001e93901213f6e57dc9c54e736d12f2e950e.jpg",
            "http://image.tianjimedia.com/uploadImages/2015/131/29/1OZRZ52WJ9T2.jpg",
            "http://image.tianjimedia.com/uploadImages/2015/131/22/59SG53FU0160.jpg"
        ];
        let media = MediaContent(type: MediaContent.picture, urls:urls);
        cell.mediaContent = media;
        
        weak var weakSelf = self;
        
        //显示预览图
        cell.showPhoto = {
            (image: UIImage) -> Void in
            weakSelf?.showPreviewImage(image);
        };
        
        return cell;
    }
    
    /**
     获取TalkOperationCell
     
     - returns: TalkOperationCell;
     */
    private func genTalkOperationCell() -> TalkOperationCell
    {
        if let oCell = operationCell
        {
            return oCell;
        }
        
        let cell = TalkOperationCell.cellFromNib();
        operationCell = cell;
        cell.delegate = self as TalkOperationCellDelegate;
        return cell;
    }
    
    /**
     获取TalkFavorCell
     
     - returns: TalkFavorCell
     */
    private func genTalkFavorCell(tableView: UITableView) -> TalkFavorCell
    {
        var cell = tableView.dequeueReusableCell(withIdentifier: TalkFavorCell.identifier) as? TalkFavorCell;
        
        if (nil ==  cell)
        {
            cell = TalkFavorCell.loadNib();
        }
        return cell!;
    }
    
    /**
     获取TalkCommentCell
     
     - returns: TalkCommentCell
     */
    private func genTalkCommentCell(tableView: UITableView) -> TalkCommentCell
    {
        var cell = tableView.dequeueReusableCell(withIdentifier: TalkCommentCell.identifier) as? TalkCommentCell;
        if (nil == cell)
        {
            cell = TalkCommentCell.loadNib();
        }
        cell?.commentContent = "你这个真是啥的可以啊";
        return cell!;
    }
}

// MARK: - UITableViewDelegate

extension TalkDetailViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 10;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return getCellHeight(indexPath:indexPath);
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 0.1;
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        if (2 == section)
        {
            return 1;
        }
        return 5;
    }
    
    private func getCellHeight(indexPath: IndexPath) -> CGFloat
    {
        if (0 == indexPath.section)
        {
            return getTalkDetailCellHeight();
        }
        else if (1 == indexPath.section)
        {
            return getTalkOperationCellHeight();
        }
        else
        {
            if (opState! == .Comment)
            {
                return getTalkCommentCellHeight(cell: tempCell!);
            }
            else
            {
                return getTalkFavorCellHeight();
            }
        }
    }
    
    /**
     获取TalkDetailCell的高度
     
     - parameter cell: cell
     
     - returns: CGFloat
     */
    private func getTalkDetailCellHeight() -> CGFloat
    {
        if let dCell = detailCell
        {
            return CGFloat(dCell.cellHeight);
        }
        
        return 66;
    }
    
    /**
     获取TalkOperationCell高度
     
     - returns: cell height
     */
    private func getTalkOperationCellHeight() -> CGFloat
    {
        return CGFloat(TalkOperationCell.cellHeight);
    }
    
    /**
     获取TalkCommentCell的高度
     
     - parameter cell: cell
     
     - returns: cell height
     */
    private func getTalkCommentCellHeight(cell: UITableViewCell) -> CGFloat
    {
        guard  let cell = cell as? TalkCommentCell else
        {
            return 0;
        }
        
        return CGFloat(cell.cellHeight);
    }
    
    /**
     获取TalkFavorCell的高度
     
     - returns: cell height
     */
    private func getTalkFavorCellHeight() -> CGFloat
    {
        return CGFloat(TalkFavorCell.cellHeight);
    }
}

//MARK: - TalkOperationCellDelegate

extension TalkDetailViewController: TalkOperationCellDelegate
{
    func clickFavor() 
    {
        if (opState != .Favor)
        {
            opState = .Favor;
        }
    }
    
    func clickConment() 
    {
        if (opState != .Comment)
        {
            opState = .Comment;
        }
    }
    
    func clickLikes() 
    {
        if (opState != .Likes)
        {
            opState = .Likes;
        }
    }
}

//MARK: - DetailBottomViewDelegate

extension TalkDetailViewController: DetailBottomViewDelegate
{
    func favorClickView(_ view: DetailBottomView)
    {
        print("favor");
    }
    
    func commentClickView(_ view: DetailBottomView)
    {
        print("comment");
        showCommentEdit();
    }
    
    func likesClickView(_ view: DetailBottomView)
    {
        print("likes");
    }
    
    /**
     显示评论编辑界面
     */
    private func showCommentEdit()
    {
        let viewComment = CommentPublishView.loadNib();
        viewComment.frame = CGRect(x: 0,
                                   y: ScreenHeight,
                                   width: ScreenWidth,
                                   height: viewComment.frame.size.height);
        
        viewComment.delegate = self as CommentPublishViewDelegate;
        
        self.view.addSubview(viewComment);
        
//        UIView.transition(with: self.view, duration: 1, options: .curveEaseIn, animations: {
//
//        }, completion: nil);
        
        UIView.animate(withDuration: 0.2) {
            viewComment.center = CGPoint(x: ScreenWidth / 2, y: ScreenHeight - viewComment.bounds.size.height / 2);
        }
    }
}


extension TalkDetailViewController: CommentPublishViewDelegate
{
    func closeView(_ view: CommentPublishView)
    {
        UIView.animate(withDuration: 0.2, animations: {
            view.center = CGPoint(x: ScreenWidth / 2, y: ScreenHeight + view.bounds.size.height / 2);
        }) { (complete) in
            view.dismiss();
        };
    }
    
    func publishView(_ view: CommentPublishView, content: String?)
    {
        if let content = content
        {
            print(content);
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            view.center = CGPoint(x: ScreenWidth / 2, y: ScreenHeight + view.bounds.size.height / 2);
        }) { (complete) in
            view.dismiss();
        };
    }
}
