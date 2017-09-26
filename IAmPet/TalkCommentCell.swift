//
//  TalkCommentCell.swift
//  IAmPet
//
//  Created by changhaozhang on 2017/9/26.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

import Foundation

class TalkCommentCell: UITableViewCell, Nibloadable
{
    @IBOutlet private weak var ivHead: UIImageView!;
    
    @IBOutlet private weak var lbName: UILabel!;
    
    @IBOutlet private weak var lbDate: UILabel!;
    
    @IBOutlet private weak var lbContent: UILabel!;
    
    @IBOutlet private weak var heightContent: NSLayoutConstraint!;
    
    static let identifier = "talk_comment_cell";    //cell reuse cell identifier
    
    var cellHeight: Float = 88; //cell init height
    
    var commentContent: String?    //评论内容
    {
        didSet
        {
            lbContent.text = commentContent;
            resetContentHeight(content: commentContent);
        }
    };
    
    class func cellFromNib() -> TalkCommentCell
    {
        return TalkCommentCell.loadNib();
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib();
        
        self.selectionStyle = UITableViewCellSelectionStyle.none;
        
        lbContent.numberOfLines = 0;
        lbContent.lineBreakMode = NSLineBreakMode.byWordWrapping;
    }
    
    /**
     重置内容高度和cell 高度
     
     - parameter content: content
     */
    private func resetContentHeight(content: String?) -> Void
    {
        guard let content = content else
        {
            return;
        }
        
        let font = UIFont.systemFont(ofSize: 14);
        let width = lbContent.frame.size.width;
        print("width: \(width)");
        let height = HHUtils.getTextHeight(textStr: content, font: font, width: width);
        let div = height - heightContent.constant;
        heightContent.constant = height;
        cellHeight += Float(div);
    }
}
