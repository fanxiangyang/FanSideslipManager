# FanSideslipManager（iOS7+）左右侧滑
本项目是基于iOS9以上的，基于window的左右侧滑界面，只支持点击，出现侧滑，不支持时时滑动（可以自己修改封装，不难，可以借鉴我的另外一个项目[滑动缩放侧滑FanQQSideslipManager](https://github.com/fanxiangyang/FanQQSideslipManager) ）

##### 预览动画

![动画](https://github.com/fanxiangyang/FanSideslipManager/blob/master/Document/sideslip.gif?raw=true)

###  功能介绍
*	1.左右覆盖侧滑
*	2.左右平移侧滑
* 	3.自定义动画侧滑

##### 1.初始化 （左右都有抽屉，可以都加上） 
```
//左抽屉
LeftViewController *vc=[[LeftViewController alloc]init];
UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:vc];
[FanSideslipManager shareManager].leftViewController=nav;
//右抽屉
RightViewController *vc1=[[RightViewController alloc]init];
UINavigationController *nav1=[[UINavigationController alloc]initWithRootViewController:vc1];
[FanSideslipManager shareManager].rightViewController=nav1;
 
//这里是中间的viewVC，用做平移时，移动动画需要，也可以不传，自己在回调里面，控制主VC的移动
[FanSideslipManager shareManager].centerViewController=self;
```
##### 2.显示抽屉(同时只能显示一个)
```
[[FanSideslipManager shareManager]showSideslipType:FanSideslipTypeLeft showProgress:0.7];
[[FanSideslipManager shareManager]showSideslipType:FanSideslipTypeRight showProgress:0.7];

``` 
##### 3.其他属性值修改
```
//抽屉出现和隐藏动画的时间，默认是0.27s
[FanSideslipManager shareManager].animationDuration=0.5;
//这个属性开启后，要自己定义抽屉出现的动画和消失的动画（结合回调BLock）
[FanSideslipManager shareManager].customAnimation=YES;
//下面两个方法，用户不用自己写抽屉隐藏的效果和按钮
[FanSideslipManager shareManager].autoHidden=YES;//开启此方法，自己不用写隐藏的方法
//除抽屉外其他区域的颜色
[FanSideslipManager shareManager].spaceColor=[[UIColor blackColor]colorWithAlphaComponent:0.5];
 
```
##### 4.block回调
```
 //抽屉显示和隐藏的回调
 [[FanSideslipManager shareManager] setSideslipBlock:^(FanSideslipType sideslipType, BOOL isShow) {
 }];
 
 //左右界面其他按钮操作回调（包含传递参数）
 [[FanSideslipManager shareManager]setSideslipcControlBlock:^(NSUInteger controlType, id  _Nullable paramInfo) {
 }];

```
### 注意：
```
 1.本抽屉是基于window做的，而且，左右抽屉可以是UIViewController  UINavigationController  UITabBarController
            这样做的好处就是，左右视图比较独立，而且便于做横竖屏适配
 2.我没有做，改变leftVC的frame宽度，而是全屏宽度显示，一半透明到底部，可以实现，在抽屉界面继续跳转下一页，不然，跳转后要跳转的界面只是
    不能铺满屏
 3.我写了两个回调，可以自由定制动画，自由控制界面间传值
 4.如果开启autoHidden=YES，一定要控制好self.tapControl显示和隐藏（还是不开启这个功能好）

```
Like(喜欢)
==============
#### 有问题请直接在文章下面留言,喜欢就给个Star(小星星)吧！ 
#### 简书博客:[风清水遥](https://www.jianshu.com/u/13d4a8b7949a)
#### Email:<fqsyfan@gmail.com>
