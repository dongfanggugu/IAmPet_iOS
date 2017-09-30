//
//  ChatCell.swift
//  IAmPet
//
//  Created by changhaozhang on 2017/9/30.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

import Foundation

class ChatCell: UITableViewCell, Nibloadable
{
    @IBOutlet private var ivHead: UIImageView!;
    
    @IBOutlet private var lbName: UILabel!;
    
    @IBOutlet private var lbDate: UILabel!;
    
    @IBOutlet private var lbContent: UILabel!;
    
    var imgHead: UIImage?   //头像
    {
        didSet
        {
//            let circleImage = ImageUtils.circleImage(imgHead, borderWidth: 5, borderColor: Utils.getColorByRGB(Color_Main));
            ivHead.image = imgHead!;
        }
    };
    
    var nickName: String?   //昵称
    {
        didSet
        {
            lbName.text = nickName!;
        }
    }
    
    var date: String?   //日期
    {
        didSet
        {
            lbDate.text = date!;
        }
    }
    
    var chatContent: String?    //聊天内容
    {
        didSet
        {
            lbContent.text = chatContent!;
        }
    }
    
    static let cellHeight: CGFloat = 66;    //高度
    
    static let identifier = "chat_cell";    //reused identifier
    
    override func awakeFromNib()
    {
        super.awakeFromNib();
        
        ivHead.layer.masksToBounds = true;
        ivHead.layer.cornerRadius = 25;
    }
}
