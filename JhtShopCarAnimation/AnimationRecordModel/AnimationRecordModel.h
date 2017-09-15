//
//  AnimationModel.h
//  JhtShopCarAnimation
//
//  GitHub主页: https://github.com/jinht
//  CSDN博客: http://blog.csdn.net/anticipate91
//
//  Created by Jht on 16/5/17.
//  Copyright © 2016年 JhtShopCarAnimation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnimationRecordModel : NSObject

#pragma mark - property
#pragma mark required
/** 图标路径 */
@property (nonatomic, strong) NSString *record_icon;
/** 解释文字 */
@property (nonatomic, strong) NSString *record_name;


@end
