//
//  ViewController.m
//  DDShareDemo
//
//  Created by Think on 2017/3/5.
//  Copyright © 2017年 Think. All rights reserved.
//

#import "ViewController.h"
#import "DDConst.h"
#import "DDShareView.h"
#import "DDShareItem.H"

static NSString *const cellID = @"cellID";
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSArray *data;
@property (nonatomic,strong) NSArray *shareArray;
@property(nonatomic, strong) NSMutableArray *functionArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分享";
    _data = @[@"单行展示",@"双行展示",@"多行展示",@"九宫格展示",@"自定义头尾",@"自定义取消,分割线"];
    _shareArray = @[DDPlatformNameSms,DDPlatformNameEmail,DDPlatformNameSina,DDPlatformNameWechat,DDPlatformNameQQ,DDPlatformNameAlipay];
    [self setupTableView];
}

- (NSMutableArray *)functionArray{
    if (!_functionArray) {
        _functionArray = [NSMutableArray array];
        [_functionArray addObject:[[DDShareItem alloc] initWithImage:[UIImage imageNamed:@"function_collection"] title:@"收藏" action:^(DDShareItem *item) {
            ALERT_MSG(@"提示",@"点击了收藏",self);
        }]];
        [_functionArray addObject:[[DDShareItem alloc] initWithImage:[UIImage imageNamed:@"function_copy"] title:@"复制" action:^(DDShareItem *item) {
            ALERT_MSG(@"提示",@"点击了复制",self);
        }]];
        [_functionArray addObject:[[DDShareItem alloc] initWithImage:[UIImage imageNamed:@"function_expose"] title:@"举报" action:^(DDShareItem *item) {
            ALERT_MSG(@"提示",@"点击了举报",self);
        }]];
        [_functionArray addObject:[[DDShareItem alloc] initWithImage:[UIImage imageNamed:@"function_font"] title:@"调整字体" action:^(DDShareItem *item) {
            ALERT_MSG(@"提示",@"点击了调整字体",self);
        }]];
        [_functionArray addObject:[[DDShareItem alloc] initWithImage:[UIImage imageNamed:@"function_link"] title:@"复制链接" action:^(DDShareItem *item) {
            ALERT_MSG(@"提示",@"点击了复制链接",self);
        }]];
        [_functionArray addObject:[[DDShareItem alloc] initWithImage:[UIImage imageNamed:@"function_refresh"] title:@"刷新" action:^(DDShareItem *item) {
            ALERT_MSG(@"提示",@"点击了刷新",self);
        }]];
    }
    return _functionArray;
}

- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:tableView];
}

#pragma mark UITableViewDataSource - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.textLabel.text = _data[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
             DDShareView *shareView = [[DDShareView alloc] initWithItems:self.shareArray itemSize:CGSizeMake(80,100) displayLine:YES];
            shareView = [self addShareContent:shareView];
            shareView.itemSpace = 10;
            [shareView showFromControlle:self];
        }
            break;
            case 1:
        {
            DDShareView *shareView = [[DDShareView alloc] initWithShareItems:self.shareArray functionItems:self.functionArray itemSize:CGSizeMake(80,100)];
            shareView = [self addShareContent:shareView];
            shareView.itemSpace = 10;
            [shareView showFromControlle:self];
        }
            break;
            case 2:
        {
            NSMutableArray *totalArry = [NSMutableArray array];
            [totalArry addObjectsFromArray:self.shareArray];
            [totalArry addObjectsFromArray:self.functionArray];
            DDShareView *shareView = [[DDShareView alloc] initWithItems:totalArry itemSize:CGSizeMake(80,100) displayLine:NO];
            shareView = [self addShareContent:shareView];
            shareView.itemSpace = 100;
            [shareView showFromControlle:self];

        }
            break;
        case 3:
        {
            DDShareView *shareView = [[DDShareView alloc] initWithItems:self.shareArray countEveryRow:4];
            shareView.itemImageSize = CGSizeMake(45, 45);
            shareView = [self addShareContent:shareView];
            //    shareView.itemSpace = 10;
            [shareView showFromControlle:self];
        }
            break;
        case 4:
        {
            DDShareView *shareView = [[DDShareView alloc] initWithShareItems:self.shareArray functionItems:self.functionArray itemSize:CGSizeMake(80,100)];
            UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
            headerView.backgroundColor = [UIColor clearColor];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, headerView.frame.size.width, 15)];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor colorWithRed:51/255.0 green:68/255.0 blue:79/255.0 alpha:1.0];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont systemFontOfSize:15];
            label.text = @"我是头部可以自定义的View";
            [headerView addSubview:label];
            
            
            UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
            footerView.backgroundColor = [UIColor clearColor];
            label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, headerView.frame.size.width, 15)];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor colorWithRed:5/255.0 green:27/255.0 blue:40/255.0 alpha:1.0];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont systemFontOfSize:18];
            label.text = @"我是底部可以自定义的View";
            [footerView addSubview:label];
            
            shareView.headerView = headerView;
            shareView.footerView = footerView;
            shareView = [self addShareContent:shareView];
            [shareView showFromControlle:self];

        }
            break;
        case 5:
        {
            DDShareView *shareView = [[DDShareView alloc] initWithShareItems:self.shareArray functionItems:self.functionArray itemSize:CGSizeMake(80,100)];
            [shareView.cancleButton setTitle:@"我是可以自定义的按钮" forState:UIControlStateNormal];
            shareView.middleLineColor = [UIColor orangeColor];
            shareView.middleLineEdgeSpace = 20;
            shareView.middleTopSpace = 20;
            shareView.middleBottomSpace = 20;
            shareView = [self addShareContent:shareView];
            [shareView showFromControlle:self];
        }
            break;
        default:
            break;
    }
}

//添加分享的内容
- (DDShareView *)addShareContent:(DDShareView *)shareView{
    [shareView addText:@"分享测试"];
    [shareView addURL:[NSURL URLWithString:@"http://www.baidu.com"]];
    [shareView addImage:[UIImage imageNamed:@"function_refresh"]];
    
    return shareView;
}
@end
