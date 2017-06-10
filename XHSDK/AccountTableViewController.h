//
//  AccountTableViewController.h
//  JXHDemo
//
//  Created by Xinhou Jiang on 6/7/16.
//  Copyright © 2016 Jiangxh. All rights reserved.
//  本地账户下拉菜单

#import <UIKit/UIKit.h>

@protocol AccountDelegate <NSObject>

/**
 * 选中cell的代理事件
 */
- (void) selectedCell:(NSInteger)index;

/**
 *  更新下拉菜单的高度
 */
- (void) updateListH;

@end

@interface AccountTableViewController : UITableViewController

/**
 * 是否展开菜单
 */
@property (nonatomic)BOOL isOpen;

/**
 * 账号数据源
 */
@property (nonatomic) NSMutableArray * accountSource;

/**
 * 定义代理
 */
@property (nonatomic, weak) id<AccountDelegate>delegate;

@end
