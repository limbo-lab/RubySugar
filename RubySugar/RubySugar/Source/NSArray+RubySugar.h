//
//  NSArray+RubySugar.h
//  RubySugar
//
//  Created by Michal Konturek on 24/12/2013.
//  Copyright (c) 2013 Michal Konturek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (RubySugar)

/**
 Returns new array by concatenating array with input object.
 
 Every object that responds to description selector is appended.
 */
- (instancetype):(id)object;

/**
 Returns self[@"<from>..<to>"]
 */
- (instancetype):(NSInteger)from :(NSInteger)to;

/**
 Returns self[@"<from>..<to>"] or self[@"<from>...<to>"] if exclusive.
 */
- (instancetype):(NSInteger)from :(NSInteger)to exclusive:(BOOL)exclusive;

/**
 Drops first n elements from ary and returns the rest of the elements in an array.
 If a negative number is given, raises an ArgumentError.
 */
- (instancetype)rs_drop:(NSInteger)count;

/**
 Drops elements up to, but not including, the first element for which the block 
 returns nil or false and returns an array containing the remaining elements.
 
 If no block is given, an Enumerator is returned instead.
 */
- (id)rs_dropWhile:(BOOL(^)(id item))block;


/**
 Returns first n elements from the array.
 
 If a negative number is given, raises an ArgumentError.
 */
- (instancetype)rs_take:(NSInteger)count;

/**
 Passes elements to the block until the block returns nil or false, 
 then stops iterating and returns an array of all prior elements.
 
 If no block is given, an Enumerator is returned instead.
 */
- (id)rs_takeWhile:(BOOL(^)(id item))block;

/**
 Shorthand ([self count] == 0)
 */
- (BOOL)rs_isEmpty;

- (id)objectForKeyedSubscript:(id<NSCopying>)key;

@end