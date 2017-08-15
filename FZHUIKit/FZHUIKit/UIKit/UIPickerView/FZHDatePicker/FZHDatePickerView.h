//
//  FZHDatePickerView.h
//  FZHUIKit
//
//  Created by 冯志浩 on 2017/8/15.
//  Copyright © 2017年 冯志浩. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^DatePickerBlock)(NSString *dateString);
@interface FZHDatePickerView : UIView
- (instancetype)initFZHDatePickerViewWithFrame:(CGRect)frame
                              currentSuperView:(UIView *)currentSuperView
                               datePickerBlokc:(DatePickerBlock)datePickerBlock;
- (void)showDatePickerView;
- (void)hideDatePickerView;
@end
