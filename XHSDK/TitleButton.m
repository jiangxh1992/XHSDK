//
//  TitleButton.m
//  XiaoXiSDK
//
//  Created by Xinhou Jiang on 16/7/11.
//  Copyright © 2016年 Xinhou Jiang. All rights reserved.
//

#import "TitleButton.h"

@implementation TitleButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 按钮文字默认颜色
    self.titleLabel.textColor = [UIColor blackColor];
    
    //按钮图标的size
    CGRect imageFrame = self.imageView.frame;
    imageFrame.size = CGSizeMake(50, 50);
    self.imageView.frame = imageFrame;
    
    //按钮图标的位置
    self.imageView.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.35);
    
    //按钮图标的size
    CGRect titleFrame = self.titleLabel.frame;
    titleFrame.size = CGSizeMake(65, 20);
    self.titleLabel.frame = titleFrame;
    
    //按钮标题的位置
    [self.titleLabel sizeToFit];
    self.titleLabel.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.7);
}

@end
