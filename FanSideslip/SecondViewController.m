//
//  SecondViewController.m
//  FanSideslip
//
//  Created by 向阳凡 on 2019/1/23.
//  Copyright © 2019 向阳凡. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"2.jpg"]];
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame=CGRectMake(50, 100, 150, 30);
    btn.backgroundColor=[UIColor colorWithWhite:0.6 alpha:1];
    [btn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [btn setTitle:@"返回上一界面" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
}
-(void)backClick{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
