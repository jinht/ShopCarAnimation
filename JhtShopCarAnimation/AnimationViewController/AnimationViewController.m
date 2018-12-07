//
//  ViewController.m
//  JhtShopCarAnimation
//
//  GitHub主页: https://github.com/jinht
//  CSDN博客: http://blog.csdn.net/anticipate91
//
//  Created by Jht on 16/5/17.
//  Copyright © 2016年 JhtShopCarAnimation. All rights reserved.
//

#import "AnimationViewController.h"
#import "JhtAnimationTools.h"
#import "AnimationRecordCell.h"
#import "AnimationRecordModel.h"

@interface AnimationViewController () <UITableViewDataSource, UITableViewDelegate, JhtAnimationToolsDelegate> {
    NSMutableArray *_sourceArray;
    NSMutableArray *_tableFooterViewDataArray;
    
    AnimationRecordModel *_selectedModel;
    
    UIView *_downView;
}

@property (nonatomic, strong) UILabel *navBarLabel;

@property (nonatomic, strong) UITableView *insideTableView;
@property (nonatomic, strong) UIScrollView *tableFooterViewSC;

@property (nonatomic, strong) JhtAnimationTools *animationTools;

@end


#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define FrameW [UIScreen mainScreen].bounds.size.width
#define FrameH [UIScreen mainScreen].bounds.size.height

@implementation AnimationViewController

- (void)viewWillAppear:(BOOL)animated  {
    [super viewWillAppear:animated];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(80, 0, FrameW - 80, 64)];
    btn.tag = 123;
    [btn addTarget:self action:@selector(starDampingAnimation) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.view addSubview:btn];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[JhtAnimationTools sharedInstance] aniCloseDampingAnimation];
    
    UIButton *btn = (UIButton *)[self.navigationController.view viewWithTag:123];
    [btn removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = UIColorFromRGB(0xFAFAFA);
    
    self.navigationItem.titleView = self.navBarLabel;
    
    // 初始化相关控件和参数
    [self animationInit];
    
    [self.view addSubview:self.insideTableView];
    self.insideTableView.tableFooterView = self.tableFooterViewSC;
    
    // 创建阻尼动画
    [self aniCreateDampingUI];
}



#pragma mark - init param
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



#pragma mark - Get
- (UILabel *)navBarLabel {
    if (!_navBarLabel) {
        _navBarLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 80)];
        _navBarLabel.text = @"点我有惊喜哟！";
        _navBarLabel.font = [UIFont boldSystemFontOfSize:18];
        _navBarLabel.textAlignment = NSTextAlignmentCenter;
        _navBarLabel.textColor = UIColorFromRGB(0x55AABB);
    }
    
    return _navBarLabel;
}

- (UITableView *)insideTableView {
    if (!_insideTableView) {
        _insideTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, FrameW, FrameH - 64) style:UITableViewStylePlain];
        _insideTableView.delegate = self;
        _insideTableView.dataSource = self;
        _insideTableView.showsVerticalScrollIndicator = NO;
        _insideTableView.showsHorizontalScrollIndicator = NO;
        _insideTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _insideTableView.scrollEnabled = NO;
        _insideTableView.contentSize = CGSizeMake(FrameW, _tableFooterViewDataArray.count * 40);
    }
    
    return _insideTableView;
}

- (UIScrollView *)tableFooterViewSC {
    if (!_tableFooterViewSC) {
        CGFloat space = ((FrameW - 45 - 60 / 2 * 5) / 4);
        CGFloat height = 0;
        
        if (_sourceArray.count != 0) {
            height = FrameH - 64 - _sourceArray.count * 40;
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
            UIView *smallView = [[UIView alloc] initWithFrame:CGRectMake(45 / 2 + i % 5 * (30 + space), 15 + i / 5 * (95 / 2 + 17), (30 + space), 95 / 2)];
            smallView.tag = 100 + i;
            
            // 小图标
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
            imageView.tag = 200 + i;
            imageView.userInteractionEnabled = YES;
            imageView.image = [UIImage imageWithContentsOfFile:model.record_icon];
            [smallView addSubview:imageView];
            
            // 小图标下边的文字
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(-12, 68 / 2, CGRectGetWidth(imageView.frame) + 24, (95 - 68) / 2)];
            label.text = model.record_name;
            label.font = [UIFont systemFontOfSize:12];
            label.textColor = UIColorFromRGB(0x666666);
            label.backgroundColor = [UIColor clearColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.tag = 300 + i;
            [smallView addSubview:label];
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, imageView.frame.size.width, 95/2)];
            btn.tag = 400 + i;
            [btn addTarget:self action:@selector(aniFootViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [smallView addSubview:btn];
            [_tableFooterViewSC addSubview:smallView];
            _tableFooterViewSC.frame = CGRectMake(0, 0, FrameW, height);
            _tableFooterViewSC.contentSize = CGSizeMake(FrameW, 15 + (_tableFooterViewDataArray.count - 1) / 5 * (95 / 2 + 34 / 2) + 95 / 2);
        }
    }
    
    return _tableFooterViewSC;
}

- (JhtAnimationTools *)animationTools {
    if (!_animationTools) {
        _animationTools = [JhtAnimationTools sharedInstance];
        _animationTools.toolsDelegate = self;
    }
    
    return _animationTools;
}


#pragma mark Get Method
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
    // 提示 重复添加
    if (isContain) {
        // 收起键盘
        [self.view endEditing:YES];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"您已选择此项目！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        
        return;
    }
    
    UIImageView *imageView = (UIImageView *)[smallView viewWithTag:200 + index];
    CGRect frame = [imageView.superview convertRect:imageView.frame toView:self.view];
    
    self.view.userInteractionEnabled = NO;
    
    [self anistartShopCarAnimationWithRect:frame ImageView:imageView];
}

/** 购物车动画 */
- (void)anistartShopCarAnimationWithRect:(CGRect)rect ImageView:(UIImageView *)imageView {
    // 动画结束点
    CGPoint lastPoint = CGPointMake(10 + 30 / 2, 5 + 30 / 2);
    /********** 用默认的时候这些都不用写 ************/
    // 我找个中间控制点，但是我想判断是从上向下抛物线 还是 从下向上抛物线
    NSInteger a = lastPoint.x - imageView.frame.origin.x;
    // 取起点和终点的距离
    NSInteger lastPointToStartPoint = a > 0 ? a : -a;
    // 取.x最小的
    NSInteger b = lastPoint.x < imageView.frame.origin.x ? lastPoint.x : imageView.frame.origin.x;
    // 控制点
    CGPoint controlPoint = CGPointMake(b + lastPointToStartPoint / 3, 0);
    /********** 用默认的时候这些都不用写 ************/
    // 非默认 控制点 的例子
    //    [self.animationTools aniStartShopCarAnimationWithStartRect:rect withImageView:imageView superView:self.view withEndPoint:lastPoint withControlPoint:controlPoint withStartToEndSpacePercentage:-1 withExpandAnimationTime:0.5 withNarrowAnimationTime:0.5 withAnimationValue:2.0f];
    
    // 动画过程中，大小不变 的例子
    //    [self.animationTools aniStartShopCarAnimationWithStartRect:rect withImageView:imageView superView:self.view withEndPoint:lastPoint withControlPoint:CGPointZero withStartToEndSpacePercentage:4 withExpandAnimationTime:0.0f  withNarrowAnimationTime:0.8f withAnimationValue:1.0f];
    // 用默认控制点 的例子
    [self.animationTools aniStartShopCarAnimationWithStartRect:rect imageView:imageView superView:self.view endPoint:lastPoint controlPoint:CGPointZero startToEndSpacePercentage:4 expandAnimationTime:0.5f narrowAnimationTime:0.5f animationValue:2.0f];
}



#pragma mark - DampingAnimation
/** 创建阻尼动画 */
- (void)aniCreateDampingUI {
    // 开始动画
    _downView = [self.animationTools aniDampingAnimationWithSuperView:self.view frame:CGRectMake(0, -250, FrameW, 250) backgroundColor:UIColorFromRGB(0xfd4444) isNeedBlackView:YES];
    [self.navigationController.view addSubview:_downView];
    [self.view bringSubviewToFront:_downView];
    
    // 黑色背景的tag值
    extern NSInteger const ATBlackViewTag;
    UIView *vv = [self.view viewWithTag:ATBlackViewTag];
//    NSLog(@"%lf~~~~~%lf", vv.frame.size.width, vv.frame.origin.y);
    
    // 如果你后续想往 这个downView上添加东西，都可以写在外面了，因为downView已经暴露出来了
    UILabel *showLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (CGRectGetHeight(_downView.frame) - CGRectGetHeight(_downView.frame) / 2) / 2 + 50, CGRectGetWidth(_downView.frame), CGRectGetHeight(_downView.frame) / 2)];
    showLabel.text = @"Wow，这你都试出来啦!" ;
    showLabel.font = [UIFont boldSystemFontOfSize:18];
    showLabel.textColor = [UIColor whiteColor];
    showLabel.numberOfLines = 0;
    showLabel.layer.masksToBounds = YES;
    showLabel.backgroundColor = [UIColor clearColor];
    showLabel.textAlignment = NSTextAlignmentCenter;
    [_downView addSubview:showLabel];
}

/** 开始阻尼动画 */
- (void)starDampingAnimation {
    // 开始动画
    [[JhtAnimationTools sharedInstance] aniStartDampingAnimation];
}



#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_sourceArray.count != 0) {
        return _sourceArray.count;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_sourceArray.count != 0) {
        // 有数据
        AnimationRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[AnimationRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        
        AnimationRecordModel *model = [_sourceArray objectAtIndex:indexPath.row];
        cell.formerIcon.image = [UIImage imageWithContentsOfFile:model.record_icon];
        cell.descLabel.text = model.record_name;
        // 设置最下边那个cell底部线的坐标
        if (indexPath.row != _sourceArray.count - 1) {
            cell.lowLine.frame = CGRectMake(100 / 2, 40 - 0.6, FrameW - 100 / 2, 0.6);
        } else {
            cell.lowLine.frame = CGRectMake(0, 40 - 0.6, FrameW, 0.6);
        }
        
        // 尾部的删除按钮
        cell.deleteBtn.tag = 300 + indexPath.row;
        [cell.deleteBtn addTarget:self action:@selector(aniDeleteCellBtn:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    } else {
        // 无数据
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kong"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"kong"];
            // 底部的分割线
            UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40 - 0.6, FrameW, 0.6)];
            lineLabel.backgroundColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.00];
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


#pragma mark UITableViewDelegate Method
/** 删除某一个cell */
- (void)aniDeleteCellBtn:(UIButton *)btn {
    // 数据源数组中所对应的位置
    NSInteger index = btn.tag - 300;
    // 删除对应的数据源model并刷新tableView
    [_sourceArray removeObjectAtIndex:index];
    [self.insideTableView reloadData];
    
    [self animationUpdateSCFrame];
}

/** 更新sc坐标 */
- (void)animationUpdateSCFrame {
    _tableFooterViewSC.contentOffset = CGPointZero;
    CGFloat height = 0;
    if (_sourceArray.count != 0) {
        height = FrameH - 64 - _sourceArray.count * 40;
    } else {
        height = FrameH - 64 - 40;
    }
    _tableFooterViewSC.frame = CGRectMake(0, 0, FrameW, height);
    self.insideTableView.tableFooterView = _tableFooterViewSC;
}



#pragma mark - JhtAnimationToolsDelegate
/** 委托
 *  type == 0 购物车的动画
 *  type == 1 阻尼动画
 *  isStop: Yes动画结束，No动画过程中
 */
- (void)JhtAnimationWithType:(NSInteger)type isDidStop:(BOOL)isStop {
    // 动画结束的代理
    if (isStop) {
        if (type == 0) {
            self.view.userInteractionEnabled = YES;
            
            [_sourceArray insertObject:_selectedModel atIndex:0];
            [self.insideTableView reloadData];
            [self animationUpdateSCFrame];
            [self.animationTools.shopLayer removeFromSuperlayer];
            self.animationTools.shopLayer = nil;
        } else if (type == 1) {
            NSLog(@"阻尼动画结束了");
        }
        
    } else {
        if (type == 1) {
            _downView.frame = CGRectMake(0, -100, FrameW, 250);
        }
    }
}


@end
