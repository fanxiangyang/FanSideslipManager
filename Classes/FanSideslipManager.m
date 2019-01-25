//
//  FanSideslipManager.m
//  FanSideslip
//
//  Created by 向阳凡 on 2019/1/22.
//  Copyright © 2019 向阳凡. All rights reserved.
//

#import "FanSideslipManager.h"
@interface FanSideslipManager()<UIGestureRecognizerDelegate>


@end

@implementation FanSideslipManager

+(instancetype)shareManager{
    static FanSideslipManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager=[[FanSideslipManager alloc]init];
    });
    return manager;
}
-(instancetype)init{
    self=[super init];
    if (self) {
        self.sideslipProgress=0.7;
        self.animationDuration=0.27;
        self.sideslipWindow=[[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
//        self.sideslipWindow.windowLevel=UIWindowLevelNormal+2;
        self.tapControl=[[UIControl alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
        [self.tapControl addTarget:self action:@selector(controlClick:) forControlEvents:UIControlEventTouchUpInside];
//        self.tapControl.backgroundColor=self.spaceColor;
//        [self.sideslipWindow addSubview:self.tapControl];
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}
-(void)cleanMemory{
    self.leftViewController=nil;
    self.rightViewController=nil;
    self.centerViewController=nil;
}
#pragma mark -  getSet

-(void)setAutoHidden:(BOOL)autoHidden{
    _autoHidden=autoHidden;
    if (autoHidden) {
        [self.sideslipWindow addSubview:self.tapControl];
    }else{
        [self.tapControl removeFromSuperview];
    }
}

-(void)setSpaceColor:(UIColor *)spaceColor{
    _spaceColor=spaceColor;
    self.tapControl.backgroundColor=spaceColor;
}
-(void)controlClick:(UIControl *)control{
    [self hideSideslip];
}
#pragma mark - 根据屏幕方向，更新约束关系
- (void)orientationChanged:(NSNotification *)note  {
    UIDeviceOrientation o = [[UIDevice currentDevice] orientation];
    switch (o) {
        case UIDeviceOrientationPortrait:
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            break;
        case UIDeviceOrientationLandscapeLeft:
            break;
        case UIDeviceOrientationLandscapeRight:
            break;
        default:
            break;
    }
    [self refreshUI];
}
-(void)refreshUI{
    if (self.autoHidden) {
        switch (_sideslipType) {
            case FanSideslipTypeNone:
            {
                return;
            }
                break;
            case FanSideslipTypeLeft:
            {
                self.tapControl.frame=CGRectMake([[UIScreen mainScreen] bounds].size.width*self.sideslipProgress, 0, [[UIScreen mainScreen] bounds].size.width*(1-self.sideslipProgress), [[UIScreen mainScreen] bounds].size.height);
                self.tapControl.alpha=1.0;
            }
                break;
            case FanSideslipTypeRight:
            {
                self.tapControl.alpha=1.0;
                self.tapControl.frame=CGRectMake(0,0, [[UIScreen mainScreen] bounds].size.width*(1-self.sideslipProgress), [[UIScreen mainScreen] bounds].size.height);
            }
                break;
            case FanSideslipTypeLeftMove:
            {
                self.tapControl.alpha=1.0;
                self.tapControl.frame=CGRectMake([[UIScreen mainScreen] bounds].size.width*self.sideslipProgress, 0, [[UIScreen mainScreen] bounds].size.width*(1-self.sideslipProgress), [[UIScreen mainScreen] bounds].size.height);
            }
                break;
            case FanSideslipTypeRightMove:
            {
                self.tapControl.alpha=1.0;
                self.tapControl.frame=CGRectMake(0,0, [[UIScreen mainScreen] bounds].size.width*(1-self.sideslipProgress), [[UIScreen mainScreen] bounds].size.height);
            }
                break;
            default:
                break;
        }
    }
}
#pragma mark - 显示和隐藏抽屉的方法

-(void)showSideslipType:(FanSideslipType)sideslipType showProgress:(CGFloat)progress{
    self.sideslipType=sideslipType;
    self.sideslipProgress=progress;
    __weak typeof(self)weakSelf=self;
    if (progress<=0.0f) {
        self.sideslipProgress=0.7;
    }
    if (self.autoHidden) {
        switch (sideslipType) {
            case FanSideslipTypeNone:
            {
                return;
            }
                break;
            case FanSideslipTypeLeft:
            {

                self.sideslipWindow.rootViewController=self.leftViewController;
                if (self.leftViewController) {
                    self.leftViewController.view.frame=CGRectMake(-[[UIScreen mainScreen] bounds].size.width, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
                    self.tapControl.frame=CGRectMake(-[[UIScreen mainScreen] bounds].size.width*(1-self.sideslipProgress), 0, [[UIScreen mainScreen] bounds].size.width*(1+1-self.sideslipProgress), [[UIScreen mainScreen] bounds].size.height);
                    self.tapControl.alpha=0.0;
                    [UIView animateWithDuration:self.animationDuration animations:^{
                        self.leftViewController.view.frame=CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
                        self.tapControl.alpha=1.0;
                        self.tapControl.frame=CGRectMake([[UIScreen mainScreen] bounds].size.width*self.sideslipProgress, 0, [[UIScreen mainScreen] bounds].size.width*(1-self.sideslipProgress), [[UIScreen mainScreen] bounds].size.height);
                    }];
                }
            }
                break;
            case FanSideslipTypeRight:
            {
                self.sideslipWindow.rootViewController=self.rightViewController;
                self.tapControl.frame=CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width*(1+1-self.sideslipProgress), [[UIScreen mainScreen] bounds].size.height);
                self.tapControl.alpha=0.0;
                if (self.rightViewController) {
                    self.rightViewController.view.frame=CGRectMake([[UIScreen mainScreen] bounds].size.width, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
                    [UIView animateWithDuration:self.animationDuration animations:^{
                        self.rightViewController.view.frame=CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
                        self.tapControl.alpha=1.0;
                        self.tapControl.frame=CGRectMake(0,0, [[UIScreen mainScreen] bounds].size.width*(1-self.sideslipProgress), [[UIScreen mainScreen] bounds].size.height);
                    }];
                }
            }
                break;
            case FanSideslipTypeLeftMove:
            {
                self.sideslipWindow.rootViewController=self.leftViewController;
                self.tapControl.frame=CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
                self.tapControl.alpha=0.0;
                if (self.leftViewController) {
                    self.leftViewController.view.frame=CGRectMake(-[[UIScreen mainScreen] bounds].size.width*weakSelf.sideslipProgress, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
                    [UIView animateWithDuration:self.animationDuration animations:^{
                        self.leftViewController.view.frame=CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
                        self.tapControl.alpha=1.0;
                        self.tapControl.frame=CGRectMake([[UIScreen mainScreen] bounds].size.width*self.sideslipProgress, 0, [[UIScreen mainScreen] bounds].size.width*(1-self.sideslipProgress), [[UIScreen mainScreen] bounds].size.height);
                        if (weakSelf.centerViewController) {
                            weakSelf.centerViewController.view.frame=CGRectMake([[UIScreen mainScreen] bounds].size.width*weakSelf.sideslipProgress, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
                        }
                    }];
                }
            }
                break;
            case FanSideslipTypeRightMove:
            {
                self.sideslipWindow.rootViewController=self.rightViewController;
                self.tapControl.frame=CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
                self.tapControl.alpha=0.0;
                if (self.rightViewController) {
                    self.rightViewController.view.frame=CGRectMake([[UIScreen mainScreen] bounds].size.width*weakSelf.sideslipProgress, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
                    [UIView animateWithDuration:self.animationDuration animations:^{
                        self.rightViewController.view.frame=CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
                        self.tapControl.alpha=1.0;
                        self.tapControl.frame=CGRectMake(0,0, [[UIScreen mainScreen] bounds].size.width*(1-self.sideslipProgress), [[UIScreen mainScreen] bounds].size.height);
                        if (weakSelf.centerViewController) {
                            weakSelf.centerViewController.view.frame=CGRectMake(-[[UIScreen mainScreen] bounds].size.width*weakSelf.sideslipProgress, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
                        }
                    }];
                }
            }
                break;
            default:
                break;
        }
    }else{
        if(self.customAnimation==YES){
            if (sideslipType==FanSideslipTypeLeft||sideslipType==FanSideslipTypeLeftMove) {
                self.sideslipWindow.rootViewController=self.leftViewController;
            }else if (sideslipType==FanSideslipTypeRight||sideslipType==FanSideslipTypeRightMove) {
                self.sideslipWindow.rootViewController=self.rightViewController;
            }
        }else{
            switch (sideslipType) {
                case FanSideslipTypeNone:
                {
                    return;
                }
                    break;
                case FanSideslipTypeLeft:
                {
                    self.sideslipWindow.rootViewController=self.leftViewController;
                    if (self.leftViewController) {
                        self.leftViewController.view.frame=CGRectMake(-[[UIScreen mainScreen] bounds].size.width, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
                        [UIView animateWithDuration:self.animationDuration animations:^{
                            self.leftViewController.view.frame=CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
                        }];
                    }
                }
                    break;
                case FanSideslipTypeRight:
                {
                    self.sideslipWindow.rootViewController=self.rightViewController;
                    if (self.rightViewController) {
                        self.rightViewController.view.frame=CGRectMake([[UIScreen mainScreen] bounds].size.width, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
                        [UIView animateWithDuration:self.animationDuration animations:^{
                            self.rightViewController.view.frame=CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
                        }];
                    }
                }
                    break;
                case FanSideslipTypeLeftMove:
                {
                    self.sideslipWindow.rootViewController=self.leftViewController;
                    if (self.leftViewController) {
                        self.leftViewController.view.frame=CGRectMake(-[[UIScreen mainScreen] bounds].size.width*weakSelf.sideslipProgress, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
                        [UIView animateWithDuration:self.animationDuration animations:^{
                            self.leftViewController.view.frame=CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
                            if (weakSelf.centerViewController) {
                                weakSelf.centerViewController.view.frame=CGRectMake([[UIScreen mainScreen] bounds].size.width*weakSelf.sideslipProgress, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
                            }
                        }];
                    }
                }
                    break;
                case FanSideslipTypeRightMove:
                {
                    self.sideslipWindow.rootViewController=self.rightViewController;
                    if (self.rightViewController) {
                        self.rightViewController.view.frame=CGRectMake([[UIScreen mainScreen] bounds].size.width*weakSelf.sideslipProgress, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
                        [UIView animateWithDuration:self.animationDuration animations:^{
                            self.rightViewController.view.frame=CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
                            if (weakSelf.centerViewController) {
                                weakSelf.centerViewController.view.frame=CGRectMake(-[[UIScreen mainScreen] bounds].size.width*weakSelf.sideslipProgress, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
                            }
                        }];
                    }
                }
                    break;
                default:
                    break;
            }
        }
    }
    //用来刷新UI
    if (self.sideslipBlock) {
        self.sideslipBlock(self.sideslipType,YES);
    }
    [self.sideslipWindow makeKeyAndVisible];
    if (self.autoHidden) {
        [self.sideslipWindow bringSubviewToFront:self.tapControl];
    }
}
-(void)hideSideslipNOAnimation{
    if (self.leftViewController) {
        self.leftViewController.view.frame=CGRectMake(-[[UIScreen mainScreen] bounds].size.width, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    }
    if (self.rightViewController) {
        self.rightViewController.view.frame=CGRectMake([[UIScreen mainScreen] bounds].size.width, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    }
    if (self.autoHidden) {
        self.tapControl.frame=CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
        self.tapControl.alpha=0.0;
    }
    [[FanSideslipManager mainWindow] makeKeyAndVisible];
    //用来刷新收起时UI
    if (self.sideslipBlock) {
        self.sideslipBlock(self.sideslipType,NO);
    }
}

-(void)hideSideslip{
    __weak typeof(self)weakSelf=self;
    if (self.autoHidden) {
        switch (_sideslipType) {
            case FanSideslipTypeNone:
            {
                
            }
                break;
            case FanSideslipTypeLeft:
            {
                self.sideslipWindow.rootViewController=self.leftViewController;
                if (self.leftViewController) {
                    [UIView animateWithDuration:self.animationDuration animations:^{
                        self.leftViewController.view.frame=CGRectMake(-[[UIScreen mainScreen] bounds].size.width, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
                        self.tapControl.frame=CGRectMake(-[[UIScreen mainScreen] bounds].size.width*(1-self.sideslipProgress), 0, [[UIScreen mainScreen] bounds].size.width*(1+1-self.sideslipProgress), [[UIScreen mainScreen] bounds].size.height);
                        self.tapControl.alpha=0.0f;
                    }];
                }
            }
                break;
            case FanSideslipTypeRight:
            {
                self.sideslipWindow.rootViewController=self.rightViewController;
                if (self.rightViewController) {
                    [UIView animateWithDuration:self.animationDuration animations:^{
                        self.rightViewController.view.frame=CGRectMake([[UIScreen mainScreen] bounds].size.width, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
                        self.tapControl.frame=CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width*(1+1-self.sideslipProgress), [[UIScreen mainScreen] bounds].size.height);
                        self.tapControl.alpha=0.0;
                    }];
                }
                
            }
                break;
            case FanSideslipTypeLeftMove:
            {
                self.sideslipWindow.rootViewController=self.leftViewController;
                if (self.leftViewController) {
                    [UIView animateWithDuration:self.animationDuration animations:^{
                        self.leftViewController.view.frame=CGRectMake(-[[UIScreen mainScreen] bounds].size.width*weakSelf.sideslipProgress, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
                        self.tapControl.frame=CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
                        self.tapControl.alpha=0.0;
                        if (weakSelf.centerViewController) {
                            weakSelf.centerViewController.view.frame=CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
                        }
                    }];
                }
            }
                break;
            case FanSideslipTypeRightMove:
            {
                self.sideslipWindow.rootViewController=self.rightViewController;
                if (self.rightViewController) {
                    [UIView animateWithDuration:self.animationDuration animations:^{
                        self.rightViewController.view.frame=CGRectMake([[UIScreen mainScreen] bounds].size.width*weakSelf.sideslipProgress, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
                        self.tapControl.frame=CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
                        self.tapControl.alpha=0.0;
                        if (weakSelf.centerViewController) {
                            weakSelf.centerViewController.view.frame=CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
                        }
                    }];
                }
            }
                break;
            default:
                break;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.animationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[FanSideslipManager mainWindow] makeKeyAndVisible];
        });
    }else{
        if(self.customAnimation==YES){
            //用户自定义动画
            
        }else{
            switch (_sideslipType) {
                case FanSideslipTypeNone:
                {
                    
                }
                    break;
                case FanSideslipTypeLeft:
                {
                    self.sideslipWindow.rootViewController=self.leftViewController;
                    if (self.leftViewController) {
                        [UIView animateWithDuration:self.animationDuration animations:^{
                            self.leftViewController.view.frame=CGRectMake(-[[UIScreen mainScreen] bounds].size.width, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
                        }];
                    }
                }
                    break;
                case FanSideslipTypeRight:
                {
                    self.sideslipWindow.rootViewController=self.rightViewController;
                    if (self.rightViewController) {
                        [UIView animateWithDuration:self.animationDuration animations:^{
                            self.rightViewController.view.frame=CGRectMake([[UIScreen mainScreen] bounds].size.width, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
                        }];
                    }
                    
                }
                    break;
                case FanSideslipTypeLeftMove:
                {
                    self.sideslipWindow.rootViewController=self.leftViewController;
                    if (self.leftViewController) {
                        [UIView animateWithDuration:self.animationDuration animations:^{
                            self.leftViewController.view.frame=CGRectMake(-[[UIScreen mainScreen] bounds].size.width*weakSelf.sideslipProgress, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
                            if (weakSelf.centerViewController) {
                                weakSelf.centerViewController.view.frame=CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
                            }
                        }];
                    }
                }
                    break;
                case FanSideslipTypeRightMove:
                {
                    self.sideslipWindow.rootViewController=self.rightViewController;
                    if (self.rightViewController) {
                        [UIView animateWithDuration:self.animationDuration animations:^{
                            self.rightViewController.view.frame=CGRectMake([[UIScreen mainScreen] bounds].size.width*weakSelf.sideslipProgress, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
                            if (weakSelf.centerViewController) {
                                weakSelf.centerViewController.view.frame=CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
                            }
                        }];
                    }
                }
                    break;
                default:
                    break;
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.animationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[FanSideslipManager mainWindow] makeKeyAndVisible];
            });
        }
    }
    
    //用来刷新收起时UI
    if (self.sideslipBlock) {
        self.sideslipBlock(self.sideslipType,NO);
    }
}


#pragma mark -  其他工具类
//获取当前window
+ (UIWindow *)mainWindow
{
    UIApplication *app = [UIApplication sharedApplication];
    if ([app.delegate respondsToSelector:@selector(window)]){
        return [app.delegate window];
    }else{
        return [app keyWindow];
    }
}
@end
