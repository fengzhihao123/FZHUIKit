//
//  FZHDatePickerView.m
//  FZHUIKit
//
//  Created by 冯志浩 on 2017/8/15.
//  Copyright © 2017年 冯志浩. All rights reserved.
//

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define screenH [UIScreen mainScreen].bounds.size.height

#import "FZHDatePickerView.h"
#import "UIView+Frame.h"
#import "UIColor+Hex.h"
@interface FZHDatePickerView()
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, copy) DatePickerBlock datePickerBlock;
@property (nonatomic, strong) UIView *currentSuperView;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, assign) CGRect currentFrame;
@property (nonatomic, assign) CGFloat animation;
@end

@implementation FZHDatePickerView
- (instancetype)initFZHDatePickerViewWithFrame:(CGRect)frame currentSuperView:(UIView *)currentSuperView datePickerBlokc:(DatePickerBlock)datePickerBlock {
    if (self = [super initWithFrame:frame]) {
        _animation = 1.0f;
        _datePickerBlock = datePickerBlock;
        _currentSuperView = currentSuperView;
        frame.origin.y = screenH;
        _currentFrame = frame;
        self.frame = frame;
        
        [self addSubview:self.confirmButton];
        [self addSubview:self.datePicker];
        [currentSuperView addSubview:self];
        self.backgroundColor = [UIColor colorWithHexString:@"#CAE1FF"];
    }
    return self;
}

#pragma mark - Animation
- (void)showDatePickerView {
    _currentFrame.origin.y = screenH - _currentFrame.size.height;
    [UIView animateWithDuration:_animation animations:^{
        self.frame = _currentFrame;
    }];
}

- (void)hideDatePickerView {
    _currentFrame.origin.y = screenH;
    [UIView animateWithDuration:_animation animations:^{
        self.frame = _currentFrame;
    }];
}

#pragma mark - 响应事件
- (void)confirmButtonClick {
    NSDate *date = _datePicker.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *string = [dateFormatter stringFromDate:date];
    self.datePickerBlock(string);
    [self hideDatePickerView];
}

#pragma mark - 初始化子控件
- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 50, self.fzhWidth, self.fzhHeight - 50)];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        _datePicker.minimumDate = [NSDate date];
        _datePicker.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    }
    return _datePicker;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [[UIButton alloc]initWithFrame:CGRectMake(self.fzhWidth - 80, 0, 40, 40)];
        [_confirmButton setTitle:@"确认" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}
@end
