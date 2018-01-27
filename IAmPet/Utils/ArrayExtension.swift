//
//  ArrayExtends.swift
//  IAmPet
//
//  Created by changhaozhang on 2017/10/26.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

import Foundation

extension Array
{
    mutating func addElementFrom(array: Array)
    {
        for element in array
        {
            self.append(element);
        }
    }
}
