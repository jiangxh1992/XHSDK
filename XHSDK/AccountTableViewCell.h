//
//  AccountTableViewCell.h
//  Unity-iPhone
//
//  Created by Xinhou Jiang on 6/27/16.
//
//

#import <UIKit/UIKit.h>

@interface AccountTableViewCell : UITableViewCell

/**
 *  头像
 */
@property (nonatomic, strong) UIImageView *avatar;

/**
 *  账号
 */
@property (nonatomic, strong) UILabel *account;

/**
 *  删除按钮
 */
@property (nonatomic, strong) UIButton *deleteButton;

@end
