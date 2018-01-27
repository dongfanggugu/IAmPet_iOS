//
//  CommentsViewController.swift
//  IAmPet
//
//  Created by changhaozhang on 2017/10/10.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

import Foundation

class CommentsViewController: SBaseViewController
{
    var tableView: UITableView?;
    
    var tempCell: MyTalkCell?;
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        setNavTitle("我的评论");
        initView();
    }
    
    /**
     initial view
     
     - returns: Void
     */
    private func initView()
    {
        self.automaticallyAdjustsScrollViewInsets = false;
        addTableView();
    }
    
    /**
     add table view
     */
    private func addTableView()
    {
        let frame = CGRect(x: 0,
                           y: 64,
                           width: ScreenWidth,
                           height: ScreenHeight - 64);
        tableView = UITableView(frame: frame, style:.plain);
        tableView?.delegate = self;
        tableView?.dataSource = self;
        self.view.addSubview(tableView!);
    }
}

//MARK: - UITableViewDataSource

extension CommentsViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 20;
    }
    
    static let identifier = "comment_cell";
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCell(withIdentifier: CommentsViewController.identifier);
        
        if (nil == cell)
        {
            cell = UITableViewCell(style:.default, reuseIdentifier:"cell");
            cell!.selectionStyle = .none;
        }
        
        clearSubviews(view: cell!.contentView);
        
        let talkCell = generatorMyTalkCell();
        tempCell = talkCell;
        cell?.contentView.addSubview(talkCell.contentView);
        let comment = "阿发爽肤水放松放松烦死了防辐射服就是是否 爽肤水放松放松发是否是的冯绍峰发斯蒂芬斯蒂芬胜多负少";
        addCommentLable(comment: comment, contentView: cell!.contentView, y: CGFloat(talkCell.cellHeight + 8));
        
        return cell!;
    }
    
    /**
     clear subviews
     
     - parameter view: view
     */
    private func clearSubviews(view: UIView)
    {
        for subView in view.subviews
        {
            subView.removeFromSuperview();
        }
    }
    
    /**
     generator MyTalkCell
     
     - returns: MyTalkCell
     */
    private func generatorMyTalkCell() -> MyTalkCell
    {
        let cell = MyTalkCell.loadNib();
        cell.talkContent = "看看这次我怎么样吧";
        cell.lbName.text = "不吃鱼的喵喵";
        setMyTalkCellGray(cell: cell);
        cell.contentView.frame = CGRect(x: 8,
                                        y: 8,
                                        width: ScreenWidth - 16,
                                        height: CGFloat(cell.cellHeight));
        return cell;
    }
    
    /**
     set MyTalkCell background color gray
     */
    private func setMyTalkCellGray(cell: MyTalkCell)
    {
        cell.contentView.backgroundColor = Utils.getColorByRGB(Color_Light_Gray);
        for view in cell.contentView.subviews
        {
            view.backgroundColor = Utils.getColorByRGB(Color_Light_Gray);
        }
    }
    
    /**
     add comment content label
     
     - parameter comment:     comment
     - parameter contentView: contentview
     - parameter y:           y
     */
    private func addCommentLable(comment: String, contentView: UIView, y: CGFloat)
    {
        let height = getCommentHeight(comment: comment);
        let frame = CGRect(x: 8,
                           y: y + 8,
                           width: ScreenWidth - 16,
                           height: height);
        let label = UILabel(frame: frame);
        label.font = UIFont.systemFont(ofSize: 14);
        label.numberOfLines = 0;
        label.lineBreakMode = .byWordWrapping;
        label.text = comment;
        
//        let matrix = __CGAffineTransformMake(1, 0, CGFloat(tanf(Float(-15 * Double.pi / 180))), 1, 0, 0);
//        label.transform = matrix;
        
        contentView.addSubview(label);
    }
    
    /**
     get comment text height
     
     - parameter comment: comment
     
     - returns: text height
     */
    func getCommentHeight(comment: String) -> CGFloat
    {
        let font = UIFont.systemFont(ofSize: 14);
        return HHUtils.getTextHeight(textStr: comment, font: font, width: ScreenWidth - 16);
    }
}

//MARK: - UITableViewDelegate

extension CommentsViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 66;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let cellHeight = CGFloat(tempCell!.cellHeight);
        let comment = "阿发爽肤水放松放松烦死了防辐射服就是是否 爽肤水放松放松发是否是的冯绍峰发斯蒂芬斯蒂芬胜多负少";
        let height = getCommentHeight(comment: comment);
        
        return 8 + cellHeight + 8 + height + 8;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let controller = TalkDetailViewController();
        controller.hidesBottomBarWhenPushed = true;
        self.navigationController?.pushViewController(controller, animated: true);
    }
}
