//
//  FanSideslipManager.h
//  FanSideslip
//
//  Created by 向阳凡 on 2019/1/22.
//  Copyright © 2019 向阳凡. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


/*  侧滑抽屉效果（覆盖移动|平移）
 *  1.初始化（左右都有抽屉，可以都加上）
     LeftViewController *vc=[[LeftViewController alloc]init];
     UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:vc];
     [FanSideslipManager shareManager].leftViewController=nav;
 
     RightViewController *vc1=[[RightViewController alloc]init];
     UINavigationController *nav1=[[UINavigationController alloc]initWithRootViewController:vc1];
     [FanSideslipManager shareManager].rightViewController=nav1;
 
    //这里是中间的viewVC，用做平移时，移动动画需要，也可以不传，自己在回调里面，控制主VC的移动
    [FanSideslipManager shareManager].centerViewController=self;
 
    2.显示抽屉(同时只能显示一个)
     [[FanSideslipManager shareManager]showSideslipType:FanSideslipTypeLeft showProgress:0.7];
     [[FanSideslipManager shareManager]showSideslipType:FanSideslipTypeRight showProgress:0.7];

    3.属性修改
 
    [FanSideslipManager shareManager].animationDuration=0.5;
    //这个属性开启后，要自己定义抽屉出现的动画和消失的动画（结合回调BLock）
    [FanSideslipManager shareManager].customAnimation=YES;
    //下面两个方法，用户不用自己写抽屉隐藏的效果和按钮
    [FanSideslipManager shareManager].autoHidden=YES;//开启此方法，自己不用写隐藏的方法
    //除抽屉外其他区域的颜色
    [FanSideslipManager shareManager].spaceColor=[[UIColor blackColor]colorWithAlphaComponent:0.5];
 
    4.回调
     //抽屉显示和隐藏的回调
     [[FanSideslipManager shareManager] setSideslipBlock:^(FanSideslipType sideslipType, BOOL isShow) {
     }];
 
     //左右界面其他按钮操作回调（包含传递参数）
     [[FanSideslipManager shareManager]setSideslipcControlBlock:^(NSUInteger controlType, id  _Nullable paramInfo) {
     }];
 *
 *  注意：1.本抽屉是基于window做的，而且，左右抽屉可以是UIViewController  UINavigationController  UITabBarController
            这样做的好处就是，左右视图比较独立，而且便于做横竖屏适配
         2.我没有做，改变leftVC的frame宽度，而是全屏宽度显示，一半透明到底部，可以实现，在抽屉界面继续跳转下一页，不然，跳转后要跳转的界面只是
            不能铺满屏
         3.我写了两个回调，可以自由定制动画，自由控制界面间传值
         4.如果开启autoHidden=YES，一定要控制好self.tapControl显示和隐藏
 *
 *
 */

NS_ASSUME_NONNULL_BEGIN
/*
 *  当类型为 FanSideslipTypeLeft || FanSideslipTypeRight 时，使用默认的系统平移动画，而且是侧滑覆盖在中心View上
 *  但，当类型为 FanSideslipTypeLeftMove || FanSideslipTypeRightMove 时，使用默认的系统平移动画，并且中心View跟谁侧滑一块移动，（其中中心view移动的操作可以用户传入centerViewController属性值默认移动，也可以在自己的block回调里面自己控制平移位置）

 */
///侧滑类型，每次有且只有一个类型
typedef NS_ENUM(NSUInteger,FanSideslipType){
    FanSideslipTypeNone,
    FanSideslipTypeLeft,//centerViewController不使用，
    FanSideslipTypeRight,//centerViewController不使用，
    FanSideslipTypeLeftMove,//centerViewController生效，可以传入
    FanSideslipTypeRightMove //centerViewController生效，可以传入
};



typedef void(^FanSideslipBlock)(FanSideslipType sideslipType,BOOL isShow);

/**
 用来控制左右界面隐藏后，回调数据到中心界面操作

 @param controlType 操作类型，也可以看做按钮枚举
 @param paramInfo 传递参数
 */
typedef void(^FanSideslipControlBlock)(NSUInteger controlType,id _Nullable paramInfo);


@interface FanSideslipManager : NSObject
#pragma mark -  内部属性，不建议更改（暴露出来就是为了你的超高级DIY）
@property (strong, nonatomic) UIWindow *sideslipWindow;
@property (assign, nonatomic) FanSideslipType sideslipType;
#pragma mark -  属性配置(必传项和不必传属性修改)
@property (weak, nonatomic,nullable) UIViewController *centerViewController;//当开启leftMove or rightMove时，可以传入，
@property (strong, nonatomic,nullable) UIViewController *leftViewController;
@property (strong, nonatomic,nullable) UIViewController *rightViewController;
@property (copy, nonatomic) FanSideslipControlBlock sideslipcControlBlock;//左右界面回传数据，主View接收数据做相应操作

@property (copy, nonatomic) FanSideslipBlock sideslipBlock;//显示隐藏时刷新UI的回调

@property (assign, nonatomic) CGFloat sideslipProgress;//滑动出来显示的百分比
@property (assign, nonatomic) NSTimeInterval animationDuration;//默认的全局动画时间是0.27秒

///是否开启自定义动画，默认NO不开起，开启后，用户用回调来处理UI显示和隐藏动画,开启后不要打开autoHidden=YES(不建议-给自己的动画可能不协调)
@property (assign, nonatomic) BOOL customAnimation;

#pragma mark -  开启自动收起侧滑时才生效的属性
//不加人自动收起侧边栏原因，加入点击手势冲突，不能达到适配的完美性，加入点击控件，要每次改变层次关系，并且改变大小约束，还不如让用户自己来控制
@property (assign, nonatomic) BOOL autoHidden;//是否是自动隐藏，默认YES，开启后，侧滑透明的地方点击后自动消失
@property (strong, nonatomic) UIColor *spaceColor;//是否是自动隐藏，默认YES，开启后，侧滑透明的地方点击后自动消失
////点击window空白区域，消失的方法
@property (strong, nonatomic)UIControl *tapControl;

#pragma mark -  方法
//单利
+(instancetype)shareManager;
//释放左右界面
-(void)cleanMemory;
///侧滑显示+默认有平移动画
//-(void)showSideslipType:(FanSideslipType)sideslipType;
///侧滑显示+显示进度（显示内容用户自定义）
-(void)showSideslipType:(FanSideslipType)sideslipType showProgress:(CGFloat)progress;
-(void)hideSideslipNOAnimation;//隐藏动画没有动画，直接隐藏
-(void)hideSideslip;//隐藏包含有动画


#pragma mark -  其他工具类
//获取当前window
+ (UIWindow *)mainWindow;
@end

NS_ASSUME_NONNULL_END
