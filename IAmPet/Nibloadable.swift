//
//  Nibloadable.swift
//  IAmPet
//
//  Created by changhaozhang on 2017/9/22.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

import Foundation

protocol Nibloadable
{
}

extension Nibloadable where Self : UIView
{
    static func loadNib(_ nibName: String? = nil) -> Self
    {
        return Bundle.main.loadNibNamed(nibName ?? "\(self)", owner: nil, options: nil)?.first as! Self;
    }
}
