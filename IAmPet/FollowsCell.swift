//
//  FollowsCell.swift
//  IAmPet
//
//  Created by 长浩 张 on 2017/10/3.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

import Foundation

class FollowsCell: UITableViewCell, Nibloadable
{
    typealias clickConcern = () -> Void;
    
    @IBOutlet private weak var ivHead: UIImageView!;
    
    @IBOutlet private weak var lbName: UILabel!;
    
    @IBOutlet private weak var lbTalk: UILabel!;
    
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
    
    var talk: String?  //简介
    {
        didSet
        {
            lbTalk.text = talk;
        }
    }
    
    var changeConcern: clickConcern?;
    
    static let identifier = "follows_cell";   //cell reuse identifier
    
    static let cellHeight: CGFloat = 66;   //cell height
    
    override func awakeFromNib()
    {
        super.awakeFromNib();
        
        self.selectionStyle = .none;
        cornerIvHead();
        addConcernButtonListener();
    }
    
    /**
     make concern ivHead corner radius
     */
    private func cornerIvHead()
    {
        ivHead.layer.masksToBounds = true;
        ivHead.layer.cornerRadius = 25;
    }
    
    /**
     add concern button listener
     */
    private func addConcernButtonListener()
    {
        btnConcern.addTarget(self, action: #selector(onClickConcern), for: .touchUpInside);
    }
    
    /**
     on click concern button
     */
    @objc private func onClickConcern()
    {
        changeConcern?();
    }
}
