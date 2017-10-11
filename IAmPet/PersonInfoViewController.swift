//
//  PersonInfoViewController.swift
//  IAmPet
//
//  Created by changhaozhang on 2017/10/11.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

import Foundation

class PersonInfoViewController: SBaseViewController
{
    @IBOutlet private var ivHead: UIImageView!;
    
    @IBOutlet private var tvIntroduce: UITextView!;
    
//    override func loadView()
//    {
//        let frame = CGRect(x: 0,
//                           y: 0,
//                           width: ScreenWidth,
//                           height: ScreenHeight);
//        let scrollView = UIScrollView(frame: frame);
//        self.view = scrollView;
//    }
    override func awakeFromNib()
    {
        super.awakeFromNib();
        print(#function);
    }
    
    private func initView()
    {
        ivHead.layer.masksToBounds = true;
        ivHead.layer.cornerRadius = 25;
        
        tvIntroduce.isUserInteractionEnabled = false;
        tvIntroduce.isPagingEnabled = false;
        tvIntroduce.isScrollEnabled = false;
        tvIntroduce.isEditable = false;
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        initView();
    }
    
}
