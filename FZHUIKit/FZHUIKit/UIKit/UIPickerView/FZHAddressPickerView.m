//
//  FZHAddressPickerView.m
//  FZHUIKit
//
//  Created by 冯志浩 on 2017/8/8.
//  Copyright © 2017年 冯志浩. All rights reserved.
//  地址选择器

#import "FZHAddressPickerView.h"
#import "UIView+Frame.h"
@interface FZHAddressPickerView() <
UIPickerViewDelegate,
UIPickerViewDataSource
>
@property (nonatomic, strong) UIPickerView *addressPickerView;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, copy) FZHPickerViewCompletionBlock completeAction;

@property (nonatomic, copy) NSArray *provinceArray;
@property (nonatomic, copy) NSArray *cityArray;
@property (nonatomic, copy) NSArray *areaArray;
@property (nonatomic, copy) NSArray *totalArray;
@property (nonatomic, assign) NSInteger provinceRow;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *area;
@end

@implementation FZHAddressPickerView

+ (instancetype)initPickViewWithFrame:(CGRect)frame completeAction:(FZHPickerViewCompletionBlock)completeAction {
    return [[self alloc]initPickViewWithFrame:frame completeAction:completeAction];
}

- (instancetype)initPickViewWithFrame:(CGRect)frame completeAction:(FZHPickerViewCompletionBlock)completeAction {
    if (self = [super initWithFrame:frame]) {
        _completeAction = completeAction;
        
        _provinceRow = 0;
        [self setupAddressData];
        [self addSubview:self.addressPickerView];
        [self addSubview:self.addressLabel];
        [self addSubview:self.confirmButton];
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
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return _provinceArray[row];
    } else if (component == 1) {
        return _cityArray[row];
    } else {
        return _areaArray[row];
    }
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
    _addressLabel.text = [NSString stringWithFormat:@"%@%@%@", _province, _city, _area];
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
        _addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.fzhWidth/2, 50)];
    }
    return _addressLabel;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [[UIButton alloc]initWithFrame:CGRectMake(self.fzhWidth/2, 0, self.fzhWidth/2, 50)];
        [_confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_confirmButton setTitle:@"确认" forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirmButtonDidTouch) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

- (void)confirmButtonDidTouch {
    if (self.completeAction) {
        self.completeAction([NSString stringWithFormat:@"%@-%@-%@", _province, _city, _area]);
    }
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

- (void)setupAddressData {
    _province = @"北京";
    _city = @"北京";
    _area = @"通州";
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"address" ofType:@"plist"];
    _totalArray = [[NSArray alloc]initWithContentsOfFile:plistPath];
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
@end
