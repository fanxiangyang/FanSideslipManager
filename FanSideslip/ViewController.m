//
//  ViewController.m
//  FanSideslip
//
//  Created by 向阳凡 on 2019/1/22.
//  Copyright © 2019 向阳凡. All rights reserved.
//

#import "ViewController.h"
#import "FanSideslipManager.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "SecondViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSArray *titleArray=@[@"覆盖移动左抽屉",@"覆盖移动右抽屉",@"平移左抽屉",@"平移右抽屉",@"自定义动画",@"autoHidden=YES"];
    for (int i=0; i<titleArray.count; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame=CGRectMake(50, 100+i*50, 150, 30);
        btn.backgroundColor=[UIColor colorWithWhite:0.6 alpha:1];
        [btn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
        btn.tag=100+i;
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:btn];
    }
    
    LeftViewController *vc=[[LeftViewController alloc]init];
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:vc];
    [FanSideslipManager shareManager].leftViewController=nav;
    
    RightViewController *vc1=[[RightViewController alloc]init];
    UINavigationController *nav1=[[UINavigationController alloc]initWithRootViewController:vc1];
    [FanSideslipManager shareManager].rightViewController=nav1;
        
    [FanSideslipManager shareManager].centerViewController=self;
    
    [FanSideslipManager shareManager].animationDuration=0.5;
//    [FanSideslipManager shareManager].customAnimation=YES;
    
    __weak typeof(self)weakSelf=self;
    [[FanSideslipManager shareManager] setSideslipBlock:^(FanSideslipType sideslipType, BOOL isShow) {
        [weakSelf sideslipType:sideslipType isShow:isShow];
    }];

    //左右界面操作回调
    [[FanSideslipManager shareManager]setSideslipcControlBlock:^(NSUInteger controlType, id  _Nullable paramInfo) {
        [self sideslipTypeControlType:controlType paramInfo:paramInfo];
    }];
    
}
-(void)sideslipType:(FanSideslipType)sideslipType isShow:(BOOL)isShow{
    if (isShow) {
//        if (sideslipType==FanSideslipTypeLeftMove) {
//            [UIView animateWithDuration:0.27 animations:^{
//                self.view.frame=CGRectMake([[UIScreen mainScreen] bounds].size.width*0.7, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
//            }];
//        }
    }else{
//        if (sideslipType==FanSideslipTypeLeftMove) {
//            [UIView animateWithDuration:0.27 animations:^{
//                self.view.frame=CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
//            }completion:^(BOOL finished) {
//                [[FanSideslipManager shareManager]hideSideslip];
//            }];
//        }
        if ([FanSideslipManager shareManager].customAnimation==YES) {
            [FanSideslipManager shareManager].customAnimation=NO;
            UINavigationController *nav = (UINavigationController *) [FanSideslipManager shareManager].leftViewController;
            LeftViewController *leftVC = nav.viewControllers[0];
            leftVC.customAnimation=NO;
            
            [nav.view.layer addAnimation:[ViewController fan_transitionAnimationWithSubType:kCATransitionFromRight withType:@"oglFlip" duration:0.5] forKey:@"nav"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[FanSideslipManager mainWindow]makeKeyAndVisible];
            });
        }
    }
}
-(void)sideslipTypeControlType:(NSUInteger)controlType paramInfo:(id) paramInfo{
    if (controlType==1) {
        
        SecondViewController *vc=[[SecondViewController alloc]init];
        [self presentViewController:vc animated:YES completion:^{
            
        }];
    }
}
-(void)btnClick:(UIButton *)btn{
   
    switch (btn.tag-100) {
        case 0:
        {
            
            [[FanSideslipManager shareManager]showSideslipType:FanSideslipTypeLeft showProgress:0.7];
        }
            break;
        case 1:
        {
            [[FanSideslipManager shareManager]showSideslipType:FanSideslipTypeRight showProgress:0.6];
        }
            break;
        case 2:
        {
            [[FanSideslipManager shareManager]showSideslipType:FanSideslipTypeLeftMove showProgress:0.7];

        }
            break;
        case 3:
        {
            [[FanSideslipManager shareManager]showSideslipType:FanSideslipTypeRightMove showProgress:0.6];

        }
            break;
        case 4:
        {
            //自定义抽屉出现动画
            [FanSideslipManager shareManager].customAnimation=YES;
            UINavigationController *nav = (UINavigationController *) [FanSideslipManager shareManager].leftViewController;
            LeftViewController *leftVC = nav.viewControllers[0];
            leftVC.customAnimation=YES;
            
            [[FanSideslipManager shareManager]showSideslipType:FanSideslipTypeLeft showProgress:0.7];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                nav.view.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
                [nav.view.layer addAnimation:[ViewController fan_transitionAnimationWithSubType:kCATransitionFromLeft withType:@"oglFlip" duration:0.5] forKey:@"nav"];
            });
        }
            break;
        case 5:
        {
            [FanSideslipManager shareManager].autoHidden=YES;//开启此方法，自己不用写隐藏的方法
            [FanSideslipManager shareManager].spaceColor=[[UIColor blackColor]colorWithAlphaComponent:0.5];

            
        }
            break;
        default:
            break;
    }
    
    if ([FanSideslipManager shareManager].autoHidden) {
        [FanSideslipManager shareManager].tapControl.hidden=NO;
    }
}

/**动画切换页面的效果(CATransition)
 *subType 方向 kCATransitionFromBottom ....
 *subtypes: kCAAnimationCubic迅速透明移动,cube 3D立方体翻页 pageCurl从一个角翻页，
 *          pageUnCurl反翻页，rippleEffect水波效果，suckEffect缩放到一个角,oglFlip中心立体翻转
 *          (kCATransitionFade淡出，kCATransitionMoveIn覆盖原图，kCATransitionPush推出，kCATransitionReveal卷轴效果)
 */
+(CATransition *)fan_transitionAnimationWithSubType:(NSString *)subType withType:(NSString *)xiaoguo duration:(CGFloat)duration
{
    CATransition *animation=[CATransition animation];
    //立体翻转的效果cube ,rippleEffect,(水波）
    [animation setType:xiaoguo];
    //设置动画方向
    [animation setSubtype:subType];
    //设置动画的动作时长
    [animation setDuration:duration];
    //均匀的作用效果
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    return animation;
}
@end
