//
//  MyTalkCell.swift
//  IAmPet
//
//  Created by changhaozhang on 2017/9/22.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

import Foundation

/**
 *  多媒体内容
 */
class MediaContent: NSObject
{
    static let voice = 1;
    
    static let picture = 2;
    
    static let video = 3;
    
    private(set) var type: Int?
    
    private(set) var urls: [String]!;   //内容url
    
    init(type: Int, urls: [String])
    {
        self.type = type;
        self.urls = urls;
    }
}

class MyTalkCell : UITableViewCell, Nibloadable
{
    
    @IBOutlet weak var ivIcon: UIImageView!;
    
    @IBOutlet weak var lbName: UILabel!;    //名字
    
    @IBOutlet weak var lbTime: UILabel!;    //日期
    
    @IBOutlet private weak var viewMedia: UIView!;  //多媒体view
    
    @IBOutlet weak var heightContent: NSLayoutConstraint!;
    
    @IBOutlet weak var heightMedia: NSLayoutConstraint!;
    
    @IBOutlet weak var btnFavor: UIButton!;
    
    @IBOutlet weak var lbFavor: UILabel!;
    
    @IBOutlet weak var btnConment: UIButton!;
    
    @IBOutlet weak var lbConment: UILabel!;
    
    @IBOutlet weak var btnLikes: UIButton!;
    
    @IBOutlet weak var lbLikes: UILabel!;
    
    @IBOutlet private weak var lbContent: UILabel!;
    
    //说说内容
    var talkContent: String?
    {
        didSet
        {
            lbContent.text = talkContent;
            resetContentHeight(content: talkContent!);
        }
    }
    //多媒体内容
    var mediaContent: MediaContent?
    {
        didSet
        {
            addMediaView();
        }
    }
    
    //cell identifier
    static let identifier = "my_talk_cell";
    
    //cell height
    var cellHeight: Float = 120
    
    class func cellFromNib() -> MyTalkCell
    {
        return MyTalkCell.loadNib();
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib();
        self.selectionStyle = .none;
        
        lbContent.numberOfLines = 0;
        lbContent.lineBreakMode = .byWordWrapping;
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews();
    }
    
    /**
     重新计算文字高度
     
     - parameter content: content
     */
    func resetContentHeight(content: String)
    {
        let font = UIFont.systemFont(ofSize: 14);
        let width = lbContent.frame.size.width;
        let height = HHUtils.getTextHeight(textStr: content, font: font, width: width);
        
        let div = height - heightContent.constant;
        heightContent.constant = height;
        cellHeight += Float(div);
    }
    
    /**
     重新计算多媒体view的高度
     
     - parameter height: height
     */
    func resetMediaHeight(height: CGFloat)
    {
        heightMedia.constant = height;
        cellHeight += Float(height);
    }
    
    /**
     添加多媒体view
     
     - parameter media: media
     */
    func addMediaView()
    {
        var height: CGFloat?;
        let type = mediaContent?.type;
        if (type == MediaContent.voice)
        {
            height = addVoiceView();
        }
        
        resetMediaHeight(height: height!);
    }
    
    /**
     添加语言view
     
     - returns: view height
     */
    private func addVoiceView() -> CGFloat
    {
        cleanMediaView();
        let voiceView = VoiceShowView.loadNib();
        voiceView.urlStr = mediaContent?.urls[0];
        voiceView.frame = CGRect(x: 0,
                                 y: 0,
                                 width: ScreenWidth - 32,
                                 height: voiceView.frame.size.height);
        viewMedia.addSubview(voiceView);
        
        return voiceView.frame.size.height;
    }
    
    /**
     清理media view
     */
    func cleanMediaView()
    {
        let array = viewMedia.subviews;
        for item in array
        {
            item.removeFromSuperview();
        }
        cellHeight -= Float(heightMedia.constant);
        heightMedia.constant = 0;
    }
    
    deinit
    {
        lbContent.removeObserver(self, forKeyPath: "text");
        print("MyTalkCell deinit");
    }
    
}
