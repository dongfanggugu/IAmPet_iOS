//
//  TalkOperationCell.swift
//  IAmPet
//
//  Created by changhaozhang on 2017/9/26.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

import Foundation

protocol TalkOperationCellDelegate: class
{
    func clickFavor() -> Void;
    func clickConment() -> Void;
    func clickLikes() -> Void;
}


class TalkOperationCell: UITableViewCell, Nibloadable
{
    @IBOutlet private weak var btnFavor: UIButton!;
    
    @IBOutlet private weak var btnConment: UIButton!;
    
    @IBOutlet private weak var btnLikes: UIButton!;
    
    weak var delegate: TalkOperationCellDelegate?;
    
    var favorAmount: Int?
    {
        didSet
        {
            let title = "收藏 \(favorAmount!)";
            btnFavor.setTitle(title, for: UIControlState.normal);
        }
    };
    
    var conmentAmount: Int?
    {
        didSet
        {
            let title = "评论 \(conmentAmount!)";
            btnConment.setTitle(title, for: UIControlState.normal);
        }
    }
    
    var likesAmount: Int?
    {
        didSet
        {
            let title = "点赞 \(likesAmount!)";
            btnLikes.setTitle(title, for: UIControlState.normal);
        }
    }
    
    static let cellHeight = 44;
    
    static let identifier = "talk_operation_cell";
    
    class func cellFromNib() -> TalkOperationCell
    {
        return TalkOperationCell.loadNib();
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib();
        resetBtn();
        btnConment.setTitleColor(UIColor.black, for: UIControlState.normal);
    }
    
    /**
     重置按钮状态
     */
    private func resetBtn() -> Void
    {
        btnFavor.setTitleColor(Utils.getColorByRGB(Color_Gray_Font), for: UIControlState.normal);
        btnConment.setTitleColor(Utils.getColorByRGB(Color_Gray_Font), for: UIControlState.normal);
        btnLikes.setTitleColor(Utils.getColorByRGB(Color_Gray_Font), for: UIControlState.normal);
    }
    
    /**
     点击收藏
     
     - parameter sender: sender
     */
    @IBAction private func clickFavor(sender: UIButton) -> Void
    {
        resetBtn();
        btnFavor.setTitleColor(UIColor.black, for: UIControlState.normal);
        if (delegate != nil)
        {
            delegate?.clickFavor();
        }
    }
    
    /**
     点击评论
     
     - parameter sender: sender
     */
    @IBAction private func clickComent(sender: UIButton) -> Void
    {
        resetBtn();
        btnConment.setTitleColor(UIColor.black, for: UIControlState.normal);
        if (delegate != nil)
        {
            delegate?.clickConment();
        }
    }
    
    /**
     点击点赞
     
     - parameter sender: sender
     */
    @IBAction private func clickLikes(sender: UIButton) -> Void
    {
        resetBtn();
        btnLikes.setTitleColor(UIColor.black, for: UIControlState.normal);
        if (delegate != nil)
        {
            delegate?.clickLikes();
        }
    }
}
