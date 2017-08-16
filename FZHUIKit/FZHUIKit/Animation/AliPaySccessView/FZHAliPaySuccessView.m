//
//  FZHAliPaySuccessView.m
//  FZHUIKit
//
//  Created by 冯志浩 on 2017/8/16.
//  Copyright © 2017年 冯志浩. All rights reserved.
//  支付宝支付成功动画效果

#import "FZHAliPaySuccessView.h"
@interface FZHAliPaySuccessView() <CAAnimationDelegate>
@property (nonatomic, copy) AnimationCompleteBlock animationCompleteBlock;
@end

@implementation FZHAliPaySuccessView

- (instancetype)initWithFrame:(CGRect)frame animationCompleteBlock:(AnimationCompleteBlock)animationCompleteBlock {
    if (self = [super initWithFrame:frame]) {
        _animationCompleteBlock = animationCompleteBlock;
        [self showAnimationIPay:self];
    }
    return self;
}

- (void)showAnimationIPay:(UIView*)view{
    CGFloat LineWidthScale = 1.0;
    CGSize size = view.frame.size;
    CGFloat radius=(size.height>size.width?size.width:size.height)/2.0;
    CGFloat lineW= radius * LineWidthScale/10;
    
    //画圈
    UIBezierPath*circlePath =[UIBezierPath bezierPathWithArcCenter:CGPointMake(radius,radius)radius:radius startAngle:M_PI*3/2 endAngle:M_PI*7/2 clockwise:YES];
    circlePath.lineCapStyle = kCGLineCapRound;
    circlePath.lineJoinStyle = kCGLineCapRound;
    
    //对勾
    UIBezierPath*linePath = [UIBezierPath bezierPath];
    [linePath moveToPoint:CGPointMake(radius*0.45,radius*1.0)];
    [linePath addLineToPoint:CGPointMake(radius*0.84,radius*1.32)];
    [linePath addLineToPoint:CGPointMake(radius*1.48,radius*0.68)];
    [circlePath appendPath:linePath];
    CAShapeLayer*shapeLyer =[CAShapeLayer layer];
    shapeLyer.path=circlePath.CGPath;
    shapeLyer.strokeColor = [UIColor colorWithRed:0/255.0 green:194/255.0 blue:79/255.0 alpha:1.0].CGColor;
    shapeLyer.fillColor= [[UIColor clearColor] CGColor];
    shapeLyer.lineWidth=lineW;
    shapeLyer.strokeStart= 0.0;
    shapeLyer.strokeEnd= 0.0;
    [view.layer addSublayer:shapeLyer];
    
    //动画
    CABasicAnimation*animation =[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    if(shapeLyer.strokeEnd== 1.0) {
        [animation setFromValue:@1.0];
        [animation setToValue:@0.0];
    } else {
        [animation setFromValue:@0.0];
        [animation setToValue:@1.0];
    }
    
    [animation setDuration:1.0];
    animation.fillMode=kCAFillModeForwards;
    animation.removedOnCompletion=NO;
    //如果在动画结束后需要做操作的话，设置动画代理
    animation.delegate=self;
    [shapeLyer addAnimation:animation forKey:@"animationKey"];
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation*)anim finished:(BOOL)flag {
    self.animationCompleteBlock();
}
@end
