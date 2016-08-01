# JhtShopCarAnimationDemo

## Contents
#### 购物车抛物线动画 <br>
#### 阻尼动画 <br>
## needed to pay attention.

### 1.这是一个轻量级的动画文件，可以实现购物车的上抛 && 下抛动画；此外我还写了一个简单的阻尼动画，供大家交流使用！  <br>
<img src="https://raw.githubusercontent.com/jinht/JhtShopCarAnimationDemo/master/ReadMEImages/1.gif"  width=250 height=445 /> <br>
 
### 2.使用起来比较方便，只需导入 JhtAnimationTools.h 头文件即可。  <br>
(1) 购物车动画 <br>
```oc
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
 - (void)aniStartShopCarAnimationWithStartRect:(CGRect)rect withImageView:(UIImageView *)imageView withView:(UIView *)view withEndPoint:(CGPoint)lastPoint withControlPoint:(CGPoint)controlPoint withStartToEndSpacePercentage:(NSInteger)per withExpandAnimationTime:(CFTimeInterval)expandAnimationTime withNarrowAnimationTime:(CFTimeInterval)narrowAnimationTime withAnimationValue:(CGFloat)animationValue;
```
(2) 阻尼动画 <br>
* 创建阻尼动画的View<br>
```oc
/** 获得的阻尼动画的View
  * view：黑色背景View的父view(例如:self.view);
  * frame：是这个阻尼View的坐标
  * isBlack：yes 需要出现黑色背景， no不需要
  * bgColor：背景颜色
 */
 - (UIView *)aniDampingAnimationWithFView:(UIView *)view withFrame:(CGRect)frame withBackgroundColor:(UIColor *)bgColor isNeedBlackView:(BOOL)isBlack;
```
* 阻尼动画相关使用方法<br>
```oc
/** 开始动画阻尼动画 */
- (void)aniStartDampingAnimation;
/** 关闭阻尼动画 */
- (void)aniCloseDampingAnimation;
/** 获得阻尼动画的黑色背景 */
- (UIView *)aniGetDampingBlackView;
```

(3) 动画的代理方法<br>
```oc
/**
  * type == 0 购物车的动画
  * type == 1 阻尼动画
  * isStop: Yes动画结束， No动画过程中
 */
 - (void)JhtAnimationWithType:(NSInteger)type isDidStop:(BOOL)isStop;
```

###Remind
* ARC
* iOS >= 7.0
* iPhone \ iPad 

## Hope
* If you find bug when used，Hope you can Issues me，Thank you or try to download the latest code of this framework to see the BUG has been fixed or not
* If you find the function is not enough when used，Hope you can Issues me，I very much to add more useful function to this framework ，Thank you !

