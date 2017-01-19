//
//  CollectionViewCell.m
//  NewsLabelScrollView
//
//  Created by wuhaoyuan on 2016/11/4.
//  Copyright © 2016年 NewsLabelScrollView. All rights reserved.
//

#import "UPickerViewCell.h"

@implementation UPickerViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.textlabel = [[UILabel alloc] init];
        self.textlabel.textColor = [UIColor grayColor];
        self.textlabel.font = [UIFont systemFontOfSize:15];
        self.textlabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.textlabel];
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.textlabel.frame = self.contentView.bounds;
}
@end
