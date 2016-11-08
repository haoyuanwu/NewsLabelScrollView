//
//  NewsCollectionView.h
//  NewsLabelScrollView
//
//  Created by wuhaoyuan on 2016/11/4.
//  Copyright © 2016年 NewsLabelScrollView. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UPickerView;
@protocol UPickerViewDelegate <NSObject>

/**
 返回最后选择的在中间的视图（仅限每行是基数个的item）
 */
- (void)UPickerView:(UPickerView *)pickerView didSelectItemAtIndex:(NSInteger)index title:(NSString *)title;

@end

/**
 滚动的标题视图
 */
@interface UPickerView : UIView

//标题数组
@property (nonatomic,strong) NSArray *itemArr;
//一行几个item
@property (nonatomic,assign) NSInteger number;

//是否打开点击功能（默认关闭）
@property (nonatomic,assign) BOOL isOpenTouchItem;

@property (nonatomic,strong) id<UPickerViewDelegate> delegate;
@end
