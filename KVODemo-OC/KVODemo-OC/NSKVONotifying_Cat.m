//
//  NSKVONotifying_Cat.m
//  KVODemo-OC
//
//  Created by 邓永豪 on 2017/9/4.
//  Copyright © 2017年 dengyonghao. All rights reserved.
//

#import "NSKVONotifying_Cat.h"

@implementation NSKVONotifying_Cat

- (void)setColor:(UIColor *)color {
    [self willChangeValueForKey:@"color"];
    [self didChangeValueForKey:@"color"];
    [super setColor:color];
}

@end
