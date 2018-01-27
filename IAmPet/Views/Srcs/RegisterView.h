//
//  RegisterView.h
//  IAmPet
//
//  Created by changhaozhang on 2017/9/12.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNibView.h"

@class RegisterView;

@protocol RegisterViewDelegate <NSObject>

- (void)onRegister:(RegisterView *)view user:(NSString *)user password:(NSString *)pwd;

- (void)onLogin:(RegisterView *)view user:(NSString *)user password:(NSString *)pwd;

- (void)onLogout:(RegisterView *)view;

@end

@interface RegisterView : BaseNibView

/**
 *  获取RegisterView
 *
 *  @return RegisterView
 */
+ (instancetype)viewFromNib;

@property (nonatomic, weak) id<RegisterViewDelegate> delegate;

@end
