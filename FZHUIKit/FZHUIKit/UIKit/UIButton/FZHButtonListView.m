//
//  FZHButtonListView.m
//  FZHUIKit
//
//  Created by 冯志浩 on 2017/8/21.
//  Copyright © 2017年 冯志浩. All rights reserved.
//  多个button单选
#define ButtonTag 1001
#import "FZHButtonListView.h"

@implementation FZHButtonListView {
    CGFloat _lastButtonTag; //默认选中第一个
    NSArray *_buttonArray;
}

- (instancetype)initWithFrame:(CGRect)frame buttonArray:(NSArray *)buttonArray {
    if (self = [super initWithFrame:frame]) {
        _buttonArray = buttonArray;
        _lastButtonTag = 1001;
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    CGFloat buttonW = self.frame.size.width/_buttonArray.count;
    
    for (int i = 0; i < _buttonArray.count; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(buttonW * i, 0, buttonW, 50)];
        button.tag = i + ButtonTag;
        [button setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            button.backgroundColor = [UIColor greenColor];
        } else {
            button.backgroundColor = [UIColor blackColor];
        }
        [self addSubview:button];
    }
}

- (void)buttonClick:(UIButton *)button {
    //修改上一次点击button 为normal
    UIButton *preButton = [self viewWithTag:_lastButtonTag];
    preButton.backgroundColor = [UIColor blackColor];
    //替换最近点击button tag
    _lastButtonTag = button.tag;
    //修改当前点击button为选中状态
    button.backgroundColor = [UIColor greenColor];
    
    if ([self.delegate respondsToSelector:@selector(buttonListViewCurrentButton:)]) {
        [self.delegate buttonListViewCurrentButton:button];
    }
    
}
@end
