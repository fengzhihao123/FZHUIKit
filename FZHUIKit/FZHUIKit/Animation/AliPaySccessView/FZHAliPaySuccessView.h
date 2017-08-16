//
//  FZHAliPaySuccessView.h
//  FZHUIKit
//
//  Created by 冯志浩 on 2017/8/16.
//  Copyright © 2017年 冯志浩. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^AnimationCompleteBlock)();
@interface FZHAliPaySuccessView : UIView
- (instancetype)initWithFrame:(CGRect)frame animationCompleteBlock:(AnimationCompleteBlock)animationCompleteBlock;
@end
