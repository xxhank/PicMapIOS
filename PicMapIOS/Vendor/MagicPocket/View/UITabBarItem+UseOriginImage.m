//
// UITabBarItem+UseOriginImage.m
// Memo
//
// Created by wangchaojs02 on 15/11/1.
// Copyright © 2015年 wangchaojs02. All rights reserved.
//

#import "UITabBarItem+UseOriginImage.h"
#import <objc/runtime.h>

@implementation UITabBarItem (UseOriginImage)
+ (void)load
{
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
#if 0
        SEL original = @selector(initWithCoder:);
        Method originalMethod = class_getInstanceMethod(self, original);

        SEL swizzled = @selector(mm_initWithCoder:);
        Method swizzledMethod = class_getInstanceMethod(self, swizzled);

        method_exchangeImplementations(originalMethod, swizzledMethod);
#endif
    });
} /* load */

- (instancetype)mm_initWithTitle:(nullable NSString*)title image:(nullable UIImage*)image selectedImage:(nullable UIImage*)selectedImage
{
    return [self mm_initWithTitle:title
                            image:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                    selectedImage:[selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
}

- (instancetype)mm_initWithCoder:(NSCoder*)aDecoder
{
    UITabBarItem *item = [self mm_initWithCoder:aDecoder];

    item.image         = [item.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item.selectedImage = [item.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return item;
}

- (void)vendor
{
    NSLog(@"wangchao");
}

@end
