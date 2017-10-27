//
//  AreaHeaderView.swift
//  IAmPet
//
//  Created by changhaozhang on 2017/9/27.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

import Foundation

protocol AreaHeaderViewDelegate: class
{
    func initChooseView(_ view: AreaHeaderView, category: AreaHeaderCategory);
    
    func chooseView(_ view: AreaHeaderView, category: AreaHeaderCategory);
}

/**
 广场内容类别
 
 - Latest:  实时
 - Concern: 关注
 - DayHot:  当日热门
 - WeekHot: 本周热门
 */
enum AreaHeaderCategory
{
    case Latest, Concern, DayHot, WeekHot;
}

//MARK: - AreaHeaderView

class AreaHeaderView: UIView, Nibloadable
{
    @IBOutlet private weak var btnCur: UIButton!;
    
    @IBOutlet private weak var btnConcern: UIButton!;
    
    @IBOutlet private weak var btnDayHot: UIButton!;
    
    @IBOutlet private weak var btnWeekHot: UIButton!;
    
    var category: AreaHeaderCategory = .Latest;
    
    private var arrayBtn: [UIButton]?
    {
        return [btnCur, btnConcern, btnDayHot, btnWeekHot];
    };
    
    
    private var dicBtn: [UIButton: AreaHeaderCategory]?
    {
        return [
            btnCur: .Latest,
            btnConcern: .Concern,
            btnDayHot: .DayHot,
            btnWeekHot: .WeekHot
        ];
    };
    
    weak var delegate: AreaHeaderViewDelegate?
    
    override func awakeFromNib()
    {
        super.awakeFromNib();
        initStyle();
        addClickLister();
    }
    
    /**
     初始化控件风格
     
     - returns: void
     */
    private func initStyle()
    {
        initState();
    }
    
    /**
     初始化view
     
     - returns: Void
     */
    private func initState()
    {
        resetState();
        btnCur.setTitleColor(UIColor.black, for: .normal);
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews();
        delegate?.initChooseView(self, category: .Latest);
    }
    
    /**
     恢复选中状态 
     */
    private func resetState()
    {
        for btn in arrayBtn!
        {
            btn.setTitleColor(Utils.getColorByRGB(Color_Gray_Font), for: .normal);
        }
    }
    
    /**
     添加事件监听
     */
    private func addClickLister()
    {
        for btn in arrayBtn!
        {
            btn.addTarget(self, action: #selector(clickBtn(sender:)), for: .touchUpInside);
        }
    }
    
    @objc private func clickBtn(sender: UIButton)
    {
        resetState();
        sender.setTitleColor(UIColor.black, for: .normal);
        category = (dicBtn?[sender])!;
        delegate?.chooseView(self, category: category);
    }
    
//    func initView()
//    {
//        initState();
//    }
}
