//
//  FZHSearchBarView.m
//  FZHUIKit
//
//  Created by 冯志浩 on 2017/8/11.
//  Copyright © 2017年 冯志浩. All rights reserved.
//

#import "FZHSearchBarView.h"
#import "UIView+Frame.h"
@interface FZHSearchBarView()<UISearchBarDelegate>
@property (nonatomic, strong) UINavigationBar *currentNavigationBar;
@property (nonatomic, strong) UISearchBar *searchBar;
@end
@implementation FZHSearchBarView

- (instancetype)initFZHSearchBarViewWithFrame:(CGRect)frame currentNavigationBar:(UINavigationBar *)currentNavigationBar {
    if (self = [super initWithFrame:frame]) {
        _currentNavigationBar = currentNavigationBar;
        [self addSubview:self.searchBar];
    }
    return self;
}

#pragma mark - Animation
// 导航条上移
- (void)navigationBarMoveUp {
    [UIView animateWithDuration:1.0 animations:^{
        _currentNavigationBar.transform = CGAffineTransformMakeTranslation(0, -44);
    }];
}
// 恢复导航条初始状态
- (void)navigationRetrieve {
    [UIView animateWithDuration:1.0 animations:^{
        _currentNavigationBar.transform = CGAffineTransformIdentity;
    }];
}

- (void)searchBarMoveUp {
    [UIView animateWithDuration:1.0 animations:^{
        _searchBar.transform = CGAffineTransformMakeTranslation(0, -44);
    }];
}

- (void)searchBarRetrieve {
    [UIView animateWithDuration:1.0 animations:^{
        _searchBar.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self navigationBarMoveUp];
    [self searchBarMoveUp];
    searchBar.showsCancelButton = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self navigationRetrieve];
    [self searchBarRetrieve];
    searchBar.showsCancelButton = NO;
}

#pragma mark - 初始化控件
- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(10, 5, self.fzhWidth - 20, self.fzhHeight - 10)];
        _searchBar.delegate = self;
    }
    return _searchBar;
}
@end
