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
        // 去除选中的效果
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
        
        // 前边的图片
        self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 30, 30)];
        [self.contentView addSubview:self.headerImageView];
        
        // 前边图片后边的label
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 120, 40)];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.titleLabel];
        
        CGFloat frameW = [UIScreen mainScreen].bounds.size.width;
        // 删除图标
        self.wrongImageView = [[UIImageView alloc] initWithFrame:CGRectMake(frameW - 13 - 22, 9, 22, 22)];
        [self.wrongImageView setImage:[UIImage imageNamed:@"项目删除"]];
        [self.contentView addSubview:self.wrongImageView];
        
        // 扣在删除图标的btn
        self.wrongBtn = [[UIButton alloc] initWithFrame:CGRectMake(frameW - 50, 0, 50, 40)];
        [self.contentView addSubview:self.wrongBtn];
        
        // 底部的分割线
        self.lineLabel = [[UILabel alloc] init];
        self.lineLabel.backgroundColor = UIColorFromRGB(0xCCCCCC);
        [self.contentView addSubview:self.lineLabel];
    }
    return self;
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
