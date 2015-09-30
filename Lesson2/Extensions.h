//
//  Extensions.h
//  Lesson2
//
//  Created by Azat Almeev on 26.09.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSObject (Etended)
- (NSArray *)take:(NSInteger)to;
@end

@interface UIColor (Etended)
+ (UIColor *)randomColor;
@end

@interface NSArray (Reverse)
- (NSArray *)reversedArray;
@end