//
//  HelpCenterViewController.m
//  EZDB
//
//  Created by wenming.zheng on 14-10-18.
//  Copyright (c) 2014年 Pactera. All rights reserved.
//

#import "HelpCenterViewController.h"
#import "DetailHelpViewController.h"
#import "FAQCell.h"

#define Cell_Height 44
@interface HelpCenterViewController ()
{
    NSMutableArray      *dataSourceArray;
    NSMutableArray      *sectionArray;
    NSMutableArray      *stateArray;
    UIImageView         *_imgView;

}
@end

@implementation HelpCenterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initDataSource];
    [self initUI];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[EZDBAppDelegate appDelegate].tabBarCtl hideMyTabBar];
}
- (void)initDataSource
{
    sectionArray  = [NSMutableArray arrayWithObjects:@"关于直销银行",
                                                     @"关于理财产品",
                                                     @"关于我的投资",
                                                     @"安全中心",nil];
    
    NSArray *one = @[@"关于直销银行1",@"关于直销银行2",@"关于直销银行3"];
    NSArray *two = @[@"如何购买？",@"如何赎回？",@"业务办理时间？"];
    NSArray *three = @[@"关于我的投资1",@"关于我的投资2",@"关于我的投资3"];
    NSArray *four = @[@"安全中心1",@"安全中心2",@"安全中心3",@"安全中心4"];
    
    dataSourceArray = [NSMutableArray arrayWithObjects:one,two,three,four, nil];
    stateArray = [NSMutableArray array];
    
    for (int i = 0; i < dataSourceArray.count; i++)
    {
        //所有的分区都是闭合
        [stateArray addObject:@"0"];
    }
}
- (void)popViewContrl:(NSInteger )index{
    if (index==1) {
        
        [self.navigationController popViewControllerAnimated:YES];
    
    }else if (index==2){
//        DEFINE_CONTROLLERS(RootViewController, nav);
//        [self presentViewController:nav animated:YES completion:nil];
    }
}
- (void)initUI
{
    [self setNavBarWithtitle:kHelpCenterTitle superView:self.view backImg:kNavBackImgName homeImg:nil];
    
    if (kDeviceVersion>=7.0) {
        self.FAQTableView.frame = CGRectMake(0, 44, kScreenWidth, kScreenHeight-20);
       
    }else{
        self.FAQTableView.frame = CGRectMake(0, 44, kScreenWidth, kScreenHeight-64);
    }
    self.FAQTableView.backgroundColor = kViewBackGroudColor;
    self.FAQTableView.backgroundView = nil;
    self.FAQTableView.delegate =self;
    self.FAQTableView.dataSource =self;
    self.FAQTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.FAQTableView registerNib:[UINib nibWithNibName:@"FAQCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
}


#pragma mark -
#pragma mark - UITableViewDataSource UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataSourceArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([stateArray[section] isEqualToString:@"1"]){
        //如果是展开状态
        NSArray *array = [dataSourceArray objectAtIndex:section];
        return array.count;
    }else{
        //如果是闭合，返回0
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FAQCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.listLabel.textAlignment = NSTextAlignmentLeft;
    cell.listLabel.text = dataSourceArray[indexPath.section][indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.contentView.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return sectionArray[section];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    [button setTag:section+1];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 60)];
    [button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, button.frame.size.height-1, button.frame.size.width, 1)];
    [line setImage:[UIImage imageNamed:@"line_real"]];
    [button addSubview:line];
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, (Cell_Height-22)/2, 22, 22)];
    [imgView setImage:[UIImage imageNamed:@"ico_faq_d"]];
    [button addSubview:imgView];
    
    _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-30, (Cell_Height-6)/2, 10, 6)];
    
    if ([stateArray[section] isEqualToString:@"0"]) {
        _imgView.image = [UIImage imageNamed:@"ico_listdown"];
    }else if ([stateArray[section] isEqualToString:@"1"]) {
        _imgView.image = [UIImage imageNamed:@"ico_listup"];
    }
    [button addSubview:_imgView];

    UILabel *tlabel = [[UILabel alloc]initWithFrame:CGRectMake(45, (Cell_Height-20)/2, 200, 20)];
    [tlabel setBackgroundColor:[UIColor clearColor]];
    [tlabel setFont:[UIFont systemFontOfSize:14]];
    [tlabel setText:sectionArray[section]];
    [button addSubview:tlabel];
    
    return button;
}
#pragma mark 
#pragma mark  -select cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailHelpViewController *detailVC = [[DetailHelpViewController alloc]init];
    detailVC.titleString = dataSourceArray[indexPath.section][indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)buttonPress:(UIButton *)sender//headButton点击
{
    //判断状态值
    if ([stateArray[sender.tag - 1] isEqualToString:@"1"]){
        //修改
        [stateArray replaceObjectAtIndex:sender.tag - 1 withObject:@"0"];
    }else{
        [stateArray replaceObjectAtIndex:sender.tag - 1 withObject:@"1"];
    }
    [self.FAQTableView reloadSections:[NSIndexSet indexSetWithIndex:sender.tag-1] withRowAnimation:UITableViewRowAnimationAutomatic];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return Cell_Height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return kCloseZero;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return Cell_Height;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
