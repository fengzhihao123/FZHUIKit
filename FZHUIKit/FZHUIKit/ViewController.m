//
//  ViewController.m
//  FZHUIKit
//
//  Created by 冯志浩 on 2017/8/4.
//  Copyright © 2017年 冯志浩. All rights reserved.
//

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define screenH [UIScreen mainScreen].bounds.size.height
#import "ViewController.h"
#import "FZHAutoLayoutHeightLabel.h"
#import "FZHAddressPickerView.h"
#import "FZHSearchBarView.h"
#import "FZHPlaceholderTextView.h"
#import "SubViewController.h"
#import "FZHDatePickerView.h"
#import "FZHAliPaySuccessView.h"
static NSString *str = @"之所以在这里做if判断 这个操作：是因为一个 if 可能避免一个耗时的copy，还是很划算的。 (在刚刚讲的：《如何让自己的类用 copy 修饰符？》里的那种复杂的copy，我们可以称之为 “耗时的copy”，但是对 NSString 的 copy 还称不上。)但是你有没有考虑过代价：你每次调用 setX: 都会做 if 判断，这会让 setX: 变慢，如果你在 setX:写了一串复杂的 if+elseif+elseif+... 判断，将会更慢。要回答“哪个效率会高一些？”这个问题，不能脱离实际开发，就算 copy 操作十分耗时，if 判断也不见得一定会更快，除非你把一个“ @property他当前的值 ”赋给了他自己，代码看起来就像：";
@interface ViewController ()
@property (nonatomic, strong) FZHSearchBarView *fzhSearchView;
@property (nonatomic, strong) FZHAddressPickerView *pickerView;
@property (nonatomic, strong) FZHDatePickerView *datePickerView;

@end
#warning 内存泄漏和循环引用？
#warning dealloc调用时间？
@implementation ViewController
- (IBAction)click:(UIButton *)sender {
    [_datePickerView showDatePickerView];
//    [_pickerView showAddressPickerView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Root";
//    [self setupDatePickerView];
//    [self setupAddressPickView];
}

- (void)setupAlipayView {
    FZHAliPaySuccessView *view = [[FZHAliPaySuccessView alloc]initWithFrame:CGRectMake(100, 200, 40, 40) animationCompleteBlock:^{
        NSLog(@"complete");
    }];
    [self.view addSubview:view];
}

- (void)setupDatePickerView {
    _datePickerView = [[FZHDatePickerView alloc]initFZHDatePickerViewWithFrame:CGRectMake(0, 0, ScreenW, 300) currentSuperView:self.view datePickerBlokc:^(NSString *dateString) {
        NSLog(@"%@", dateString);
    }];
}

- (void)setupTextView {
    FZHPlaceholderTextView *textView = [[FZHPlaceholderTextView alloc]initWithFrame:CGRectMake(100, 200, 200, 300)];
    textView.font = [UIFont systemFontOfSize:25];
    textView.backgroundColor = [UIColor blueColor];
    textView.placeholder = @"placeholder hello world";
    [self.view addSubview:textView];
}

- (void)setupAddressPickView {
    _pickerView = [FZHAddressPickerView initPickViewWithFrame:CGRectMake(0, 0, ScreenW, 300) currentSuperView:self.view separator:@"-" completeAction:^(NSString *text) {
        NSLog(@"%@",text);
    }];
}

- (void)setupAutoLayoutLabel {
    FZHAutoLayoutHeightLabel *label = [FZHAutoLayoutHeightLabel initAutoLayoutLabelWithFrame:CGRectMake(50, 50, 300, 0) text:str];
    NSLog(@"width: %f, height: %f", label.currentSize.width, label.currentSize.height);
    [self.view addSubview:label];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self.navigationController pushViewController:[[SubViewController alloc]init] animated:YES];
    [self setupAlipayView];
}

@end
