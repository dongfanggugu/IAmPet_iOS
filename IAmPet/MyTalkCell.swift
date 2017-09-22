//
//  MyTalkCell.swift
//  IAmPet
//
//  Created by changhaozhang on 2017/9/22.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

import Foundation

class MyTalkCell : UITableViewCell, Nibloadable
{
    
    @IBOutlet weak var ivIcon: UIImageView!;
    
    @IBOutlet weak var lbName: UILabel!;
    
    @IBOutlet weak var lbTime: UILabel!;
    
    @IBOutlet weak var lbContent: UILabel!;
    
    @IBOutlet weak var heightContent: NSLayoutConstraint!;
    
    @IBOutlet weak var heightMedia: NSLayoutConstraint!;
    
    @IBOutlet weak var btnFavor: UIButton!;
    
    @IBOutlet weak var lbFavor: UILabel!;
    
    @IBOutlet weak var btnConment: UIButton!;
    
    @IBOutlet weak var lbConment: UILabel!;
    
    @IBOutlet weak var btnLikes: UIButton!;
    
    @IBOutlet weak var lbLikes: UILabel!;
    
    var myContext: NSObject!;
    
    var cellHeight : Float?;
    
    class func cellFromNib() -> MyTalkCell
    {
        return MyTalkCell.loadNib();
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib();
       
        myContext = NSObject();
        lbContent.addObserver(self, forKeyPath: "text", options: .new, context: &myContext);
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if (context == &myContext)
        {
            let newValue: String? = change?[NSKeyValueChangeKey.newKey];
            if (newValue != nil)
            {
                print("new value: \(newValue)");
            }
        }
        else
        {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context);
        }
    }
    
    
    deinit
    {
        lbContent.removeObserver(self, forKeyPath: "text");
    }
    
}
