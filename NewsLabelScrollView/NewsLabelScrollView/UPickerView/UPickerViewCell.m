//
//  CollectionViewCell.m
//  NewsLabelScrollView
//
//  Created by wuhaoyuan on 2016/11/4.
//  Copyright © 2016年 NewsLabelScrollView. All rights reserved.
//

#import "UPickerViewCell.h"
#import <UFoundation/UFoundation.h>

@implementation UPickerViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.textlabel = [[UILabel alloc] init];
        self.textlabel.textColor = UCOLOR_OLIVE_BLACK5;
        self.textlabel.font = UFONT_NORMAL;
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
