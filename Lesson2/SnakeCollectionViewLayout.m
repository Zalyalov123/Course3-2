//
//  SnakeCollectionViewLayout.m
//  Lesson2
//
//  Created by Azat Almeev on 26.09.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import "SnakeCollectionViewLayout.h"
#import <BlocksKit+UIKit.h>
#import "Extensions.h"

@interface SnakeCollectionViewLayout () {
    CGSize contentSize;
    NSArray *attributes;
}

@end

@implementation SnakeCollectionViewLayout

#define kItemSize 100

- (NSInteger)numberOfItems {
    id<UICollectionViewDataSource> dataSource = self.collectionView.dataSource;
    return [dataSource collectionView:self.collectionView numberOfItemsInSection:0];
}

- (void)prepareLayout {
    contentSize = CGSizeMake(self.collectionView.frame.size.width, kItemSize * self.numberOfItems);
    NSArray *items = [self take:self.numberOfItems];
    NSArray *offsets = [items bk_map:^id(NSNumber *index) {
        NSInteger rem = [index integerValue] % 20;
        if (rem > 10)
            rem = ABS(rem - 20);
        return @(rem * 20);
    }];
    NSArray *transforms = [items bk_map:^id(NSNumber *index) {
        NSInteger rem = [index integerValue] % 20;
        if (rem > 10)
            rem = ABS(rem - 20);
        CGAffineTransform transform = CGAffineTransformMakeRotation(-M_PI_4 * rem / 20.);
        return [NSValue valueWithCGAffineTransform:transform];
    }];
    attributes = [items bk_map:^id(NSNumber *index) {
        NSInteger yOffset = [index integerValue] * kItemSize;
        UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:index.integerValue inSection:0]];
        attr.frame = CGRectMake([offsets[index.integerValue] integerValue], yOffset, kItemSize, kItemSize);
        attr.transform = [transforms[index.integerValue] CGAffineTransformValue];
        return attr;
    }];
}

- (CGSize)collectionViewContentSize {
    return contentSize;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return attributes[indexPath.row];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSInteger firstObject = MAX(rect.origin.y / kItemSize, 0);
    NSInteger lastObject = MIN((rect.origin.y + rect.size.height) / kItemSize, self.numberOfItems);
    NSMutableArray *attrs = [NSMutableArray new];
    for (NSInteger i = firstObject; i < lastObject; i++)
        [attrs addObject:[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]]];
    return attrs;
}

@end
