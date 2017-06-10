//
//  AccountTableViewController.m
//  JXHDemo
//
//  Created by Xinhou Jiang on 6/7/16.
//  Copyright © 2016 Jiangxh. All rights reserved.
//00

#import "AccountTableViewController.h"
#import "LoginSelectViewController.h"
#import "UserInfo.h"
#import "AccountTableViewCell.h"

@interface AccountTableViewController ()

@end

@implementation AccountTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 背景透明
    self.view.backgroundColor = [UIColor whiteColor];
    // 清除多余的分割线
    [self.tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    //  边界
    //self.tableView.layer.borderWidth = 0.5;
    
    // 默认关闭下拉列表
    _isOpen = NO;
}

// 分区个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// 每个分区cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 展开与隐藏账号列表
    if(_isOpen)
        return _accountSource.count;
    else
        return 0;
}

// cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AccountTableViewCell *cell = [[AccountTableViewCell alloc]init];
    [cell.deleteButton addTarget:self action:@selector(cellClicked:) forControlEvents:UIControlEventTouchUpInside];
    cell.deleteButton.tag = indexPath.row;
    // 添加数据源
    UserInfo *acc = _accountSource[indexPath.row];
    cell.avatar.image = [UIImage imageNamed:acc.avatar];// 头像
    cell.account.text = acc.username;// 账号
    cell.account.textColor = TextColorNormal;
    [cell setBackgroundColor:[UIColor whiteColor]];
    //分割线清偏移
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [cell setPreservesSuperviewLayoutMargins:NO];
        
    }
    return cell;
}

// cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return inputH;
}

// cell选中事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 通知代理
    [_delegate selectedCell:indexPath.row];
}

//// 打开cell滑动编辑
//- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}
//
//// 删除按钮的显示文字
//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return @"删除";
//}

// cell删除
- (void)cellClicked:(UIButton *)sender {
    // 删除本地用户
    UserInfo *toremove = [_accountSource objectAtIndex:sender.tag];
    [[XiaoxiSDK Ins] removeUserInfoWithUsername:toremove.username];
    [_accountSource removeObjectAtIndex:sender.tag];
    [self.tableView reloadData];
    
    // 通知代理更新下拉菜单高度
    [_delegate updateListH];
    
    // 如果没有账号数据则退出
    if (_accountSource.count == 0) {
        LoginSelectViewController *loginVC = [[LoginSelectViewController alloc]init];
        loginVC.isRoot = YES;
        [self.navigationController pushViewController:loginVC animated:NO];
    }
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        
//    }
//}

@end
