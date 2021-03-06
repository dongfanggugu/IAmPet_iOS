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
    @IBOutlet private var tfUser: UITextField!;
    
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
        tfPwd.keyboardType = .alphabet;
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
        let user = tfUser.text?.trimmingCharacters(in: .whitespacesAndNewlines);
        if ((user?.isEmpty)!)
        {
            showAlertMsg("请输入您的用户名", dismiss: nil);
        }
        let pwd = tfPwd.text;
        
        login(userName: user!, pwd: pwd!);
    }
    
    /**
     login with user name and password
     
     - parameter userName: user name
     - parameter pwd:      password
     */
    private func login(userName: String, pwd: String)
    {
        var params = [String: String]();
        params["userName"] = userName;
        params["password"] = Utils.md5(pwd);
        
        HttpClient.share().fgPost(URL_LOGIN, parameters: params, success: { (task, responseObject) in
            self.storeParams(responseObject as? [String: Any]);
            self.jumpMainpage();
        }) { (task, error) in
            let err = error as NSError?;
            self.showAlertMsg((err?.domain)!, dismiss: nil);
        };
    }
    
    /**
     store the params
     
     - parameter params: params
     */
    private func storeParams(_ response: [String: Any]?)
    {
        if let body = response?["body"] as? [String: Any]
        {
            User.shareConfig().userId = body["id"] as! String;
            User.shareConfig().accessToken = body["token"] as! String;
            User.shareConfig().userName = body["userName"] as! String;
            if let petsName = body["petsName"] as? String
            {
                User.shareConfig().petsName = petsName;
            }
            
            if let birthday = body["birthday"] as? String
            {
                User.shareConfig().birthday = birthday;
            }
            
            if let ownerName = body["ownerName"] as? String
            {
                User.shareConfig().ownerName = ownerName;
            }
            
            if let ownerTel = body["ownerTel"] as? String
            {
                User.shareConfig().ownerTel = ownerTel;
            }
            
            if let category = body["category"] as? String
            {
                User.shareConfig().category = category;
            }
            
            if let variety = body["variety"] as? String
            {
                User.shareConfig().variety = variety;
            }
            
            if let introduce = body["introduce"] as? String
            {
                User.shareConfig().introduce = introduce;
            }
            
            if let imgUrl = body["icon"] as? String
            {
                User.shareConfig().imgUrl = imgUrl;
            }
            
            if let voiceUrl = body["voice"] as? String
            {
                User.shareConfig().voiceUrl = voiceUrl;
            }
            
            if let sex = body["sex"] as? Int
            {
                User.shareConfig().sex = sex;
            }
        }
    }
    
    /**
     jump to the main page
     */
    private func jumpMainpage()
    {
        let controller = SideMenuViewController();
        UIApplication.shared.delegate?.window??.rootViewController = controller;
    }
    
    /**
     click regsiter button
     */
    @IBAction private func clickRegisterBtn()
    {
        register();
    }
    
    /**
     register
     */
    private func register()
    {
        let controller = RegisterViewController();
        self.present(controller, animated: true, completion: nil);
    }
    
}
