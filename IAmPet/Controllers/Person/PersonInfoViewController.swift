//
//  PersonInfoViewController.swift
//  IAmPet
//
//  Created by changhaozhang on 2017/10/11.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

import Foundation

class PersonInfoViewController: SBaseViewController, ImagePickerable
{
    @IBOutlet private var ivHead: UIImageView!;
    
    @IBOutlet private var tvIntroduce: UITextView!;
    
    @IBOutlet private var lbUserName: UILabel!;
    
    @IBOutlet private var lbPetsName: UILabel!;
    
    @IBOutlet private var lbBirthday: UILabel!;
    
    @IBOutlet private var lbOwnerName: UILabel!;
    
    @IBOutlet private var lbOwnerTel: UILabel!;
    
    @IBOutlet private var lbCategory: UILabel!;
    
    @IBOutlet private var lbVariety: UILabel!;

    @IBOutlet private var ivSex: UIImageView!;
    
    @IBOutlet private var btnVoice: UIButton!;
    
    private func initView()
    {
        self.automaticallyAdjustsScrollViewInsets = false;
        self.view.backgroundColor = UIColor.white;
        ivHead.layer.masksToBounds = true;
        ivHead.layer.cornerRadius = 25;
        
        tvIntroduce.isUserInteractionEnabled = false;
        tvIntroduce.isPagingEnabled = false;
        tvIntroduce.isScrollEnabled = false;
        tvIntroduce.isEditable = false;
        tvIntroduce.layer.masksToBounds = true;
        tvIntroduce.layer.cornerRadius = 5;
        
        //set initial value
        lbPetsName.text = "暂无";
        lbBirthday.text = "暂无";
        lbOwnerName.text = "暂无";
        lbOwnerTel.text = "暂无";
        lbCategory.text = "暂无";
        lbVariety.text = "暂无";
        tvIntroduce.text = "暂无";
        btnVoice.setImage(UIImage(named: "icon_voice"), for: .normal);
    }

    private func showInfo()
    {
        lbUserName.text = User.shareConfig().userName;
        if let petsName = User.shareConfig().petsName
        {
            lbPetsName.text = petsName;
        }
        
        if let birthday = User.shareConfig().birthday
        {
            lbBirthday.text = birthday;
        }
        
        if let ownerName = User.shareConfig().ownerName
        {
            lbOwnerName.text = ownerName;
        }
        
        if let ownerTel = User.shareConfig().ownerTel
        {
            lbOwnerTel.text = ownerTel;
        }
        
        if let category = User.shareConfig().category
        {
            lbCategory.text = category;
        }
        
        if let variety = User.shareConfig().variety
        {
            lbVariety.text = variety;
        }
        
        if let introduce = User.shareConfig().introduce
        {
            tvIntroduce.text = introduce;
        }
        
        if (0 == User.shareConfig().sex)
        {
            ivSex.image = UIImage(named: "fmale.png");
        }
        else
        {
            ivSex.image = UIImage(named: "male.png");
        }
        
        if let imgUrl = User.shareConfig().imgUrl
        {
            let url = URL(string: imgUrl)!;
            ivHead.setImageWith(url);
        }
        
        if let _ = User.shareConfig().voiceUrl
        {
            btnVoice.setImage(UIImage(named: "icon_voice2"), for: .normal);
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        setNavTitle("个人信息");
        initView();
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated);
        showInfo();
    }
    
    @IBAction func clickPetsName()
    {
        enterInputModify(type: "petsName", typeDes: "我的名字", value: User.shareConfig().petsName);
    }
    
    @IBAction func clickOwnerName()
    {
        enterInputModify(type: "ownerName", typeDes: "铲屎官", value: User.shareConfig().ownerName);
    }
    
    @IBAction func clickOwnerTel()
    {
        enterInputModify(type: "ownerTel", typeDes: "手机", value: User.shareConfig().ownerTel);
    }
    
    @IBAction func clickIntroduce()
    {
        
    }
    
    @IBAction func clickBirthday()
    {
        
    }
    
    @IBAction func clickCategory()
    {
        
    }
    
    @IBAction func clickVariety()
    {
        
    }
    
    @IBAction func clickIcon()
    {
        showPicker(sourceController: self);
    }
    
    @IBAction func clickSex()
    {
        
    }
    
    @IBAction func clickVoice()
    {
        
    }
    
    private func enterInputModify(type: String, typeDes: String, value: String?)
    {
        let controller = InfoInputModifyViewController();
        controller.type = type;
        controller.value = value;
        controller.typeDes = typeDes;
        controller.hidesBottomBarWhenPushed = true;
        self.navigationController?.pushViewController(controller, animated: true);
    }
}
