//
//  ViewController.m
//  KVODemo-OC
//
//  Created by 邓永豪 on 2017/9/4.
//  Copyright © 2017年 dengyonghao. All rights reserved.
//

#import "ViewController.h"
#import "Cat.h"

@interface ViewController ()

@property(nonatomic, strong) Cat *cat;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _cat = [[Cat alloc] init];
    
    [_cat addObserver:self forKeyPath:@"color" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"color"]) {
        NSLog(@"%@", [change objectForKey:@"new"]);
    }
}

- (IBAction)catColor:(id)sender {
    _cat.color = UIColor.blueColor;
}

@end
