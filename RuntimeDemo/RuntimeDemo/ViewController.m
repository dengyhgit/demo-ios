//
//  ViewController.m
//  RuntimeDemo
//
//  Created by 邓永豪 on 2017/8/29.
//  Copyright © 2017年 dengyonghao. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "NextViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)nextViewController:(id)sender {
    [self presentViewController: [[NextViewController alloc] init] animated:true completion:nil];
}

// 获取 UIInputWindowController 里面的所有成员方法，包括私有方法，
// 获取有什么用呢? 通过私有的方法你就可以搞一些事情了，就是搞事
- (IBAction)allMethod:(id)sender {
    Class inputClass = NSClassFromString(@"UIInputWindowController");
    unsigned int count = 0;
    Method *memberMethods = class_copyMethodList(inputClass, &count);
    for (int i = 0; i < count; i++)
    {
        SEL address = method_getName(memberMethods[i]);
        NSString *methodName = [NSString stringWithCString:sel_getName(address) encoding:NSUTF8StringEncoding];
        NSLog(@"member method : %@",methodName);
    }
}

@end
