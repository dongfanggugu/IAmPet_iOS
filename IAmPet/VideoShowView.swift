//
//  VideoShowView.swift
//  IAmPet
//
//  Created by 长浩 张 on 2017/9/24.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

import Foundation
import AVFoundation

class VideoShowView: UIView, Nibloadable
{
    @IBOutlet private weak var ivImage: UIImageView!;
    
    @IBOutlet private weak var btnPlay: UIButton!;
    
    var videoUrl: String?
    {
        didSet
        {
            ivImage.getNetWorkVideoImage(url: videoUrl!);
        }
    }
}

extension UIImageView
{
    func getNetWorkVideoImage(url: String)
    {
        DispatchQueue.global().async {
//            let asset = AVURLAsset(url:URL(string: url)!);
            let asset = AVURLAsset(url: URL(fileURLWithPath: url));
            let generator = AVAssetImageGenerator(asset: asset);
            generator.appliesPreferredTrackTransform = true;
            
            let time = CMTimeMakeWithSeconds(0.0, 600);
            var actualTime = CMTimeMake(0, 0);
            var image: CGImage?;
            
            do
            {
                image = try generator.copyCGImage(at: time, actualTime: &actualTime);
                
            }
            catch let error as NSError
            {
                print(error);
            }
            if (image != nil)
            {
            
                DispatchQueue.main.async {
                    self.image = UIImage(cgImage: image!);
                }
            }
        };
    }
}
