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
    
    var talkInfo: TalkInfo?
    
    private var tableView: UITableView?
    
    weak var tempCell: UITableViewCell?;    //临时cell，用来计算高度使用
    
    var detailCell: TalkDetailCell?;
    
    var operationCell: TalkOperationCell?;
    
    var commentEditView: CommentPublishView?;   //评论view
    
    var opState: OperationState! = .Comment   //操作状态
    {
        didSet
        {
            switchOperation();
        }
    }
    var itemCount: Int? = 0; //item 数量
    
    override func loadView()
    {
    
        let scrollView = UIScrollView(frame: CGRect(x: 0,
                                                    y: 0,
                                                    width: ScreenWidth,
                                                    height: ScreenHeight));
        self.view = scrollView;
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        addKeyboardObserver();
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
                                              width: ScreenWidth,
                                              height: ScreenHeight - 49 - 64),
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
     添加键盘出现消失监听
     */
    private func addKeyboardObserver()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notify:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHidden(notify:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil);
    }
    
    /**
     键盘显示时
     
     - parameter notify: notify
     */
    @objc private func keyboardWillShow(notify: Notification)
    {
        let userInfo = notify.userInfo; let aValue = userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue;
        let kbRect = aValue.cgRectValue;
        let changeY = kbRect.origin.y;
        let duration = userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double;
        
        var frame = commentEditView?.frame;
        frame?.origin.y = changeY - frame!.size.height;
        
        weak var weakSelf = self;
        UIView.animate(withDuration: duration, animations: {
            weakSelf?.commentEditView?.frame = frame!;
        }, completion: nil);
    }
    
    /**
     键盘消失时
     
     - parameter notify: notify
     */
    @objc private func keyboardWillHidden(notify: Notification)
    {
        var frame = commentEditView?.frame;
        frame?.origin.y = ScreenHeight - frame!.size.height;
        commentEditView?.frame = frame!;
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
    
    deinit
    {
        NotificationCenter.default.removeObserver(self);
        print("\(self) deinit");
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
        cell.talkContent = talkInfo?.content;
        cell.mediaContent = talkInfo?.mediaContent;
        
        //显示预览图
        cell.showPhoto = {
            [weak self] (image: UIImage) in
            self?.showPreviewImage(image);
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
        commentEditView = CommentPublishView.loadNib();
        commentEditView!.frame = CGRect(x: 0,
                                   y: ScreenHeight - commentEditView!.frame.size.height,
                                   width: ScreenWidth,
                                   height: commentEditView!.frame.size.height);
        
        commentEditView!.delegate = self as CommentPublishViewDelegate;
        
        self.view.addSubview(commentEditView!);
        commentEditView!.tvComment.becomeFirstResponder();
    }
}


extension TalkDetailViewController: CommentPublishViewDelegate
{
    func closeView(_ view: CommentPublishView)
    {
        weak var weakSelf = self;
        UIView.animate(withDuration: 0.2, animations: {
            view.center = CGPoint(x: ScreenWidth / 2, y: ScreenHeight + view.bounds.size.height / 2);
        }) {
            (complete) in
            view.dismiss();
            weakSelf?.commentEditView = nil;
        };
    }
    
    func publishView(_ view: CommentPublishView, content: String?)
    {
        if let content = content
        {
            print(content);
        }
        
        weak var weakSelf = self;
        UIView.animate(withDuration: 0.2, animations: {
            view.center = CGPoint(x: ScreenWidth / 2, y: ScreenHeight + view.bounds.size.height / 2);
        }) {
            (complete) in
            view.dismiss();
            weakSelf?.commentEditView = nil;
        };
    }
}
