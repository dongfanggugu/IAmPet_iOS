//
//  StringExtension.swift
//  IAmPet
//
//  Created by changhaozhang on 2017/9/29.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

import Foundation

extension String
{
    /*
     *去掉首尾空格
     */
    var removeHeadAndTailSpace:String
    {
        let whitespace = NSCharacterSet.whitespaces
        return self.trimmingCharacters(in: whitespace)
    }
    /*
     *去掉首尾空格 包括后面的换行 \n
     */
    var removeHeadAndTailSpacePro:String
    {
        let whitespace = NSCharacterSet.whitespacesAndNewlines
        return self.trimmingCharacters(in: whitespace)
    }
    /*
     *去掉所有空格
     */
    var removeAllSpace: String
    {
        return self.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
    }
    /*
     *去掉首尾空格 后 指定开头空格数
     */
    func beginSpaceNum(num: Int) -> String
    {
        var beginSpace = ""
        for _ in 0..<num
        {
            beginSpace += " "
        }
        return beginSpace + self.removeHeadAndTailSpacePro
    }
    
    /**
     去除空白字符,包含空格和unicode8198的空白
     
     - parameter text: text
     
     - returns: text
     */
    var removeInputHightLightSpace: String
    {
        let strNoWhiteSpace = self.removeAllSpace;
        return strNoWhiteSpace.removePinyinHightLightSpace;
    }
    
    //拼音输入时，去除高亮部分空格
    var removePinyinHightLightSpace: String
    {
        //Unicode 8198
        let str8198 = " ";
        return self.replacingOccurrences(of: str8198, with: "");
    }
}
