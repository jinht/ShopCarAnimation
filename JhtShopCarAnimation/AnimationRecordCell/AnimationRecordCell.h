//
//  AnimationRecordCell.h
//  JhtShopCarAnimation
//
//  GitHub主页: https://github.com/jinht
//  CSDN博客: http://blog.csdn.net/anticipate91
//
//  Created by Jht on 15/10/9.
//  Copyright (c) 2015年 靳海涛. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

/** 编辑运动记录页 编辑记录的cell */
@interface AnimationRecordCell : UITableViewCell
/** 前边的图片 */
@property (nonatomic, strong) UIImageView *headerImageView;
/** 图片后边的文字 */
@property (nonatomic, strong) UILabel *titleLabel;

/** 删除ImageView */
@property (nonatomic, strong) UIImageView *wrongImageView;

/** 删除btn */
@property (nonatomic, strong) UIButton *wrongBtn;
/** 底部的分割线 */
@property (nonatomic, strong) UILabel *lineLabel;

 
@end
