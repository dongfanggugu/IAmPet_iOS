//
//  VoiceShowView.swift
//  IAmPet
//
//  Created by 长浩 张 on 2017/9/23.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

import Foundation
import AVFoundation

class VoiceShowView: UIView, Nibloadable, AVAudioPlayerDelegate
{
    @IBOutlet private weak var btnPlay: UIButton!;
    
    @IBOutlet private weak var viewVoice1: UIButton!;
    @IBOutlet private weak var viewVoice2: UIButton!;
    @IBOutlet private weak var viewVoice3: UIButton!;
    @IBOutlet private weak var viewVoice4: UIButton!;
    @IBOutlet private weak var viewVoice5: UIButton!;
    @IBOutlet private weak var viewVoice6: UIButton!;
    
    private var arrayView: [UIView]
    {
        get
        {
            return [viewVoice1, viewVoice2, viewVoice3, viewVoice4, viewVoice5, viewVoice6];
        }
    }
    
    var urlStr: String?;
    var voiceTimer: Timer?;
    var player: AVAudioPlayer?;
    
    override func awakeFromNib()
    {
        super.awakeFromNib();
    }
    
    /**
     播放语音
     
     - parameter sender: sender
     */
    @IBAction func playVoice(_ sender: Any)
    {
        let url = URL(string: urlStr!);
        if (nil == url)
        {
            return;
        }
        
        if (nil == player)
        {
            do
            {
                player = try AVAudioPlayer(contentsOf:url!);
                player?.isMeteringEnabled = true;
                player?.delegate = self;
            }
            catch
            {
                print("Error");
            }
        }
        
        if (true == player?.isPlaying)
        {
            player?.stop()
            stopTimer();
        }
        player?.play();
        startTimer();
    }
    
    /**
     启动定时器
     */
    func startTimer()
    {
        voiceTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(detectPlayVoice), userInfo: nil, repeats: true);
    }
    
    /**
     停止计时器
     */
    func stopTimer()
    {
        voiceTimer?.invalidate();
        voiceTimer = nil;
    }
    
    /**
     检测声音大小
     */
    func detectPlayVoice()
    {
        player?.updateMeters();
        let result = Int(pow(10, (player?.peakPower(forChannel: 1))! * 0.5) * 100);
        updateVoiceView(voiceValue: result)
    }
    
    /**
     更新音量显示
     
     - parameter voiceValue: voiceValue
     */
    func updateVoiceView(voiceValue: Int)
    {
        let value: Double = Double(voiceValue) / 9.0;
        showVoice(level:Int(ceil(value)));
    }
    
    /**
     显示音量
     
     - parameter level: level
     */
    func showVoice(level: Int)
    {
        for i in 0 ..< arrayView.count
        {
            if (i < level)
            {
                arrayView[i].isHidden = false;
            }
            else
            {
                arrayView[i].isHidden = true;
            }
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool)
    {
        stopTimer();
        showVoice(level: 6);
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?)
    {
        stopTimer();
    }
    
    deinit
    {
        print("voice show view deinit");
    }
    
}
