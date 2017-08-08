//
//  FZHAutoLayoutHeightLabel.m
//  FZHUIKit
//
//  Created by 冯志浩 on 2017/8/4.
//  Copyright © 2017年 冯志浩. All rights reserved.
//  自适应高度label

#import "FZHAutoLayoutHeightLabel.h"
#import "UIView+Frame.h"

@implementation FZHAutoLayoutHeightLabel

+ (instancetype)initAutoLayoutLabelWithFrame:(CGRect)frame text:(NSString *)text {
    return [[self alloc]initAutoLayoutLabelWithFrame:frame text:text];
}

- (instancetype)initAutoLayoutLabelWithFrame:(CGRect)frame text:(NSString *)text {
    if (self = [super initWithFrame:frame]) {
        self.text = text;
        self.numberOfLines = 0;
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        [self sizeToFit];
        _currentSize = self.fzhSize;
    }
    return self;
}

@end
