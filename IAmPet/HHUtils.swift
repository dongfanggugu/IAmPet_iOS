//
//  HHUtils.swift
//  IAmPet
//
//  Created by changhaozhang on 2017/9/22.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

import Foundation

class HHUtils : NSObject
{
    
    /**
     监听键盘输入时还没有完成时字符(输入中文)，限制最大输入
     
     - parameter limt:      limit
     - parameter textView:  textView
     - parameter textRange: textRange
     - parameter text:      text
     
     - returns: bool
     */
    class func textViewLimitOnInput(_ limt: Int, textView: UITextView, textRange:  NSRange, text: String) -> Bool
    {
        let selectedRange: UITextRange? = textView.markedTextRange;
        
        if (selectedRange != nil)
        {
            let pos: UITextPosition? = textView.position(from: selectedRange!.start, offset: 0);
            if (pos != nil)
            {
                let startOffset: Int? = textView.offset(from: textView.beginningOfDocument, to: selectedRange!.start);
                let endOffset: Int? = textView.offset(from: textView.endOfDocument, to: selectedRange!.end);
                let offsetRange: NSRange = NSMakeRange(startOffset!, endOffset! - startOffset!);
                
                if (offsetRange.location < limt)
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
            
        }
        //获取高亮部分
        
        let comcatStr: String = (textView.text as NSString).replacingCharacters(in: textRange, with: text);
        
        let canInputLen: Int = limt - (comcatStr as NSString).length;
        
        if (canInputLen >= 0)
        {
            return true;
        }
        else
        {
            let len: Int = (text as NSString).length + canInputLen;
            
            let rg: NSRange = NSMakeRange(0, max(0, len));
            
            if (rg.length > 0)
            {
                let s : String = (text as NSString).substring(with: rg);
                
                textView.text = (textView.text as NSString).replacingCharacters(in: textRange, with: s);
            }
            
            return false;
        }
    }
    
    /**
     监听输入完成时动作，处理最大字数
     
     - parameter limit:    limit
     - parameter textView: UITextView
     - parameter label:    label
     */
    class func textViewLimitEndInput(_ limit: Int, textView: UITextView, label: UILabel)
    {
        let selectedRange: UITextRange? = textView.markedTextRange;
        
        //获取高亮部分
        if (selectedRange != nil)
        {
            let pos: UITextPosition? = textView.position(from:selectedRange!.start, offset: 0);
            
            //如果在变化中是高亮部分，就不计算字符了
            if (pos != nil)
            {
                return;
            }
        }
        
        let text: String = textView.text;
        let existTextNum : Int = (text as NSString).length;
        
        if (existTextNum > limit)
        {
            let s: String = (text as NSString).substring(to: limit);
            textView.text = s;
            label.text = String(format: "%i/%i", limit, limit);
        }
        else
        {
            label.text = String(format: "%i/%i", existTextNum, limit);
        }
    }
}
