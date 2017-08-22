//
//  FZHButtonListView.h
//  FZHUIKit
//
//  Created by 冯志浩 on 2017/8/21.
//  Copyright © 2017年 冯志浩. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FZHButtonListViewDelegate <NSObject>
- (void)buttonListViewCurrentButton:(UIButton *)currentButton;
@end
@interface FZHButtonListView : UIView
@property (nonatomic, weak) id<FZHButtonListViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame buttonArray:(NSArray *)buttonArray;
@end
