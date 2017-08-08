//
//  fristViewController.m
//  ceshiDemo10
//
//  Created by chaojie on 2017/5/11.
//  Copyright © 2017年 chaojie. All rights reserved.
//

#import "fristViewController.h"

@interface fristViewController ()

@end

@implementation fristViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor yellowColor];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
  
    
    _arrayTwo = [NSMutableArray arrayWithObjects:@"1",@"2",@"3", nil];
    
  
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc]initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClick)];
    self.navigationItem.leftBarButtonItem = leftBar;
}
-(void)rightBtnClick{
    
    NSDictionary *dic = [NSDictionary dictionaryWithObject:_arrayTwo forKey:@"123"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"name" object:nil userInfo:dic];
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _arrayTwo.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSLog(@"----%@",_arrayTwo);
    cell.textLabel.text = _arrayTwo[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:20];
    
    return cell;
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
