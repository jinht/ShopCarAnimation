//
//  AnimationRecordCell.m
//  JhtShopCarAnimation
//
//  GitHub主页: https://github.com/jinht
//  CSDN博客: http://blog.csdn.net/anticipate91
//
//  Created by Jht on 15/10/9.
//  Copyright © 2016年 JhtShopCarAnimation. All rights reserved.
//

#import "AnimationRecordCell.h"

@implementation AnimationRecordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
        
        [self.contentView addSubview:self.formerIcon];
        [self.contentView addSubview:self.descLabel];
        
        [self.contentView addSubview:self.deleteIcon];
        [self.contentView addSubview:self.deleteBtn];
        
        [self.contentView addSubview:self.lowLine];
    }
    
    return self;
}



#pragma mark - Get
- (UIImageView *)formerIcon {
    if (!_formerIcon) {
        _formerIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 30, 30)];
    }
    
    return _formerIcon;
}

- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 120, 40)];
        _descLabel.textAlignment = NSTextAlignmentLeft;
        _descLabel.font = [UIFont systemFontOfSize:15];
    }
    
    return _descLabel;
}

- (UIImageView *)deleteIcon {
    if (!_deleteIcon) {
        _deleteIcon = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 13 - 22, 9, 22, 22)];
        [_deleteIcon setImage:[UIImage imageNamed:@"deleteIcon"]];
    }
    
    return _deleteIcon;
}

- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 50, 0, 50, 40)];
    }
    
    return _deleteBtn;
}

- (UILabel *)lowLine {
    if (!_lowLine) {
        _lowLine = [[UILabel alloc] init];
        _lowLine.backgroundColor = UIColorFromRGB(0xCCCCCC);
    }
    
    return _lowLine;
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
