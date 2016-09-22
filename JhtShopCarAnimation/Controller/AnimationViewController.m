//
//  ViewController.m
//  JhtShopCarAnimation
//
//  GitHub主页: https://github.com/jinht
//  CSDN博客: http://blog.csdn.net/anticipate91
//
//  Created by Jht on 16/5/17.
//  Copyright © 2016年 靳海涛. All rights reserved.
//

#import "AnimationViewController.h"
#import "JhtAnimationTools.h"
#import "AnimationRecordCell.h"
#import "AnimationRecordModel.h"

@interface AnimationViewController () <UITableViewDataSource, UITableViewDelegate, JhtAnimationToolsDelegate> {
    // 数据源
    NSMutableArray *_sourceArray;

    // 底部 的所有数据数组
    NSMutableArray *_tableFooterViewDataArray;
    // tableView
    UITableView *_tableView;
    
    // footerView中被选中的model
    AnimationRecordModel *_selectedModel;
    
    // 阻尼动画的主要View;
    UIView *_downView;
}

/** tableView的底部 */
@property (nonatomic, strong) UIScrollView *tableFooterViewSC;
/** 动画工具类 */
@property (nonatomic, strong) JhtAnimationTools *animationTools;

@end


@implementation AnimationViewController

/** 屏幕的宽度 */
#define FrameW [UIScreen mainScreen].bounds.size.width
/** 屏幕的高度 */
#define FrameH [UIScreen mainScreen].bounds.size.height

- (void)viewWillAppear:(BOOL)animated  {
    [super viewWillAppear:animated];
    
    // 给标题添加点击事件 ~ 开始阻尼动画
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(80, 0, FrameW - 80, 64)];
    btn.tag = 123;
    [btn addTarget:self action:@selector(dumpingBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.view addSubview:btn];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // 关闭阻尼动画
    [[JhtAnimationTools sharedInstance] aniCloseDampingAnimation];
    
    // 移除导航栏开始阻尼动画的Btn
    UIButton *btn = (UIButton *)[self.navigationController.view viewWithTag:123];
    [btn removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航栏
    [self animationSetNav];
    
    // 初始化相关控件和参数
    [self animationInit];
    
    // 创建UI界面
    [self aniCreateUI];
    
    // 创建阻尼动画
    [self aniCreateDampingUI];
}



#pragma mark - 设置导航栏
/** 设置导航栏 */
- (void)animationSetNav {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = UIColorFromRGB(0xFAFAFA);
    UILabel *navigationBarTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 80)];
    navigationBarTitleLabel.text = @"点我有惊喜哟！";
    navigationBarTitleLabel.font = [UIFont boldSystemFontOfSize:18];
    navigationBarTitleLabel.textAlignment = NSTextAlignmentCenter;
    navigationBarTitleLabel.textColor = UIColorFromRGB(0x55AABB);;
    self.navigationItem.titleView = navigationBarTitleLabel;
}

/** 给标题添加点击事件 */
- (void)dumpingBtnClick{
    [self starDampingAnimation];
}

#pragma mark 开始阻尼动画
/** 开始阻尼动画 */
- (void)starDampingAnimation {
    // 开始动画
    [[JhtAnimationTools sharedInstance] aniStartDampingAnimation];
}



#pragma mark - 初始化相关控件和参数
/** 初始化相关控件和参数 */
- (void)animationInit {
    // 数据源数组
    _sourceArray = [[NSMutableArray alloc] init];
    
    // 底部的数据源数组
    _tableFooterViewDataArray = [[NSMutableArray alloc] init];
    
    NSArray *titleArray = @[@"滑板", @"击剑", @"课间操", @"篮球", @"爬山", @"跑步", @"乒乓球", @"散步", @"跆拳道", @"踢毽子", @"跳绳", @"跳舞", @"网球", @"游泳", @"体操", @"自行车", @"足球"];
    for (NSInteger i = 0; i < titleArray.count; i ++) {
        // 获取bundle中的动画图片
        NSString *loadImageDic = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"JhtShopCarAnimationImages.bundle"];
        NSString *loadImagePath = [loadImageDic stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld", i]];
        AnimationRecordModel *model = [[AnimationRecordModel alloc] init];
        model.record_icon = loadImagePath;
        model.record_name = titleArray[i];
        [_tableFooterViewDataArray addObject:model];
    }
}



#pragma mark - 创建UI界面
/** 创建UI界面 */
- (void)aniCreateUI {
    // tableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, FrameW, FrameH - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 设置tableView不可滚动
    _tableView.scrollEnabled = NO;
    _tableView.contentSize = CGSizeMake(FrameW, _tableFooterViewDataArray.count*40);
    [self.view addSubview:_tableView];
    
    _tableView.tableFooterView = self.tableFooterViewSC;
}

#pragma mark get tableFooterViewSC
/** get tableFooterViewSC */
- (UIView *)tableFooterViewSC {
    CGFloat space  = ((FrameW - 45 - 60/2*5)/4);
    CGFloat height = 0;
    if (!_tableFooterViewSC) {
        if (_sourceArray.count != 0) {
            height = FrameH - 64 - _sourceArray.count*40;
        } else {
            height = FrameH - 64 - 40;
        }
        _tableFooterViewSC = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, FrameW, height)];
        _tableFooterViewSC.delegate = self;
        _tableFooterViewSC.backgroundColor = UIColorFromRGB(0xFAFAFA);
        _tableFooterViewSC.showsHorizontalScrollIndicator = NO;
        
        // 生成一堆小的项目图标&文字
        for (NSInteger i = 0; i < _tableFooterViewDataArray.count; i ++) {
            AnimationRecordModel *model = [_tableFooterViewDataArray objectAtIndex:i];
            // 小图标和小图标下边label的背景
            UIView *smallView = [[UIView alloc] initWithFrame:CGRectMake(45/2 + i%5*(30 + space), 15 + i/5*(95/2 + 17), (30 + space), 95/2)];
            smallView.tag = 100+i;
            
            // 小图标
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
            imageView.tag = 200 + i;
            imageView.userInteractionEnabled = YES;
            imageView.image = [UIImage imageWithContentsOfFile:model.record_icon];
            [smallView addSubview:imageView];
            
            // 小图标下边的文字
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(-12, 68/2, imageView.frame.size.width + 24, (95 - 68)/2)];
            label.text = model.record_name;
            label.font = [UIFont systemFontOfSize:12];
            label.textColor = UIColorFromRGB(0x666666);
            label.backgroundColor = [UIColor clearColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.tag = 300 + i;
            [smallView addSubview:label];
            
            // 扣在小图标和小图标下边label的背景 上的btn
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, imageView.frame.size.width, 95/2)];
            btn.tag = 400 + i;
            [btn addTarget:self action:@selector(aniFootViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [smallView addSubview:btn];
            
            [_tableFooterViewSC addSubview:smallView];
            _tableFooterViewSC.frame = CGRectMake(0, 0, FrameW, height);
            _tableFooterViewSC.contentSize = CGSizeMake(FrameW, 15 + (_tableFooterViewDataArray.count - 1)/5*(95/2 + 34/2) + 95/2);
        }
    }
    return _tableFooterViewSC;
}

#pragma mark 点击footerView中小图标触发事件
/** 点击footerView中小图标触发事件 */
- (void)aniFootViewBtnClick:(UIButton *)btn {
    if (_sourceArray.count >= 11) {
        // 收起键盘
        [self.view endEditing:YES];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"可以上传11个以下项目！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    NSInteger index = btn.tag - 400;
    UIView *smallView = btn.superview;
    
    NSLog(@"%@", _sourceArray);
    // model转换
    AnimationRecordModel *model = [_tableFooterViewDataArray objectAtIndex:index];
    _selectedModel = [[AnimationRecordModel alloc] init];
    _selectedModel.record_icon = model.record_icon;
    _selectedModel.record_name = model.record_name;
    
    // 判断是否重复添加
    BOOL isContain = NO;
    for (AnimationRecordModel *subModel in _sourceArray) {
        if ([subModel.record_name isEqualToString:_selectedModel.record_name]) {
            isContain = YES;
            break;
        }
    }
    // 重复添加的提示
    if (isContain) {
        // 收起键盘
        [self.view endEditing:YES];
        NSLog(@"您已选择此项目！");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"您已选择此项目！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    UIImageView *imageView = (UIImageView *)[smallView viewWithTag:200+index];
    CGRect frame = [imageView.superview convertRect:imageView.frame toView:self.view];
    
    // 关闭self.view交互，防止重复添加
    self.view.userInteractionEnabled = NO;
    
    [self anistartShopCarAnimationWithRect:frame ImageView:imageView];
}

#pragma mark 购物车动画
/** 购物车动画 */
- (void)anistartShopCarAnimationWithRect:(CGRect)rect ImageView:(UIImageView *)imageView {
    // 动画结束点
    CGPoint lastPoint = CGPointMake(10 + 30/2, 5 + 30/2);
    /**************************用默认的时候这些都不用写********************************************/
     
     // 我找个中间控制点，但是我想判断是从上向下抛物线 还是 从下向上抛物线
     NSInteger a = lastPoint.x - imageView.frame.origin.x;
     // 取起点和终点的距离
     NSInteger lastPointToStartPoint = a > 0 ? a : -a;
     // 取.x最小的
     NSInteger b = lastPoint.x < imageView.frame.origin.x ? lastPoint.x : imageView.frame.origin.x;
     // 控制点：
     CGPoint controlPoint = CGPointMake(b + lastPointToStartPoint / 3, 0);
    
    /**************************用默认的时候这些都不用写********************************************/
    /**
     * rect: 动画开始的坐标; 如果rect传CGRectZero,则用默认开始坐标;
     * imageView: 动画对应的imageView;
     * view : 在哪个view上显示 （一般传self.view）;
     * lastPoint: 动画结束的坐标点;
     * controlPoint: 动画过程中抛物线的中间转折点;
     * per: 决定控制点，起点和终点X坐标之间距离 1/per; 注:如果per <= 0, 则控制点由controlPoint决定,否则控制点由per决定;
     * expandAnimationTime: 动画变大的时间
     * narrowAnimationTime: 动画变小的时间
     * animationValue: 动画变大过程中，变为原来的几倍大
     * 注意 : 如果动画过程中，你不想让图片变大变小，保持原来的大小运动，传值如下:
             expandAnimationTime:0.0f
             narrowAnimationTime : 动画总共的时间；
             animationValue:1.0f
     */
    // 非默认 控制点 的例子
//    [self.animationTools aniStartShopCarAnimationWithStartRect:rect withImageView:imageView withView:self.view withEndPoint:lastPoint withControlPoint:controlPoint withStartToEndSpacePercentage:-1 withExpandAnimationTime:0.5 withNarrowAnimationTime:0.5 withAnimationValue:2.0f];
    
    // 动画过程中，大小不变 的例子
//    [self.animationTools aniStartShopCarAnimationWithStartRect:rect withImageView:imageView withView:self.view withEndPoint:lastPoint withControlPoint:CGPointZero withStartToEndSpacePercentage:4 withExpandAnimationTime:0.0f  withNarrowAnimationTime:0.8f withAnimationValue:1.0f];
    // 用默认控制点 的例子
    [self.animationTools aniStartShopCarAnimationWithStartRect:rect withImageView:imageView withView:self.view withEndPoint:lastPoint withControlPoint:CGPointZero withStartToEndSpacePercentage:4 withExpandAnimationTime:0.5f  withNarrowAnimationTime:0.5f withAnimationValue:2.0f];
}

#pragma mark get animationTools
/** get animationTools */
- (JhtAnimationTools *)animationTools {
    if (!_animationTools) {
       _animationTools = [JhtAnimationTools sharedInstance];
       _animationTools.toolsDelegate = self;
    }
    return _animationTools;
}



#pragma mark - titleView的button ~ 阻尼动画
/** 创建阻尼动画 */
- (void)aniCreateDampingUI {
    // 开始动画
    _downView = [self.animationTools aniDampingAnimationWithFView:self.view withFrame:CGRectMake(0, -250, FrameW, 250) withBackgroundColor:UIColorFromRGB(0xfd4444) isNeedBlackView:YES];
    [self.navigationController.view addSubview:_downView];
    [self.view bringSubviewToFront:_downView];
    
    // 如果你后续想往 这个downView上添加东西，都可以写在外面了，因为downView已经暴露出来了
    UILabel *showLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (CGRectGetHeight(_downView.frame) - CGRectGetHeight(_downView.frame)/2)/2 + 50, CGRectGetWidth(_downView.frame), CGRectGetHeight(_downView.frame)/2)];
    showLabel.text = @"Wow,这你都试出来啦!" ;
    showLabel.font = [UIFont boldSystemFontOfSize:18];
    showLabel.textColor = [UIColor whiteColor];
    showLabel.numberOfLines = 0;
    showLabel.layer.masksToBounds = YES;
    showLabel.backgroundColor = [UIColor clearColor];
    showLabel.textAlignment = NSTextAlignmentCenter;
    [_downView addSubview:showLabel];
}



#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_sourceArray.count != 0) {
        return _sourceArray.count;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_sourceArray.count != 0) {
        // 有数据
        AnimationRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[AnimationRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        
        if (indexPath.row == 0) {
            NSLog(@"%f , %f",cell.headerImageView.center.x,cell.headerImageView.center.y);
        }
        AnimationRecordModel *model = [_sourceArray objectAtIndex:indexPath.row];
        cell.headerImageView.image = [UIImage imageWithContentsOfFile:model.record_icon];
        cell.titleLabel.text = model.record_name;
        // 设置最下边那个cell底部线的坐标
        if (indexPath.row != _sourceArray.count - 1) {
            cell.lineLabel.frame = CGRectMake(100/2, 40 - 0.6,FrameW - 100/2, 0.6);
        } else {
            cell.lineLabel.frame = CGRectMake(0, 40 - 0.6,FrameW, 0.6);
        }
        
        // 尾部的删除按钮
        cell.wrongBtn.tag = 300 + indexPath.row;
        [cell.wrongBtn addTarget:self action:@selector(aniDeleteCellBtn:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    } else {
        // 无数据
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kong"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"kong"];
            // 底部的分割线
            UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40-0.6,FrameW, 0.6)];
            lineLabel.backgroundColor = UIColorFromRGB(0xCCCCCC);
            [cell.contentView addSubview:lineLabel];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"点击图标能飞哟！";
        cell.textLabel.textColor = UIColorFromRGB(0x666666);
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
        return cell;
    }
}



#pragma mark - cell内点击事件
#pragma mark 删除某一个cell
/** 删除某一个cell */
- (void)aniDeleteCellBtn:(UIButton *)btn {
    // 数据源数组中所对应的位置
    NSInteger index = btn.tag - 300;
    // 删除对应的数据源model并刷新tableView
    [_sourceArray removeObjectAtIndex:index];
    [_tableView reloadData];
    
    [self animationUpdateSCFrame];
}



#pragma mark - JhtAnimationToolsDelegate
/**
 * type == 0 购物车的动画
 * type == 1 阻尼动画
 * isStop: Yes动画结束， No动画过程中
 */
- (void)JhtAnimationWithType:(NSInteger)type isDidStop:(BOOL)isStop {
    // 动画结束的代理
    if (isStop) {
        if (type == 0) {
            // 购物车的动画结束了
            self.view.userInteractionEnabled = YES;
            
            // 添加数据源并刷新
            [_sourceArray insertObject:_selectedModel atIndex:0];
            [_tableView reloadData];
            [self animationUpdateSCFrame];
            [self.animationTools.shopLayer removeFromSuperlayer];
            self.animationTools.shopLayer = nil;
        } else if (type == 1) {
            // 阻尼动画结束了
            NSLog(@"阻尼动画结束了");
        }
    } else {
        // 动画过程中的代理
        if (type == 1) {
            _downView.frame = CGRectMake(0, -100, FrameW, 250);
        }
    }
}


#pragma mark -  更新sc坐标
/** 更新sc坐标 */
- (void)animationUpdateSCFrame {
    // 首先重置
    _tableFooterViewSC.contentOffset = CGPointZero;
    CGFloat height = 0;
    if (_sourceArray.count != 0) {
        height = FrameH - 64 - _sourceArray.count*40;
    } else {
        height = FrameH - 64 - 40;
    }
    _tableFooterViewSC.frame = CGRectMake(0, 0, FrameW, height);
    _tableView.tableFooterView = _tableFooterViewSC;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
