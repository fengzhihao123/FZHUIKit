//
//  FZHAddressPickerView.h
//  FZHUIKit
//
//  Created by 冯志浩 on 2017/8/8.
//  Copyright © 2017年 冯志浩. All rights reserved.
//


#import <UIKit/UIKit.h>
typedef void (^FZHPickerViewCompletionBlock)(NSString *text);
@interface FZHAddressPickerView : UIView

+ (instancetype)initPickViewWithFrame:(CGRect)frame completeAction:(FZHPickerViewCompletionBlock)completeAction;
@end
