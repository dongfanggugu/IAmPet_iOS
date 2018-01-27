//
//  InfoInputModifyViewController.swift
//  IAmPet
//
//  Created by 长浩 张 on 2018/1/27.
//  Copyright © 2018年 changhaozhang. All rights reserved.
//

import Foundation
class InfoInputModifyViewController: BaseViewController
{
    @IBOutlet private weak var tfValue: UITextField!;
    
    @IBOutlet private weak var btnSubmit: UIButton!;
    
    var value: String?

    var type: String?
    
    var typeDes: String?
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        if let typeDes = typeDes
        {
            setNavTitle(typeDes);
        }
        initView();
    }
    
    private func initView()
    {
        btnSubmit.layer.masksToBounds = true;
        btnSubmit.layer.cornerRadius = 5;
        btnSubmit.layer.borderWidth = 1;
        btnSubmit.layer.borderColor = Utils.getColorByRGB(Color_Main).cgColor;
        btnSubmit.setTitleColor(Utils.getColorByRGB(Color_Main), for: .normal);
        
        if let value = value
        {
            tfValue.text = value;
        }
    }
    
    @IBAction func submit()
    {
        if let newValue = tfValue.text
        {
            if let value = value
            {
                if (newValue == value)
                {
                    self.showAlertMsg("新的信息和之前信息相同", dismiss: nil);
                    return;
                }
            }
            
            if (newValue.isEmpty)
            {
                self.showAlertMsg("信息不能为空", dismiss: nil);
                return;
            }
            modifyUser(newValue);
        }
        else
        {
            self.showAlertMsg("信息不能为空", dismiss: nil);
            return;
        }
    }

    private func modifyUser(_ newValue: String)
    {
        if let type = type
        {
            var params = [String: Any]();
            params["type"] = type;
            params["value"] = newValue;
            HttpClient.share().fgPost("modifyUser", parameters: params, success: { (task,response) in
                self.updateUserInfo(property: type, value: newValue);
                self.showAlertMsg("成功", dismiss: {
                    self.navigationController?.popViewController(animated: true);
                });
            }) { (task, err) in
                
            };
        }
    }
    
    private func updateUserInfo(property: String, value: String)
    {
        let user = User.shareConfig();
        user?.setValue(value, forKey: property);
    }
}
