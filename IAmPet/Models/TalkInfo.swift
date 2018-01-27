//
//  TalkInfo.swift
//  IAmPet
//
//  Created by changhaozhang on 2017/10/25.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

import Foundation

class TalkInfo: Jastor
{
    var id = "";
    var user = "";
    var content = "";
    var createTime = "";
    var pictures = "";
    var voice = "";
    var video = "";
    var arrayPic: [String]
    {
        return pictures.components(separatedBy: ",");
    }
    var favorCount = 0;
    var likesCount = 0;
    var commentCount = 0;
    var favor = 0;
    var likes = 0;
    
//    override init?(dictionary: [AnyHashable: Any])
//    {
//        super.init(dictionary: dictionary);
//        genPictureArray();
//    }
//
//    required init?(coder aDecoder: NSCoder)
//    {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    /**
     return the MediaContent
     
     - returns: MediaContent
     */
    var mediaContent: MediaContent?
    {
        if (!(pictures.isEmpty))
        {
            return MediaContent(type: MediaContent.picture, urls: arrayPic);
        }
        if (!(voice.isEmpty))
        {
            return MediaContent(type: MediaContent.voice, urls: [voice]);
        }
        if (!(video.isEmpty))
        {
            return MediaContent(type: MediaContent.video, urls: [video]);
        }
        return nil;
    }
}
