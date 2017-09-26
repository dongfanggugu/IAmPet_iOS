//
//  OtherTalkCell.swift
//  IAmPet
//
//  Created by changhaozhang on 2017/9/26.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

import Foundation

class OtherTalkCell : UITableViewCell, Nibloadable
{
    
    typealias playVideoBlock = (String) -> ();
    typealias clickPhotos = (UIImage) -> Void;
    
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
            if (oldValue?.type == mediaContent?.type)
            {
                updateMediaView();
            }
            else
            {
                addMediaView();
            }
        }
    }
    
    //cell identifier
    static let identifier = "other_talk_cell";
    
    var cellHeight: Float = 120;    //cellHeight
    
    var playVideo: playBlock?   //播放视频
    
    var showPhoto: clickPhotos?
    
    class func cellFromNib() -> OtherTalkCell
    {
        return OtherTalkCell.loadNib();
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
    private func resetMediaHeight(height: CGFloat) -> Void
    {
        let preHeight = heightMedia.constant;
        heightMedia.constant = height;
        cellHeight += Float(height - preHeight);
    }
    
    /**
     更新多媒体View
     */
    private func updateMediaView() -> Void
    {
        let type = mediaContent!.type;
        if (MediaContent.picture == type)
        {
            updatePhotosView();
        }
        else if (MediaContent.voice == type)
        {
        }
        else if (MediaContent.video ==  type)
        {
        }
    }
    
    /**
     更新图片view
     */
    private func updatePhotosView() -> Void
    {
        let photosView = viewMedia.subviews[0] as? PhotosShowView;
        photosView?.urlsImage = mediaContent?.urls;
        resetMediaHeight(height: photosView!.frame.size.height);
    }
    
    /**
     更新语音view
     */
    private func updateVoiceView() -> Void
    {
        let voiceView = viewMedia.subviews[0] as? VoiceShowView;
        voiceView?.urlStr = mediaContent?.urls[0];
    }
    
    /**
     更新视频view
     */
    private func updateVideoView() -> Void
    {
        let videoView = viewMedia.subviews[0] as? VideoShowView;
        videoView?.videoUrl = mediaContent?.urls[0];
    }
    
    /**
     添加多媒体view
     
     - parameter media: media
     */
    private func addMediaView() -> Void
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
                                 width: ScreenWidth - 16,
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
                                 width: ScreenWidth - 16,
                                 height: ScreenWidth - 16);
        weak var weakSelf = self;
        videoView.play = {(videoUrl) -> () in
            weakSelf?.playVideo?(videoUrl);
        };
        viewMedia.addSubview(videoView);
        return ScreenWidth - 16;
    }
    
    /**
     添加图片View
     
     - returns: veiw height
     */
    private func addPhotosView() -> CGFloat
    {
        let frame = CGRect(x: 0,
                           y: 0,
                           width: ScreenWidth - 16,
                           height: ScreenWidth - 16);
        let photosView = PhotosShowView(frame:frame);
        photosView.urlsImage = mediaContent?.urls;
        
        weak var weakSelf = self;
        photosView.clickImage = { (image: UIImage) -> Void in
            weakSelf?.showPhoto?(image);
        };
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
