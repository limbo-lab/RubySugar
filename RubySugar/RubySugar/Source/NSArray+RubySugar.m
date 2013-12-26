//
//  NSArray+RubySugar.m
//  RubySugar
//
//  Created by Michal Konturek on 24/12/2013.
//  Copyright (c) 2013 Michal Konturek. All rights reserved.
//

#import "NSArray+RubySugar.h"

#import "NSNumber+RubySugar.h"
#import "NSString+RubySugar.h"

@implementation NSArray (RubySugar)

- (instancetype):(id)object {
    if (!object) return self;
    
    id result = [NSMutableArray arrayWithArray:self];
    if ([object isKindOfClass:[NSArray class]]) [result addObjectsFromArray:object];
    else [result addObject:object];
    
    return result;
}

- (instancetype):(NSInteger)from :(NSInteger)to {
    return [self :from :to exclusive:NO];
}

- (instancetype):(NSInteger)from :(NSInteger)to exclusive:(BOOL)exclusive {
    id op = (exclusive) ? @"..." : @"..";
    return self[[NSString stringWithFormat:@"%i%@%i", from, op, to]];
}

- (instancetype)rs_drop:(NSInteger)count {
    if (count < 0) @throw [NSException exceptionWithName:NSInvalidArgumentException
                                                  reason:NSInvalidArgumentException
                                                userInfo:nil];
    
    if (count > (NSInteger)self.count) return [NSArray array];
    
    NSRange range = NSMakeRange(count, [self count] - count);
    return [self subarrayWithRange:range];
}

- (id)rs_dropWhile:(BOOL(^)(id item))block {
    if (!block) return [self objectEnumerator];
    
    NSInteger count = 0;
    for (id item in self) {
        if (block(item)) count++;
        else break;
    }
    
    return [self rs_drop:count];
}

- (instancetype)rs_take:(NSInteger)count {
    if (count < 0) @throw [NSException exceptionWithName:NSInvalidArgumentException
                                                  reason:NSInvalidArgumentException
                                                userInfo:nil];
    
    if (count > (NSInteger)self.count) return self;
    
    NSInteger length = (count > self.count) ? self.count : count;
    return [self subarrayWithRange:NSMakeRange(0, length)];
}

- (id)rs_takeWhile:(BOOL(^)(id item))block {
    if (!block) return [self objectEnumerator];
    
    NSInteger count = 0;
    for (id item in self) {
        if (block(item)) count++;
        else break;
    }
    
    return [self rs_take:count];
}

- (BOOL)rs_isEmpty {
    return ([self count] == 0);
}

- (id)objectForKeyedSubscript:(id<NSCopying>)key {
    static NSString *inclusiveRange = @"..";
    static NSString *exclusiveRange = @"...";
    
    if ([(id)key isKindOfClass:[NSString class]]) {
        
        NSRange range = NSRangeFromString((NSString *)key);
        if ([(NSString *)key rs_containsString:exclusiveRange]) {
            range = NSMakeRange(range.location + 1, range.length - range.location - 1);
        } else if ([(NSString *)key rs_containsString:inclusiveRange]) {
            range = NSMakeRange(range.location, range.length - range.location + 1);
        }
        
        return [self subarrayWithRange:range];
    } if ([(id)key isKindOfClass:[NSValue class]]) {
        
        NSRange range = [(NSValue *)key rangeValue];
        range.length = 1;
        return [self subarrayWithRange:range];
        
    } else @throw [NSException exceptionWithName:NSInvalidArgumentException
                                          reason:NSInvalidArgumentException
                                        userInfo:nil];
}

@end