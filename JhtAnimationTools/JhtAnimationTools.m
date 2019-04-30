//
//  JhtAnimationTools.m
//  JhtShopCarAnimation
//
//  GitHub主页: https://github.com/jinht
//  CSDN博客: http://blog.csdn.net/anticipate91
//
//  Created by Jht on 16/5/17.
//  Copyright © 2016年 JhtAnimationTools. All rights reserved.
//

#import "JhtAnimationTools.h"
#import <QuartzCore/QuartzCore.h>

@interface JhtAnimationTools () <CAAnimationDelegate> {
    // 矢量路径
    UIBezierPath *_shopPath;
    
    UIView *_superView;
    UIView *_dampingView;
}

@end


NSInteger const ATBlackViewTag = 222;

static NSString *const ATAnmationKey = @"ATAnmationKey";

@implementation JhtAnimationTools

#pragma mark - Public Method
+ (instancetype)sharedInstance {
    static JhtAnimationTools *jhtAnimationTools = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if (jhtAnimationTools == nil) {
            jhtAnimationTools = [[self alloc] init];
        }
    });
    
    return jhtAnimationTools;
}



#pragma mark - 购物车上抛动画
- (void)aniStartShopCarAnimationWithStartRect:(CGRect)rect imageView:(UIImageView *)imageView superView:(UIView *)view endPoint:(CGPoint)lastPoint controlPoint:(CGPoint)controlPoint startToEndSpacePercentage:(NSInteger)per expandAnimationTime:(CFTimeInterval)expandAnimationTime narrowAnimationTime:(CFTimeInterval)narrowAnimationTime animationValue:(CGFloat)animationValue {
    if (!_shopLayer) {
        _shopLayer = [CALayer layer];
        _shopLayer.contents = (id)imageView.layer.contents;
        _shopLayer.contentsGravity = kCAGravityResizeAspectFill;
        
        if (rect.size.height == 0) {
            // 动画开始坐标（相对于view ）
            rect = [imageView.superview convertRect:imageView.frame toView:view];
        }
        _shopLayer.bounds = rect;
        _shopLayer.masksToBounds = YES;
        _shopLayer.position = CGPointMake(rect.origin.x, rect.origin.y);
        [view.layer addSublayer:_shopLayer];
        
        _shopPath = [UIBezierPath bezierPath];
        [_shopPath moveToPoint:_shopLayer.position];
       
        // 不根据controlPoint判断: 如果控制点巧合是（0，0）将无法CGPointZero判断，所以根据per判断
        if (per > 0) {
            // 上-->下 ？ 下-->上
            NSInteger a = lastPoint.x - rect.origin.x;
            
            NSInteger lastPointToStartPoint = a > 0 ? a : -a;
            
            NSInteger b = lastPoint.x < rect.origin.x ? lastPoint.x : rect.origin.x;
            
            controlPoint = CGPointMake(b + lastPointToStartPoint / per, (CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]) + 44));
        }
        
        [_shopPath addQuadCurveToPoint:lastPoint controlPoint:controlPoint];
    }
    [self shopCarGroupAnimationWithExpandAnimationTime:expandAnimationTime narrowAnimationTime:narrowAnimationTime animationValue:animationValue];
}

/** 组合动画 */
- (void)shopCarGroupAnimationWithExpandAnimationTime:(CFTimeInterval)expandAnimationTime narrowAnimationTime:(CFTimeInterval)narrowAnimationTime animationValue:(CGFloat)animationValue {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = _shopPath.CGPath;

    CABasicAnimation *expandAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    expandAnimation.duration = expandAnimationTime;
    expandAnimation.fromValue = [NSNumber numberWithFloat:1];
    expandAnimation.toValue = [NSNumber numberWithFloat:animationValue];
    expandAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CABasicAnimation *narrowAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    narrowAnimation.beginTime = expandAnimationTime;
    narrowAnimation.fromValue = [NSNumber numberWithFloat:animationValue];
    narrowAnimation.duration = narrowAnimationTime;
    narrowAnimation.toValue = [NSNumber numberWithFloat:1];
    
    narrowAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = @[animation, expandAnimation, narrowAnimation];
    groups.duration = narrowAnimationTime + expandAnimationTime;
    groups.removedOnCompletion = NO;
    groups.fillMode = kCAFillModeForwards;
    groups.delegate = self;
    [_shopLayer addAnimation:groups forKey:ATAnmationKey];
}


#pragma mark CAAnimationDelegate（购物车动画代理）
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (anim == [_shopLayer animationForKey:ATAnmationKey]) {
        [_shopLayer removeFromSuperlayer];
        _shopLayer = nil;
        if ([self.toolsDelegate respondsToSelector:@selector(JhtAnimationWithType:isDidStop:)]) {
            [self.toolsDelegate JhtAnimationWithType:0 isDidStop:YES];
        }
    }
}



#pragma mark - 阻尼动画
- (UIView *)aniDampingAnimationWithSuperView:(UIView *)view frame:(CGRect)frame backgroundColor:(UIColor *)bgColor haveBlackView:(BOOL)haveBlackView {
    _superView = view;
    UIView *downView = [[UIView alloc] initWithFrame:frame];
    downView.backgroundColor = bgColor;
    downView.layer.masksToBounds = YES;
    downView.layer.cornerRadius = 5;
    downView.hidden = NO;
    _dampingView = downView;
    
    if (haveBlackView) {
        UIView *allView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds))];
        allView.backgroundColor = [UIColor blackColor];
        allView.alpha = 0;
        allView.tag = ATBlackViewTag;
        [view addSubview:allView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(aniCloseDampingAnimation)];
        [allView addGestureRecognizer:tap];
    }
    
    return downView;
}

- (UIView *)aniGetDampingBlackView {
    return [_superView viewWithTag:ATBlackViewTag];
}

- (void)aniStartDampingAnimation {
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveEaseIn animations:^{
        UIView *bgView = [self aniGetDampingBlackView];
        if (bgView) {
            bgView.alpha = 0.6;
        }
        
        if ([self.toolsDelegate respondsToSelector:@selector(JhtAnimationWithType:isDidStop:)]) {
            [self.toolsDelegate JhtAnimationWithType:1 isDidStop:NO];
        }
        
    } completion:^(BOOL finished) {
        if ([self.toolsDelegate respondsToSelector:@selector(JhtAnimationWithType:isDidStop:)]) {
            [self.toolsDelegate JhtAnimationWithType:1 isDidStop:YES];
        }
    }];
}

- (void)aniCloseDampingAnimation {
    CGFloat height = CGRectGetHeight(_dampingView.frame);
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _dampingView.frame = CGRectMake(0, -height - 20, CGRectGetWidth([UIScreen mainScreen].bounds), height);
        [self aniGetDampingBlackView].alpha = 0;
        
    } completion:^(BOOL finished) {
        
    }];
}


@end
