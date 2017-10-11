//
//  RegisterViewController.swift
//  IAmPet
//
//  Created by changhaozhang on 2017/10/11.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

import Foundation

class RegisterViewController: SBaseViewController
{
    @IBOutlet private var tfPwd: UITextField!;
    
    @IBOutlet private var tfName: UITextField!;
    
    @IBOutlet private var btnVisible: UIButton!;
    
    @IBOutlet private var btnRegister: UIButton!;
    
    @IBOutlet private var btnClose: UIButton!;
    
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
        pwdVisible = false;
        
        initKeyboardType();
    }
    
    /**
     set input keyboard type as alphabet
     
     - returns: Void
     */
    private func initKeyboardType()
    {
        tfName.keyboardType = .alphabet;
        tfPwd.keyboardType = .alphabet;
        
        tfName.becomeFirstResponder();
    }
    
    /**
     click password visible button
     */
    @IBAction private func clickPwdVisibleBtn()
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
    
    /**
     close the page
     */
    @IBAction private func clickCloseBtn()
    {
        self.dismiss(animated: true, completion: nil);
    }
    
    /**
     click register button
     */
    @IBAction private func clickRegisterBtn()
    {
        if (checkNameInput(name: tfName.text!) && checkPwdInput(pwd: tfPwd.text!))
        {
            register(name: tfName.text!, pwd: tfPwd.text!);
        }
    }
    
    /**
     register
     */
    private func register(name: String, pwd: String)
    {
        print(#function);
    }
    
    /**
     check input name string
     
     - parameter name: name
     
     - returns: is correct
     */
    private func checkNameInput(name: String) -> Bool
    {
        if (name.isEmpty)
        {
            showAlertMsg("用户名不能为空", dismiss: nil);
            return false;
        }
        
        if (name.contains(" "))
        {
            showAlertMsg("用户名不能包含空格", dismiss: nil);
            return false;
        }
        
        if (name.characters.count > NameMaxLenght)
        {
            showAlertMsg("用户名长度不能大于\(NameMaxLenght)位", dismiss: nil);
            return false;
        }
        
        return true;
    }
    
    /**
     check password input string
     
     - parameter pwd: input password
     
     - returns: is correct
     */
    private func checkPwdInput(pwd: String) -> Bool
    {
        if (pwd.isEmpty)
        {
            showAlertMsg("密码不能为空", dismiss: nil);
            return false;
        }
        
        if (pwd.contains(" "))
        {
            showAlertMsg("密码不能包含空格", dismiss: nil);
            return false;
        }
        
        if (pwd.characters.count < PwdMinLenght)
        {
            showAlertMsg("密码长度不能小于\(PwdMinLenght)位", dismiss: nil);
            return false;
        }
        
        if (pwd.characters.count > PwdMaxLenght)
        {
            showAlertMsg("密码长度不能大于\(PwdMaxLenght)位", dismiss: nil);
            return false;
        }
        
        return true;
    }
}
