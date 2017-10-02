//
//  FansCell.swift
//  IAmPet
//
//  Created by 长浩 张 on 2017/10/3.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

import Foundation

class FansCell: UITableViewCell, Nibloadable
{
    @IBOutlet private weak var ivHead: UIImageView!;
    
    @IBOutlet private weak var lbName: UILabel!;
    
    @IBOutlet private weak var lbIntroduce: UILabel!;
    
    @IBOutlet private weak var btnConcern: UIButton!;
    
    var imgHead: UIImage?   //头像
    {
        didSet
        {
            ivHead.image = imgHead;
        }
    }
    
    var nickName: String?   //昵称
    {
        didSet
        {
            lbName.text = nickName;
        }
    }
    
    var introduce: String?  //简介
    {
        didSet
        {
            lbIntroduce.text = introduce;
        }
    }
    
    var isConcerned: Bool? = false  //是否已关注
    {
        didSet
        {
            setConcernBtn();
        }
    }
    
    static let identifier = "fans_cell";   //cell reuse identifier
    
    static let cellHeight: CGFloat = 66;   //cell height
    
    /**
     set concern button's image
     */
    private func setConcernBtn()
    {
        if (isConcerned!)
        {
            btnConcern.setImage(UIImage(named: "icon_concerned"), for: .normal);
        }
        else
        {
            btnConcern.setImage(UIImage(named: "concern"), for: .normal);
        }
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib();
        
        self.selectionStyle = .none;
        cornerButton();
    }
    
    /**
     make concern button corner radius
     */
    private func cornerButton()
    {
        ivHead.layer.masksToBounds = true;
        ivHead.layer.cornerRadius = 25;
    }
    
}
