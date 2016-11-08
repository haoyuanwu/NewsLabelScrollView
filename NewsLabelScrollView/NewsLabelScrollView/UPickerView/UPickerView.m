//
//  NewsCollectionView.m
//  NewsLabelScrollView
//
//  Created by wuhaoyuan on 2016/11/4.
//  Copyright © 2016年 NewsLabelScrollView. All rights reserved.
//

#import "UPickerView.h"
#import "UPickerViewCell.h"

@interface UPickerView () <UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionViewFlowLayout *flowLayout;
    //用来记录滑动位置
    CGFloat scrollViewX;
    BOOL isScoll;
    
    //创建回调 判断滑动松手后的状态
    void(^scrollBlock)(CGFloat);
    
    //记录之前被点击的标签
    UILabel *tmpLabel;
    //计算获得的新数组
    NSMutableArray *newArray;
    
    //判断是不是向前滑动
    BOOL isBefore;
}
//每个标签宽度
@property (nonatomic,assign) CGFloat itemWidth;
@property (nonatomic,strong) UICollectionView *collectionView;

@end

@implementation UPickerView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.collectionView];
        self.isOpenTouchItem = NO;
        
    }
    return self;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        
        flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.itemSize = CGSizeMake(self.itemWidth, self.frame.size.height);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.autoresizesSubviews = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.contentOffset = CGPointMake(self.itemWidth * (self.number-3), 0);
        [_collectionView registerClass:[UPickerViewCell class] forCellWithReuseIdentifier:@"cellid"];
        
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return newArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UPickerViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    cell.textlabel.text = newArray[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if (!self.isOpenTouchItem) {
        return;
    }
    if (newArray.count > self.number) {
        if (indexPath.item <= 2) {
            scrollViewX = CGFLOAT_MAX;
            collectionView.contentOffset = CGPointMake(collectionView.contentSize.width - (self.number * indexPath.item) * self.itemWidth, 0);
        }else if (indexPath.item >= newArray.count-3){
            scrollViewX = 0;
            collectionView.contentOffset = CGPointMake((indexPath.item - self.number - 4) * self.itemWidth, 0);
        }else{
            collectionView.contentOffset = CGPointMake((indexPath.item-2) * self.itemWidth, 0);
        }
    }
    if (tmpLabel) {
        tmpLabel.textColor = [UIColor colorWithWhite:0.3 alpha:0.6];
    }
    UPickerViewCell *cell = (UPickerViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    cell.textlabel.textColor = [UIColor blackColor];
    tmpLabel = cell.textlabel;
    NSInteger index = indexPath.item;
    if (self.delegate) {
        for (int i = 0; i < self.itemArr.count; i++) {
            NSString *string = newArray[index];
            if ([string isEqualToString:self.itemArr[i]]) {
                [self.delegate UPickerView:self didSelectItemAtIndex:i title:newArray[index]];
            }
        }
    }
}

- (void)setItemArr:(NSArray *)itemArr{
    _itemArr = itemArr;
}

- (void)setNumber:(NSInteger)number{
    _number = number;
    self.itemWidth = self.collectionView.frame.size.width/_number;
    [self calculateArray];
    
}

//计算数组个数
- (void)calculateArray{
    if (self.itemArr.count * self.itemWidth > self.collectionView.frame.size.width) {
        newArray = [NSMutableArray arrayWithArray:self.itemArr];
        
        NSInteger totalNum = self.itemArr.count;
        for (int i = 0; i < self.number; i++) {
            totalNum -= 1;
            [newArray insertObject:self.itemArr[totalNum] atIndex:0];
            [newArray insertObject:self.itemArr[i] atIndex:newArray.count];
        }
        flowLayout.itemSize = CGSizeMake(self.itemWidth, self.frame.size.height);
    }
    self.collectionView.contentOffset = CGPointMake((self.number-2) * self.itemWidth, 0);
    [self.collectionView reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if (scrollViewX != 0 ) {
        if (scrollView.contentOffset.x > scrollViewX) {
            isBefore = YES;
            //向前滑动
            if (scrollView.contentOffset.x > scrollView.contentSize.width - self.itemWidth * self.number + 0.1) {//(0.1是为补充误差)
                scrollViewX = 0;
                scrollView.contentOffset = CGPointMake(self.number * self.itemWidth, 0);
            }
        }else if (scrollView.contentOffset.x < scrollViewX){
            isBefore = NO;
            //向后滑动
            if (scrollView.contentOffset.x < 0) {
                scrollViewX = CGFLOAT_MAX;
                scrollView.contentOffset = CGPointMake(scrollView.contentSize.width - (self.number*2) * self.itemWidth, 0);
            }
        }
    }
    
    scrollViewX = scrollView.contentOffset.x;
    //用回调判断当前松手后还有没有滑动！
    __weak typeof (self)wself = self;
    
    scrollBlock = ^(CGFloat scrollX){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (scrollX == scrollViewX) {
                CGFloat num = scrollView.contentOffset.x/wself.itemWidth;
                NSInteger index = num;
                //判断结束的时候标签是否超过中心的一半
                if (isBefore) {
                    index += 1;
                    [UIView animateWithDuration:0.25 animations:^{
                        scrollView.contentOffset = CGPointMake(index * wself.itemWidth, 0);
                    }];
                }else{
                    [UIView animateWithDuration:0.25 animations:^{
                        scrollView.contentOffset = CGPointMake(index * wself.itemWidth, 0);
                    }];
                }
                if (wself.delegate) {
                    for (int i = 0; i < wself.itemArr.count; i++) {
                        NSString *string = newArray[index];
                        if ([string isEqualToString:self.itemArr[i]]) {
                            [self.delegate UPickerView:self didSelectItemAtIndex:i title:newArray[index+2]];
                            if (tmpLabel) {
                                tmpLabel.textColor = [UIColor colorWithWhite:0.3 alpha:0.6];
                            }
                            UPickerViewCell *cell = (UPickerViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index+2 inSection:0]];
                            cell.textlabel.textColor = [UIColor blackColor];
                            tmpLabel = cell.textlabel;
                        }
                    }
                }
            }
        });
    };
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat num = scrollView.contentOffset.x/self.itemWidth;
    NSInteger index = num;
    //判断结束的时候标签是否超过中心的一半
    if (isBefore) {
        index += 1;
        [UIView animateWithDuration:0.25 animations:^{
            scrollView.contentOffset = CGPointMake(index * self.itemWidth, 0);
        }];
    }else {
        [UIView animateWithDuration:0.25 animations:^{
            scrollView.contentOffset = CGPointMake(index * self.itemWidth, 0);
        }];
    }
    if (self.delegate) {
        for (int i = 0; i < self.itemArr.count; i++) {
            NSString *string = newArray[index+2];
            if ([string isEqualToString:self.itemArr[i]]) {
                [self.delegate UPickerView:self didSelectItemAtIndex:i+2 title:newArray[index+2]];
                if (tmpLabel) {
                    tmpLabel.textColor = [UIColor colorWithWhite:0.3 alpha:0.6];
                }
                UPickerViewCell *cell = (UPickerViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index+2 inSection:0]];
                cell.textlabel.textColor = [UIColor blackColor];
                tmpLabel = cell.textlabel;
            }
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    scrollBlock(scrollViewX);

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
