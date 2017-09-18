//
//  SearchViewController.h
//  IAmPet
//
//  Created by changhaozhang on 2017/9/15.
//  Copyright © 2017年 changhaozhang. All rights reserved.
//

#import "BaseViewController.h"

@protocol SearchViewControllerDelegate <NSObject>

- (void)clickNavLeft;

@end

@interface SearchViewController : BaseViewController

@property (nonatomic, weak) id<SearchViewControllerDelegate> delegate;

@end
