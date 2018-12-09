//
//  AnimationRecordCell.h
//  JhtShopCarAnimation
//
//  GitHub主页: https://github.com/jinht
//  CSDN博客: http://blog.csdn.net/anticipate91
//
//  Created by Jht on 15/10/9.
//  Copyright © 2016年 JhtShopCarAnimation. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

/** Cell */
@interface AnimationRecordCell : UITableViewCell

#pragma mark - property
@property (nonatomic, strong) UIImageView *formerIcon;
@property (nonatomic, strong) UILabel *descLabel;

@property (nonatomic, strong) UIImageView *deleteIcon;
@property (nonatomic, strong) UIButton *deleteBtn;

@property (nonatomic, strong) UILabel *lowLine;

 
@end



/** Model */
@interface AnimationRecordModel : NSObject

#pragma mark - property
@property (nonatomic, strong) NSString *record_icon;
@property (nonatomic, strong) NSString *record_name;


@end

