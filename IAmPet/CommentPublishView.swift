//
//  CommentPublishView.swift
//  IAmPet
//
//  Created by changhaozhang on 2017/9/27.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

import Foundation

//MARK: - CommentPublishViewDelegate

protocol CommentPublishViewDelegate: class
{
    func closeView(_ view: CommentPublishView);
    
    func publishView(_ view: CommentPublishView, content: String?);
}

//MARK: - CommentPublishView

class CommentPublishView: UIView, Nibloadable
{
    @IBOutlet private weak var btnPublish: UIButton!;
    
    @IBOutlet private weak var btnClose: UIButton!;
    
    @IBOutlet weak var lbStatistics: UILabel!;
    
    @IBOutlet weak var tvComment: IQTextView!;
    
    weak var delegate: CommentPublishViewDelegate?;
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        initViewStyle();
        
        tvComment.placeholder = "发布你的评论";
        tvComment.delegate = self as UITextViewDelegate;
    }
    
    /**
     初始化界面的主题
     */
    private func initViewStyle()
    {
        btnPublish.backgroundColor = Utils.getColorByRGB(Color_Main);
        
        tvComment.layer.masksToBounds = true;
        tvComment.layer.cornerRadius = 5;
        
        lbStatistics.textColor = UIColor.lightGray;
    }
    
    /**
     点击关闭
     
     - parameter sender: sender
     */
    @IBAction func clickClose(sender: UIButton)
    {
        delegate?.closeView(self);
    }
    
    /**
     点击发布
     
     - parameter sender: sender
     */
    @IBAction func clickPublish(sender: UIButton)
    {
        delegate?.publishView(self, content: tvComment.text);
    }
    
    /**
     从父view移除
     */
    func dismiss()
    {
        if self.superview != nil
        {
            self.removeFromSuperview();
        }
    }

    deinit
    {
        print("\(self) deinit");
    }
}

extension CommentPublishView: UITextViewDelegate
{
    func textViewDidChange(_ textView: UITextView)
    {
        HHUtils.textViewLimitEndInput(300, textView: textView, label: lbStatistics);
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        return HHUtils.textViewLimitOnInput(300, textView: textView, textRange: range, text: text);
    }
}
