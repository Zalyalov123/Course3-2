//
//  RoundCollectionViewLayout.m
//  Lesson2
//
//  Created by Azat Almeev on 26.09.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import "RoundCollectionViewLayout.h"
#import <BlocksKit+UIKit.h>
#import "Extensions.h"

@interface RoundCollectionViewLayout () {
    NSArray *attributes;
}
@end

@implementation RoundCollectionViewLayout
#define kItemSize 100
#define degreesToRadians( degrees ) ( ( degrees ) / 180.0 * M_PI )

- (NSInteger)numberOfItems {
    id<UICollectionViewDataSource> dataSource = self.collectionView.dataSource;
    return [dataSource collectionView:self.collectionView numberOfItemsInSection:0];
}

- (void)prepareLayout {
    NSInteger cx = self.collectionViewContentSizeM.width / 2;
    NSInteger cy = self.collectionViewContentSizeM.height / 2;
    double addAngle = self.collectionView.contentOffset.x / 2. / cx * 360;
    NSArray *items = [self take:self.numberOfItems];
    NSArray *angles = [items bk_map:^id(NSNumber *index) {
        return @(360. * [index integerValue] / items.count + addAngle);
    }];
    double a = cx - kItemSize / 2;
    double b = 100;
    NSArray *points = [angles bk_map:^id(NSNumber *degree) {
        double fi = degreesToRadians([degree doubleValue]);
        double r = a * b / sqrt(b * b * cos(fi) * cos(fi) + a * a * sin(fi) * sin(fi));
        double x = cx + r * cos(fi);
        double y = cy + r * sin(fi);
        return [NSValue valueWithCGPoint:CGPointMake(x, y)];
    }];
    attributes = [items bk_map:^id(NSNumber *index) {
        UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:index.integerValue inSection:0]];
        CGPoint pt = [points[index.integerValue] CGPointValue];
        attr.frame = CGRectMake(pt.x - kItemSize / 2 + self.collectionView.contentOffset.x, pt.y - kItemSize / 2, kItemSize, kItemSize);
        return attr;
    }];
}

- (CGSize)collectionViewContentSizeM {
    CGSize size = self.collectionView.frame.size;
    size.height -= 64;
    return size;
}

- (CGSize)collectionViewContentSize {
    CGSize size = self.collectionViewContentSizeM;
    size.width *= 2;
    return size;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return attributes[indexPath.row];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attrs = [NSMutableArray new];
    for (NSInteger i = 0; i < self.numberOfItems; i++)
        [attrs addObject:[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]]];
    return attrs;
}

@end
