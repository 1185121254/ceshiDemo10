//
//  MainViewController.m
//  ceshiDemo10
//
//  Created by chaojie on 2017/5/11.
//  Copyright © 2017年 chaojie. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource>


@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"this title";
    self.view.backgroundColor = [UIColor redColor];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    //_arrayData = [[NSMutableArray alloc]initWithObjects:@"frist",@"two", nil];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(tongzhi:) name:@"name" object:nil];
    
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"next" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClcik)];
    self.navigationItem.rightBarButtonItem = rightBtn;

    
}

-(void)rightBtnClcik{
    
    fristViewController *frist = [[fristViewController alloc]init];
    [self.navigationController pushViewController:frist animated:YES];
    
}
-(void)tongzhi:(NSNotification *)noti{
    
    NSLog(@"--%@",noti.object);
    NSLog(@"++%@",noti.userInfo);
    NSLog(@"收到通知");
    
    _arrayData = [noti.object valueForKey:@"123"];
//    _arrayData = [noti.object objectForKey:@"哈哈哈哈你好啊"];
    NSLog(@"%@",_arrayData);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _arrayData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = _arrayData[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:20];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        
//        fristViewController *frist = [[fristViewController alloc]init];
//    
//        //frist.array = _arrayData;
//    
//        [self.navigationController pushViewController:frist animated:YES];
    
        
        fristViewController *frist = [[fristViewController alloc]init];
        [self.navigationController pushViewController:frist animated:YES];
        
    }
    if (indexPath.row == 1) {
        
        TwoViewController *two = [[TwoViewController alloc]init];
        [self.navigationController pushViewController:two animated:YES];
        
    }
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
