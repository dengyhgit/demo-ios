//
//  UIViewController+Addition.m
//  RuntimeDemo
//
//  Created by 邓永豪 on 2017/8/29.
//  Copyright © 2017年 dengyonghao. All rights reserved.
//

#import "UIViewController+Addition.h"
#import <objc/runtime.h>

@implementation UIViewController (Addition)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        Method presentM = class_getInstanceMethod(class, @selector(presentViewController:animated:completion:));
        Method insertM = class_getInstanceMethod(class, @selector(insertMethod:animated:completion:));
        
        // 选择判断原来的方法有没有实现，这里是系统的方法，是当然会被实现的，但如果是sdk或者其它时，这个判断就很有必要了
        BOOL didAddMethod = class_addMethod([self class], @selector(presentViewController:animated:completion:), method_getImplementation(insertM), method_getTypeEncoding(insertM));
        
        if (didAddMethod) {
            class_replaceMethod([self class], @selector(insertMethod:animated:completion:), method_getImplementation(presentM), method_getTypeEncoding(presentM));
        } else {
            method_exchangeImplementations(insertM, presentM);
        }

    });
}

- (void)insertMethod: (UIViewController *)viewControllerToPresent animated: (BOOL)flag completion:(void (^ __nullable)(void))completion {
    NSLog(@"insertMethod");
    // 这里你可以做一些不可告人的事情了
    [self insertMethod:viewControllerToPresent animated:flag completion:completion];
}

@end
