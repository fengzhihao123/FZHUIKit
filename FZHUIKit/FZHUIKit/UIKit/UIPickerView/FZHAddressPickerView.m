//
//  FZHAddressPickerView.m
//  FZHUIKit
//
//  Created by 冯志浩 on 2017/8/8.
//  Copyright © 2017年 冯志浩. All rights reserved.
//  地址选择器

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define screenH [UIScreen mainScreen].bounds.size.height

#import "FZHAddressPickerView.h"
#import "UIView+Frame.h"
@interface FZHAddressPickerView() <
UIPickerViewDelegate,
UIPickerViewDataSource
>
//控件
@property (nonatomic, strong) UIPickerView *addressPickerView;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIView *separatorView;
@property (nonatomic, strong) UIView *currentSuperView;
@property (nonatomic, copy) FZHPickerViewCompletionBlock completeAction;
//属性
@property (nonatomic, copy) NSString *separator;
@property (nonatomic, copy) NSArray *provinceArray;
@property (nonatomic, copy) NSArray *cityArray;
@property (nonatomic, copy) NSArray *areaArray;
@property (nonatomic, copy) NSArray *totalArray;
@property (nonatomic, assign) NSInteger provinceRow;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, assign) CGRect currentFrame;
@end

@implementation FZHAddressPickerView
//类初始化方法
+ (instancetype)initPickViewWithFrame:(CGRect)frame currentSuperView:(UIView *)currentSuperView separator:(NSString *)separator completeAction:(FZHPickerViewCompletionBlock)completeAction{
    return [[self alloc]initPickViewWithFrame:frame currentSuperView:currentSuperView completeAction:completeAction separator:separator];
}
//实例初始化方法
- (instancetype)initPickViewWithFrame:(CGRect)frame currentSuperView:(UIView *)currentSuperView completeAction:(FZHPickerViewCompletionBlock)completeAction separator:(NSString *)separator {
    if (self = [super initWithFrame:frame]) {
        _completeAction = completeAction;
        _provinceRow = 0;
        _separator = separator;
        _currentSuperView = currentSuperView;
        _currentFrame = frame;
        self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        //初始化数据
        [self setupAddressData];
        //添加子控件
        [self addSubview:self.addressPickerView];
        [self addSubview:self.addressLabel];
        [self addSubview:self.confirmButton];
        [self addSubview:self.cancelButton];
        [self addSubview:self.separatorView];
    }
    return self;
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.provinceArray.count;
    } else if (component == 1) {
        return self.cityArray.count;
    } else {
        return self.areaArray.count;
    }
}

#pragma mark - UIPickerViewDelegate
//- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
//上面的方法pickerView 可以改变字体颜色，不能改变大小
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    titleLabel.textColor = [UIColor redColor];
    titleLabel.font = [UIFont systemFontOfSize:15];
    if (component == 0) {
        titleLabel.text = _provinceArray[row];
    } else if (component == 1) {
        titleLabel.text = _cityArray[row];
    } else {
        titleLabel.text = _areaArray[row];
    }
    return titleLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        [self setupCurrentCityDataWithRow:row];
        [self setupCurrentAreaDataWithProvinceRow:row cityRow:0];
        _provinceRow = row;
        
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView selectRow:0 inComponent:2 animated:YES];
        
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
        
        _province = _provinceArray[row];
        _city = _cityArray[0];
        _area = _areaArray[0];
    } else if (component == 1) {
        [self setupCurrentAreaDataWithProvinceRow:_provinceRow cityRow:row];
        [pickerView selectRow:0 inComponent:2 animated:YES];
        [pickerView reloadComponent:2];
        
        _city = _cityArray[row];
        _area = _areaArray[0];
    } else {
        _area = _areaArray[row];
    }
    _addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@%@", _province, _separator, _city, _separator, _area];
}

#pragma mark - 显示/隐藏地址选择器
- (void)showAddressPickerView {
//消除’expression result unused‘的警告
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
    [self initPickViewWithFrame:_currentFrame currentSuperView:_currentSuperView completeAction:_completeAction separator:_separator];
    [_currentSuperView addSubview:self];
}

- (void)hideAddressPickerView {
    [self removeFromSuperview];
    //重置状态
    [self resetDataAndUI];
}

#pragma mark - 初始化控件
- (UIPickerView *)addressPickerView {
    if (!_addressPickerView) {
        _addressPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 50, self.fzhWidth, self.fzhHeight - 50)];
        _addressPickerView.delegate = self;
        _addressPickerView.dataSource = self;
    }
    return _addressPickerView;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, self.fzhWidth - 120, 50)];
        _addressLabel.textAlignment = NSTextAlignmentCenter;
        _addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@%@", _province, _separator, _city, _separator, _area];
    }
    return _addressLabel;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [[UIButton alloc]initWithFrame:CGRectMake(self.fzhWidth - 50, 10, 50, 30)];
        [_confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_confirmButton setTitle:@"确认" forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirmButtonDidTouch) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, 50, 30)];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelButtonDidTouch) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIView *)separatorView {
    if (!_separatorView) {
        _separatorView = [[UIView alloc]initWithFrame:CGRectMake(0, 50, self.fzhWidth, 1)];
        _separatorView.backgroundColor = [UIColor lightGrayColor];
    }
    return _separatorView;
}

#pragma mark - 点击事件
- (void)confirmButtonDidTouch { //确认按钮点击事件
    if (self.completeAction) {
        self.completeAction([NSString stringWithFormat:@"%@%@%@%@%@", _province, _separator, _city, _separator, _area]);
    }
    [self hideAddressPickerView];
}

- (void)cancelButtonDidTouch { //取消按钮点击事件
    [self hideAddressPickerView];
}

#pragma mark - 初始化数据
- (void)setupCurrentCityDataWithRow:(NSInteger)row {
    if (row < 4) { //当前为北京、天津、上海、重庆
        NSString *city = [_totalArray[row] valueForKey:@"state"];
        _cityArray = @[city];
    } else {
        NSArray *array = [_totalArray[row] valueForKey:@"cities"];
        NSMutableArray *cityArray = [[NSMutableArray alloc]init];
        for (int i = 0; i < array.count; i++) {
            NSDictionary *dict = array[i];
            [cityArray addObject:[dict valueForKey:@"city"]];
        }
        _cityArray = [cityArray copy];
    }
}

- (void)setupCurrentAreaDataWithProvinceRow:(NSInteger)provinceRow cityRow:(NSInteger)cityRow {
    if (provinceRow < 4) {
        NSDictionary *dict = _totalArray[provinceRow];
        NSArray *array = [dict valueForKey:@"cities"];
        NSMutableArray *areaArray = [[NSMutableArray alloc]init];
        for (int i = 0; i < array.count; i++) {
            NSDictionary *dict = array[i];
            [areaArray addObject:[dict valueForKey:@"city"]];
        }
        _areaArray = [areaArray copy];
    } else {
        NSArray *cityArray = [_totalArray[provinceRow] valueForKey:@"cities"];
        _areaArray = [cityArray[cityRow] valueForKey:@"areas"];
        if (_areaArray.count == 0) {
            _areaArray = @[[cityArray[cityRow] valueForKey:@"city"]];
        }
    }
}

// 省
- (NSArray *)provinceArray {
    if (!_provinceArray) {
        NSMutableArray *array = [[NSMutableArray alloc]init];
        for (int i = 0; i < _totalArray.count; i++) {
            NSDictionary *dict = _totalArray[i];
            [array addObject:[dict valueForKey:@"state"]];
        }
        _provinceArray = [array copy];
    }
    return _provinceArray;
}

//市
- (NSArray *)cityArray {
    if (!_cityArray) {
        _cityArray = @[@"北京"];
    }
    return _cityArray;
}

//区
- (NSArray *)areaArray {
    if (!_areaArray) {
        NSDictionary *dict = _totalArray[0];
        NSArray *array = [dict valueForKey:@"cities"];
        NSMutableArray *areaArray = [[NSMutableArray alloc]init];
        for (int i = 0; i < array.count; i++) {
            NSDictionary *dict = array[i];
            [areaArray addObject:[dict valueForKey:@"city"]];
        }
        _areaArray = [areaArray copy];
    }
    return _areaArray;
}

#pragma mark - 私有方法
- (void)setupAddressData { //初始化数据
    _province = @"北京";
    _city = @"北京";
    _area = @"通州";
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"address" ofType:@"plist"];
    _totalArray = [[NSArray alloc]initWithContentsOfFile:plistPath];
}

- (void)resetDataAndUI { //重置数据和UI界面
    self.provinceArray = nil;
    self.cityArray = nil;
    self.areaArray = nil;
    
    [_addressPickerView removeFromSuperview];
    _addressPickerView = nil;
    
    [_confirmButton removeFromSuperview];
    _confirmButton = nil;
    
    [_cancelButton removeFromSuperview];
    _cancelButton = nil;
    
    [_addressLabel removeFromSuperview];
    _addressLabel = nil;
    
    [_separatorView removeFromSuperview];
    _separatorView = nil;
}
@end
