//
//  FZHPopListView.m
//  FZHUIKit
//
//  Created by 冯志浩 on 2017/8/18.
//  Copyright © 2017年 冯志浩. All rights reserved.
//

#import "FZHPopListView.h"
@interface FZHPopListView()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) UITableView *tableView;
@end
@implementation FZHPopListView
- (instancetype)initWithFrame:(CGRect)frame dataDict:(NSDictionary *)dataDict {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}



@end
