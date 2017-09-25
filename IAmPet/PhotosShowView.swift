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
    let PhotoColumn = 3;    //每行图片数量
    
    let WidthHeightScale = 1;   //图片宽高比
    
    private var imageViews: [UIImageView]? = [];    //添加的UIImageViews
    
    init(frame: CGRect, urls: [String]?)
    {
        super.init(frame: frame);
        addImageViews(urls: urls);
//        showImages();
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     添加 ImageView
     
     - parameter urls: urls
     */
    private func addImageViews(urls: [String]?) -> Void
    {
        if (nil == urls)
        {
            return;
        }
        
        for i in 0..<urls!.count
        {
            let frame = calImageViewFrame(index: i);
            let imageView = UIImageView(frame: frame);
            imageView.bindUrlData(url: urls![i])
            imageViews?.append(imageView);
            showImage(imageView: imageView);
            addSubview(imageView);
        }
        
        let frame = CGRect(x: self.frame.origin.x,
                           y: self.frame.origin.y,
                           width: self.frame.size.width,
                           height: calViewHeight());
        self.frame = frame;
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
        let rows = Int(ceil(Float(imageViews!.count) / Float(PhotoColumn)));
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
    private func showImages() -> Void
    {
        for i in 0..<imageViews!.count
        {
            showImage(imageView: imageViews![i]);
        }
    }
    
    /**
     显示图片
     */
    private func showImage(imageView: UIImageView?) -> Void
    {
        let url = imageView?.getUrlData();
        let fileName = getImageName(url: url!);
        
        if (HHUtils.imageFileExist(name: fileName))
        {
            let path = NSHomeDirectory().appending("/tmp/").appending(fileName!);
            let image = UIImage(contentsOfFile: path);
            let thumbnail = getThumbnail(image: image!);
            imageView?.image = thumbnail;
            return;
        }
        
        let urlRequest = URLRequest(url: URL(string: url!)!, timeoutInterval: 60);
        let placeHolder: UIImage? = UIImage(named: "icon_img");
        
        imageView?.setImageWith(urlRequest, placeholderImage: placeHolder, success: {
            (request, response, image) -> Void in
            print("download successfully");
            let imagePath = HHUtils.saveImage(image: image, name: fileName);
            imageView?.bindSourceImage(source: imagePath);
            imageView?.image = self.getThumbnail(image: image);
        }, failure: {(request, response, error) -> Void in
            print(error);
        });
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
        bindData(key: "sourceImage", data: source);
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
