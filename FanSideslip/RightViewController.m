//
//  RightViewController.m
//  FanSideslip
//
//  Created by 向阳凡 on 2019/1/22.
//  Copyright © 2019 向阳凡. All rights reserved.
//

#import "RightViewController.h"
#import "FanSideslipManager.h"

@interface RightViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation RightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.navigationController) {
        self.navigationController.navigationBar.hidden=YES;
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.navigationController) {
        self.navigationController.navigationBar.hidden=NO;
    }
}
- (void)configUI{
    self.dataArray=[@[@"跳转下一页",@"跳转下一页",@"系统安全",@"系统缓存",@"设置"]  mutableCopy];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.4, 0, self.view.frame.size.width*0.6, self.view.frame.size.height) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIImageView new];
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    //    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    _tableView.translatesAutoresizingMaskIntoConstraints=NO;
    //字典里面的变量可以在格式字符里面替代
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_tableView]|" options:0 metrics:@{} views:@{@"_tableView":_tableView}]];
    NSLayoutConstraint *constraint=[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.6 constant:0];
    [self.view addConstraint:constraint];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_tableView]-0-|" options:0 metrics:@{} views:@{@"_tableView":_tableView}]];
}
#pragma mark - tableview Delegate  DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text=self.dataArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIViewController *vc=[[UIViewController alloc]init];
    vc.view.backgroundColor=[UIColor whiteColor];
    [self.navigationController pushViewController:vc animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint touchPoint=[[touches anyObject]locationInView:self.view];
    if (touchPoint.x<[[UIScreen mainScreen] bounds].size.width*0.4) {
        //侧边栏消失
        [[FanSideslipManager shareManager]hideSideslip];
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
