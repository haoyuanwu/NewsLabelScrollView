//
//  ViewController.m
//  NewsLabelScrollView
//
//  Created by wuhaoyuan on 2016/11/4.
//  Copyright © 2016年 NewsLabelScrollView. All rights reserved.
//

#import "ViewController.h"
#import "UPickerView.h"

@interface ViewController () <UPickerViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *views = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:views];
    
    UPickerView *view = [[UPickerView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.width/5)];
    view.itemArr = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8"];
    view.number = 5;
    view.delegate = self;
    [views addSubview:view];
    
}

- (void)UPickerView:(UPickerView *)pickerView didSelectItemAtIndex:(NSInteger)index title:(NSString *)title{
    NSLog(@"%ld",(long)index);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
