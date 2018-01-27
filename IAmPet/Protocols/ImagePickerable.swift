//
//  ImagePickerable.swift
//  IAmPet
//
//  Created by 长浩 张 on 2018/1/28.
//  Copyright © 2018年 changhaozhang. All rights reserved.
//

import Foundation

protocol ImagePickerable:class
{
    func showPicker(sourceController: UIViewController);
}

extension ImagePickerable
{
    func showPicker(sourceController: UIViewController)
    {
        let controller = UIAlertController(title: "照片", message: nil, preferredStyle: .actionSheet);
        controller.addAction(UIAlertAction(title: "相册", style: .default, handler: {
            (action) in
            
        }));
        controller.addAction(UIAlertAction(title: "拍摄", style: .default, handler: {
            (action) in
            
        }));
        controller.addAction(UIAlertAction(title: "取消", style: .cancel, handler: {
            (action) in
            
        }));
        sourceController.present(controller, animated: true, completion: nil);
    }
    
    private func pickPhoto()
    {
        
    }
}
