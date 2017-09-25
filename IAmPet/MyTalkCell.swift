//
//  MyTalkCell.swift
//  IAmPet
//
//  Created by changhaozhang on 2017/9/22.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

import Foundation

typealias playVideoBlock = (String) -> ();

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
    
    var cellHeight: Float = 120;    //cellHeight
    
    var playVideo: playBlock?   //播放视频
    
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
        cleanMediaView();
        var height: CGFloat?;
        let type = mediaContent?.type;
        if (type! == MediaContent.voice)
        {
            height = addVoiceView();
        }
        else if (type! == MediaContent.video)
        {
            height = addVideoView();
        }
        else if (type! == MediaContent.picture)
        {
            height = addPhotosView();
        }
        
        resetMediaHeight(height: height!);
    }
    
    /**
     添加语言view
     
     - returns: view height
     */
    private func addVoiceView() -> CGFloat
    {
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
     添加视频view
     
     - returns: view height
     */
    private func addVideoView() -> CGFloat
    {
        let videoView = VideoShowView.loadNib();
        videoView.videoUrl = mediaContent?.urls[0];
        videoView.frame = CGRect(x: 0,
                                 y: 0,
                                 width: ScreenWidth - 32,
                                 height: ScreenWidth - 32);
        videoView.play = {(videoUrl) -> () in
           self.playVideo?(videoUrl);
        };
        viewMedia.addSubview(videoView);
        return ScreenWidth - 32;
    }
    
    /**
     添加图片View
     
     - returns: veiw height
     */
    private func addPhotosView() -> CGFloat
    {
        let frame = CGRect(x: 16,
                           y: 0,
                           width: ScreenWidth - 32,
                           height: ScreenWidth - 32);
        let urls = [
            "https://gss2.bdstatic.com/-fo3dSag_xI4khGkpoWK1HF6hhy/baike/c0%3Dbaike80%2C5%2C5%2C80%2C26/sign=9cb489038bd4b31ce4319ce9e6bf4c1a/8c1001e93901213f6e57dc9c54e736d12f2e950e.jpg",
            "http://image.tianjimedia.com/uploadImages/2016/336/11/265T705PHEN4.jpg",
            "http://image.tianjimedia.com/uploadImages/2015/131/29/1OZRZ52WJ9T2.jpg",
            "http://image.tianjimedia.com/uploadImages/2015/131/22/59SG53FU0160.jpg"
            ];
        let photosView = PhotosShowView(frame:frame, urls: urls);
        viewMedia.addSubview(photosView);
        return photosView.frame.size.height;
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
