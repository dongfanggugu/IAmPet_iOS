//
//  TalkFavorCell.swift
//  IAmPet
//
//  Created by changhaozhang on 2017/9/26.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

import Foundation

class TalkFavorCell: UITableViewCell, Nibloadable
{
    @IBOutlet private weak var ivHead: UIImageView!;
    
    @IBOutlet private weak var lbName: UILabel!;
    
    static let cellHeight = 50; //cell 高度
    
    static let identifier = "talk_favor_cell";  //cell reuse identifier
    
    var urlImgHead: String?     //头像url
    {
        didSet
        {
            loadHeadImage(urlStr: urlImgHead);
        }
    }
    
    var name: String?   //昵称
    {
        didSet
        {
            lbName.text = name;
        }
    }
    
    override func awakeFromNib() -> Void
    {
        super.awakeFromNib();
        self.selectionStyle = UITableViewCellSelectionStyle.none;
    }
    
    /**
     加载头像
     
     - parameter urlStr: urlStr
     */
    private func loadHeadImage(urlStr: String?) -> Void
    {
        guard let urlStr = urlStr else
        {
            return;
        }
        let url = URL(string: urlStr);
        ivHead.setImageWith(url!);
    }
}
