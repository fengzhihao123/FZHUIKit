//
//  FZHAutoLayoutHeightLabel.h
//  FZHUIKit
//
//  Created by 冯志浩 on 2017/8/4.
//  Copyright © 2017年 冯志浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FZHAutoLayoutHeightLabel : UILabel
@property (nonatomic, assign) CGSize currentSize;
//- (instancetype)initAutoLayoutLabelWithFrame:(CGRect)frame text:(NSString *)text;
+ (instancetype)initAutoLayoutLabelWithFrame:(CGRect)frame text:(NSString *)text;

@end
