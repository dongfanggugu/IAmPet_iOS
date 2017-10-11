//
//  LoginViewController.swift
//  IAmPet
//
//  Created by changhaozhang on 2017/10/11.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

import Foundation

class LoginViewController: SBaseViewController
{
    @IBOutlet private var tfPwd: UITextField!;
    
    @IBOutlet private var btnVisible: UIButton!;
    
    @IBOutlet private var btnLogin: UIButton!;
    
    private var pwdVisible: Bool?   //password visible
    {
        didSet
        {
            if (pwdVisible!)
            {
                tfPwd.isSecureTextEntry = false;
                tfPwd.keyboardType = .alphabet;
                btnVisible.setImage(UIImage(named: "close"), for: .normal);
            }
            else
            {
                tfPwd.isSecureTextEntry = true;
                btnVisible.setImage(UIImage(named: "icon_show_read"), for: .normal);
            }
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        initView();
    }
    
    /**
     initial view
     
     - returns: Void
     */
    private func initView()
    {
        self.view.backgroundColor = UIColor.white;
        pwdVisible = false;
        
        btnLogin.layer.masksToBounds = true;
        btnLogin.layer.cornerRadius = 5;
    }
    
    /**
     click password visible button
     */
    @IBAction func clickPwdVisibleBtn()
    {
        if (pwdVisible!)
        {
            pwdVisible = false;
        }
        else
        {
            pwdVisible = true;
        }
    }
    
    @IBAction func clickLoginBtn()
    {
        login(userName: "", pwd: "");
    }
    
    /**
     login with user name and password
     
     - parameter userName: user name
     - parameter pwd:      password
     */
    private func login(userName: String, pwd: String)
    {
        let controller = SideMenuViewController();
        UIApplication.shared.delegate?.window??.rootViewController = controller;
    }
}
