//
//  DetailBottomView.swift
//  IAmPet
//
//  Created by changhaozhang on 2017/9/27.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

import Foundation

//MARK: - DetailBottomViewDelegate

protocol DetailBottomViewDelegate
{
    func favorClickView(_ view: DetailBottomView);
    
    func commentClickView(_ view: DetailBottomView);
    
    func likesClickView(_ view: DetailBottomView);
}

//MARK: - DetailBottomView

class DetailBottomView: UIView, Nibloadable
{
    @IBOutlet private weak var btnFavor: UIButton!;
    @IBOutlet private weak var btnComment: UIButton!;
    @IBOutlet private weak var btnLikes: UIButton!;
    
    @IBOutlet private weak var lbFavor: UILabel!;
    @IBOutlet private weak var lbComment: UILabel!;
    @IBOutlet private weak var lbLikes: UILabel!;
    
    var delegate: DetailBottomViewDelegate?;
    
    override func awakeFromNib()
    {
        super.awakeFromNib();
        addClickListener();
    }
    
    /**
      给控件添加点击响应
     */
    private func addClickListener()
    {
        lbFavor.isUserInteractionEnabled = true;
        lbComment.isUserInteractionEnabled = true;
        lbLikes.isUserInteractionEnabled = true;
        
        let selectorFavor = #selector(clickFavor);
        let selectorComment = #selector(clickComment);
        let selectorLikes = #selector(clickLikes);
        
        addTapGesture(lbFavor, selector:selectorFavor);
        addTapGesture(lbComment, selector: selectorComment);
        addTapGesture(lbLikes, selector: selectorLikes);
        
        btnFavor.addTarget(self, action: selectorFavor, for: .touchUpInside);
        btnComment.addTarget(self, action: selectorComment, for: .touchUpInside);
        btnLikes.addTarget(self, action: selectorLikes, for: .touchUpInside);
    }
    
    /**
     添加单击手势
     
     - parameter view:     view
     - parameter selector: selector
     
     - returns: UITapGestureRecognizer
     */
    private func addTapGesture(_ view: UIView, selector: Selector)
    {
        let recognizer = UITapGestureRecognizer();
        recognizer.addTarget(self, action: selector);
        view.addGestureRecognizer(recognizer);
    }
    
    /**
     点击收藏
     */
    @objc private func clickFavor()
    {
        delegate?.favorClickView(self);
    }
    
    /**
     点击评论
     */
    @objc private func clickComment()
    {
        delegate?.commentClickView(self);
    }
    
    /**
     点击点赞
     */
    @objc private func clickLikes()
    {
        delegate?.likesClickView(self);
    }
}
