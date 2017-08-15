//
//  UIColor+Hex.h
//  ShortShow
//
//  Created by 冯志浩 on 2017/6/26.
//  Copyright © 2017年 冯志浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)
+ (UIColor *) colorWithHexString:(NSString *)hex;
+ (UIColor *) colorWithHexValue: (NSInteger) hex;
@end
