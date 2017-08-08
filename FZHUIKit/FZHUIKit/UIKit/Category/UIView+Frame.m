//
//  UIView+Frame.m
//  FZHUIKit
//
//  Created by 冯志浩 on 2017/8/8.
//  Copyright © 2017年 冯志浩. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (CGFloat)fzhX {
    return self.frame.origin.x;
}

- (CGFloat)fzhY {
    return self.frame.origin.y;
}

- (CGFloat)fzhWidth {
    return self.frame.size.width;
}

- (CGFloat)fzhHeight {
    return self.frame.size.height;
}

- (CGSize)fzhSize {
    return self.frame.size;
}

- (CGPoint)fzhOrigin {
    return self.frame.origin;
}
@end
