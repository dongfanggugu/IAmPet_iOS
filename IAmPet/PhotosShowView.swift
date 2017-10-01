//
//  PhotosShowView.swift
//  IAmPet
//
//  Created by changhaozhang on 2017/9/25.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

import Foundation


class PhotosShowView: UIView
{
    typealias clickBlock = (UIImage) -> Void;
    
    let MaxImage = 3;   //最大图片数
    
    let PhotoColumn = 3;    //每行图片数量
    
    let WidthHeightScale = 1.3;   //图片宽高比
    
    var urlsImage: [String]?
    {
        didSet
        {
            updateViews();
        }
    }

    var clickImage: clickBlock?
    
    private var imageViews: [UIImageView]? = [];    //添加的UIImageViews
    
    override init(frame: CGRect)
    {
        super.init(frame: frame);
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     更新view
     */
    private func updateViews() 
    {
        if (MaxImage == imageViews!.count)
        {
            updateImageViews();
        }
        else
        {
            addImageViews();
        }
    }
    
    /**
     更新图片
     */
    private func updateImageViews() 
    {
        updateImagesVisible();
    }
    
    /**
     设置显示的图片
     */
    private func bindImage(index: Int) 
    {
        let imageView = imageViews![index];
        imageView.bindUrlData(url: urlsImage?[index])
        imageView.isHidden = false;
        imageViewClickListener(imageView: imageView);
        showImage(imageView: imageView);
    }
    
    /**
     更新图片的可见
     */
    private func updateImagesVisible() 
    {
        for i in 0..<MaxImage
        {
            if (i < urlsImage!.count)
            {
                bindImage(index: i);
            }
            else
            {
                imageViews?[i].isHidden = true;
            }
        }
        resetFrame();
    }
    
    /**
     重置frame
     */
    private func resetFrame() 
    {
        let frame = CGRect(x: self.frame.origin.x,
                           y: self.frame.origin.y,
                           width: self.frame.size.width,
                           height: calViewHeight());
        self.frame = frame;
    }
    
    /**
     添加 ImageView
     
     - parameter urls: urls
     */
    private func addImageViews() 
    {
        for i in 0..<MaxImage
        {
            let frame = calImageViewFrame(index: i);
            let imageView = UIImageView(frame: frame);
            imageView.isHidden = true;
            imageViews?.append(imageView);
            addSubview(imageView);
        }
        updateImagesVisible();
    }
    
    /**
     获取图片宽度
     
     - parameter frame: frame
     
     - returns: width
     */
    private func getImageViewWidth() -> CGFloat
    {
        return self.frame.size.width / CGFloat(PhotoColumn);
    }
    
    /**
     计算自身 高度
     
     - returns: view height
     */
    private func calViewHeight() -> CGFloat
    {
        let count = min(urlsImage!.count, MaxImage);
        let rows = Int(ceil(Float(count) / Float(PhotoColumn)));
        let width = getImageViewWidth();
        let height = width / CGFloat(WidthHeightScale);
        return CGFloat(rows) * height;
    }
    
    /**
     根据index返回image view的frame
     
     - parameter index: index
     
     - returns: imageView frame
     */
    private func calImageViewFrame(index: Int) -> CGRect
    {
        let row = index / PhotoColumn;
        let column = index % PhotoColumn;
        
        
        let width = getImageViewWidth();
        let height = width / CGFloat(WidthHeightScale);
        
        let x = CGFloat(column) * width;
        let y = CGFloat(row) * height;
        
        return CGRect(x: x,
                      y: y,
                      width: width,
                      height: height);
    }
    
    /**
     显示所有图片
     */
    private func showImages() 
    {
        let end = min(urlsImage!.count, MaxImage);
        for i in 0..<end
        {
            showImage(imageView: imageViews![i]);
        }
    }
    
    /**
     显示图片
     */
    private func showImage(imageView: UIImageView?) 
    {
        let url = imageView?.getUrlData();
        let fileName = self.getImageName(url: url!);
        
        if (HHUtils.imageFileExist(name: fileName))
        {
            self.showExistImage(fileName: fileName!, imageView: imageView!);
            return;
        }
        
        let urlRequest = URLRequest(url: URL(string: url!)!, timeoutInterval: 60);
        let placeHolder: UIImage? = UIImage(named: "icon_img");
        
        imageView?.setImageWith(urlRequest, placeholderImage: placeHolder, success: {
            (request, response, image) -> Void in
            self.imageCache(imageView: imageView!, image: image);
        }, failure: {(request, response, error) -> Void in
            print(error);
        });
    }
    
    /**
     设置图片缓存，并设置imageview
     
     - parameter imageView: imageView
     - parameter image:     image
     */
    private func imageCache(imageView: UIImageView, image: UIImage) 
    {
        DispatchQueue.global().async {
            let url = imageView.getUrlData();
            let fileName = self.getImageName(url: url!);
            let imagePath = HHUtils.saveImage(image: image, name: fileName);
            imageView.bindSourceImage(source: imagePath);
            let thumbnail = self.getThumbnail(image: image);
            DispatchQueue.main.async {
                imageView.image = thumbnail;
            }
        };
    }
    
    /**
     显示已经存在的图片
     
     - parameter imageView: imageView
     */
    private func showExistImage(fileName: String, imageView: UIImageView) 
    {
        DispatchQueue.global().async {
            let path = NSHomeDirectory().appending("/tmp/").appending(fileName);
            
            guard let image = UIImage(contentsOfFile: path) else
            {
                return
            }
            imageView.bindSourceImage(source: path);
            let thumbnail = self.getThumbnail(image: image);
            DispatchQueue.main.async {
                imageView.image = thumbnail;
            }
        };
    }
    
    /**
     裁剪图片
     
     - parameter image: image
     
     - returns: after clip
     */
    private func getThumbnail(image: UIImage) -> UIImage
    {
        let width = getImageViewWidth();
        let height = width / CGFloat(WidthHeightScale);
        let size = CGSize(width: width, height: height);
        
        return ImageUtils.image(with: image, scaledTo: size);
    }
    
    /**
     通过图片的url获取文件名称
     
     - parameter url: url
     
     - returns: image name
     */
    private func getImageName(url: String) -> String?
    {
        let arrayStr = url.components(separatedBy: "/");
        return arrayStr.last;
    }
    
    
    /**
     添加UIImageView click listener

     - parameter imageView: imageView
     */
    func imageViewClickListener(imageView: UIImageView?) 
    {
        imageView?.isUserInteractionEnabled = true;
        let recognizer = UITapGestureRecognizer();
        recognizer.addTarget(self, action: #selector(clickImageView(sender:)));
        imageView?.addGestureRecognizer(recognizer);
    }
    
    /**
     点击图片回调，不希望暴露给其他类调用，@objc private
     
     - parameter sender: sender
     */
    @objc private func clickImageView(sender: UIGestureRecognizer) 
    {
        let imageView = sender.view as? UIImageView;
        let filePath = imageView?.getSourceImage();
        if let image = UIImage(contentsOfFile: filePath!)
        {
            clickImage?(image);
        }
    }
}

// MARK: - UIImageView添加动态绑定数据支持
extension UIImageView
{
    /**
     给UIImageView绑定url数据
     
     - parameter url: url
     */
    func bindUrlData(url: String?) -> Void
    {
        bindData(key: "url", data: url!);
    }
    
    
    /**
     获取UIImageView绑定的url数据
     
     - returns: url data
     */
    func getUrlData() -> String?
    {
        return getBindData(key: "url") as? String;
    }
    
    /**
     绑定原图数据
     
     - parameter source: source image
     */
    func bindSourceImage(source: String?) -> Void
    {
        bindData(key: "sourceImage", data: source!);
    }
    
    /**
     获取原图数据
     
     - returns: source image path
     */
    func getSourceImage() -> String?
    {
        return getBindData(key: "sourceImage") as? String;
    }
    
    /**
     绑定数据
     
     - parameter key:  key
     - parameter data: data
     */
    private func bindData(key: String, data: Any?) -> Void
    {
        let keyHash: UnsafeRawPointer! =  UnsafeRawPointer.init(bitPattern:key.hashValue);
        objc_setAssociatedObject(self, keyHash, data!, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    
    /**
     获取绑定的数据 
     
     - parameter key: key
     
     - returns: data
     */
    private func getBindData(key: String) -> Any?
    {
        let keyHash: UnsafeRawPointer! =  UnsafeRawPointer.init(bitPattern:key.hashValue);
        return objc_getAssociatedObject(self, keyHash);
    }
}
