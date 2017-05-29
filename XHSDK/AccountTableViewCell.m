//
//  AccountTableViewCell.m
//  Unity-iPhone
//
//  Created by Xinhou Jiang on 6/27/16.
//
//

#import "AccountTableViewCell.h"

@implementation AccountTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 头像
        _avatar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, inputH, inputH)];
        [self.contentView addSubview:_avatar];
        
        // 账号
        _account = [[UILabel alloc]initWithFrame:CGRectMake(inputH, 0, inputW - inputH, inputH)];
        _account.font = fontNormal;
        [self.contentView addSubview:_account];
        
        // 删除按钮
        _deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, inputH, inputH)];
        _deleteButton.center = CGPointMake(inputW - inputH/2, inputH/2);
        [_deleteButton setImage:[UIImage imageNamed:@"xiaoxisdk_close"] forState:UIControlStateNormal];
        [self.contentView addSubview:_deleteButton];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    frame.origin.x += 1;
    frame.size.width -= 2;
    [super setFrame:frame];
}

@end