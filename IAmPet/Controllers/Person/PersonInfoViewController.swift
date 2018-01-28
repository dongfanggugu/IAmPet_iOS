//
//  PersonInfoViewController.swift
//  IAmPet
//
//  Created by changhaozhang on 2017/10/11.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

import Foundation
import Photos

class PersonInfoViewController: SBaseViewController
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
        let author = PHPhotoLibrary.authorizationStatus();
        if (author == PHAuthorizationStatus.denied || author == PHAuthorizationStatus.restricted)
        {
            jumpToSettings();
            return;
        }
        showPicker();
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
    
    func chooseImage(_ image: UIImage)
    {
        let data = UIImageJPEGRepresentation(image, 1.0);
        HttpClient.share().uploadImage(data, url: URL_UPLOAD, success: { (task, response) in
            if let url = ((response as? [String: Any])?["body"] as? [String: Any])?["url"] as? String
            {
                self.modifyIcon(url: url, image: image);
            }
        }, failure: {(task, err) in
            
        });
    }
    
    func modifyIcon(url: String, image: UIImage)
    {
        var params = [String: Any]();
        params["type"] = "icon";
        params["value"] = url;
        HttpClient.share().fgPost("modifyUser", parameters: params, success: { (task,response) in
            self.updateIcon(url: url, image: image);
            self.showAlertMsg("头像更新成功", dismiss: {
            });
        }) { (task, err) in
            
        };
    }
    
    func updateIcon(url: String, image: UIImage)
    {
        self.ivHead.image = image;
        User.shareConfig().imgUrl = url;
    }
    
    func showPicker()
    {
        let controller = UIAlertController(title: "照片", message: nil, preferredStyle: .actionSheet);
        controller.addAction(UIAlertAction(title: "相册", style: .default, handler: {
            (action) in
            self.pickPhoto();
        }));
        controller.addAction(UIAlertAction(title: "拍摄", style: .default, handler: {
            (action) in
            self.takePhoto();
            
        }));
        controller.addAction(UIAlertAction(title: "取消", style: .cancel, handler: {
            (action) in
            
        }));
        self.present(controller, animated: true, completion: nil);
    }
    
    private func pickPhoto()
    {
        let picker = UIImagePickerController();
        picker.sourceType = .photoLibrary;
        picker.delegate = self;
        picker.allowsEditing = true;
        self.show(picker, sender: self);
    }
    
    private func takePhoto()
    {
        if (UIImagePickerController.isSourceTypeAvailable(.camera))
        {
            let picker = UIImagePickerController();
            picker.delegate = self;
            picker.allowsEditing = true;
            picker.sourceType = .camera;
            self.show(picker, sender: self);
        }
        else
        {
            print("设备不支持拍照");
        }
    }
}

extension PersonInfoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let type = info[UIImagePickerControllerMediaType] as? String
        {
            if (type == "public.image")
            {
                if let image = info[UIImagePickerControllerEditedImage] as? UIImage
                {
                    chooseImage(image);
                }
            }
        }
        picker.dismiss(animated: true, completion: nil);
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion: nil);
    }
}
