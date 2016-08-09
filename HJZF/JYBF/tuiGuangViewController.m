//
//  tuiGuangViewController.m
//  The territory of payment
//
//  Created by 铂金数据 on 15/4/22.
//  Copyright (c) 2015年 铂金数据. All rights reserved.
//

#import "tuiGuangViewController.h"
#import "PostAsynClass.h"
#import "User.h"
#import "MyNavigationBar.h"
#import "Header.h"
#import "tuiGuangJIluTableViewCell.h"

@interface tuiGuangViewController ()
{
    NSString *_locationString;
    NSDateFormatter *_formatter;
    NSString *_timeStr;
    NSString *_timeStr1;
    UITableView *_table;
     NSMutableArray *_dataArr;
   int _pageNum;
    
    NSArray *_data;
}
@end

@implementation tuiGuangViewController

- (void)viewDidLoad {
  
    [super viewDidLoad];
    
    _dataArr = [NSMutableArray arrayWithCapacity:0];
     _pageNum=1;
    [self loadData];
   [self makeNav];
   
     [self makeUI];
    
    
   
    self.automaticallyAdjustsScrollViewInsets = NO;
       self.view.backgroundColor=[UIColor whiteColor];
    // Do any additional setup after loading the view.
}
-(void)makeNav
{
//    //导航
        [self.navigationController setNavigationBarHidden:YES];
    MyNavigationBar *mnb = [[MyNavigationBar alloc] init];
    mnb.frame = CGRectMake(0, 20*screenWidth/320, 320*screenWidth/320, 44*screenWidth/320);
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:[NSArray arrayWithObject:@"title_back.png"] andRightBBIImages:nil andTitle:@"分享记录" andClass:self andSEL:@selector(bacClick)];
    [self.view addSubview:mnb];
   
}

-(void)makeUI
{
    //状态栏颜色
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320*screenWidth/320, 20*screenWidth/320)];
    
    statusBarView.backgroundColor=[UIColor colorWithRed:0/255.0 green:55/255.0 blue:113/255.0 alpha:1];
    
    [self.view addSubview:statusBarView];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    _table= [[UITableView alloc] initWithFrame:CGRectMake(0, 64*screenWidth/320, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];//实例化，两种类型plain、group
    //两个代理
    _table.delegate = self;
    _table.dataSource = self;
    _table.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:_table];

    //实例化header和footer
    _header = [MJRefreshHeaderView header];
    _header.scrollView = _table;
    //设置header和footer的滚动视图为table
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = _table;
    //设置header和footer的代理
    _header.delegate = self;
    _footer.delegate = self;
 
    
}


-(void)loadData

{
    
    User *user=[User currentUser];
    
        
    
    NSDate *date=[NSDate dateWithTimeIntervalSinceNow:-90*24*60*60];
    _formatter=[[NSDateFormatter alloc]init];
    _formatter.dateFormat=@"yyyyMMdd";
    NSTimeZone *nowZone=[NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [_formatter setTimeZone:nowZone];
    _timeStr=[_formatter stringFromDate:date];
    NSLog(@"========================%@",_timeStr);
    
    
    NSDate *nowDate=[NSDate date];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    formatter.dateFormat=@"yyyyMMdd";
    NSTimeZone *nowZone1=[NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:nowZone1];
    _timeStr1=[formatter stringFromDate:nowDate];
    NSLog(@"------------------------%@",_timeStr1);

    
    NSString *a=[NSString stringWithFormat:@"%d",_pageNum];
        NSMutableURLRequest *rever =[PostAsynClass postAsynWithURL:url1 andInterface:url28 andKeyArr:@[@"merId",@"beginDate",@"endDate",@"pageNum",@"pageSize"]andValueArr:@[user.merid,_timeStr,_timeStr1,a,@"12"]];
    
    //
    NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    
    //NSString *string=[receive stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
    
    NSData *ata = [NSData alloc];
    
    ata = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];
    
    


   //
    _data=[dic objectForKey:@"ordersInfo"];
    for(NSDictionary *dicc in _data)
    {
              [_dataArr addObject:dicc];
        NSLog(@"ddddddddd%@",dicc );
        

    }
    
    NSLog(@"------------------------%@",dic);
    
    NSLog(@"777eygeyfgggihdihdhh5%@",_dataArr);
    if(_dataArr.count<1)
    {
        UIAlertView *alat = [[UIAlertView alloc] initWithTitle:@"提示" message:@"近期内你还没有分享记录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alat show];
        
        return;
        
        
    }
    
    [_table reloadData];
    
}


#pragma mark table的代理方法
//必选代理方法

//1、设置table的每一段有多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
 
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50*screenWidth/320.0;
}

//2、设置每一行上面显示什么内容
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //做一个标识
    static NSString *str = @"iden";
    
    //给table注册一个cell名称标识
    tuiGuangJIluTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    
    //判断cell有没有,在池子里找
    if(!cell)
    {//没找到进来
        //实例化一个cell
        cell = [[tuiGuangJIluTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str] ;
    }
   
  
    //cell.transDate.text=_dataArr[indexPath.row][@"transDate"];

    //把20130303变成2013-03-03
    NSRange range1=NSMakeRange(0, 4);
    NSRange range2=NSMakeRange(4, 2);
    NSRange range3=NSMakeRange(6, 2);
    NSString *string1=[NSString stringWithFormat:@"%@-%@-%@",[_dataArr[indexPath.row][@"transDate"] substringWithRange:range1],[_dataArr[indexPath.row][@"transDate"] substringWithRange:range2],[_dataArr[indexPath.row][@"transDate"] substringWithRange:range3]];
    //cell.transDate.text=string1;
    NSLog(@"%@",string1);
    //cell.transTime.text=_dataArr[indexPath.row][@"transTime"];
    
    NSRange ran1=NSMakeRange(0, 2);
    NSRange ran2=NSMakeRange(2, 2);
    NSRange ran3=NSMakeRange(4, 2);
    NSString *string2=[NSString stringWithFormat:@"%@:%@:%@",[_dataArr[indexPath.row][@"transTime"] substringWithRange:ran1],[_dataArr[indexPath.row][@"transTime"] substringWithRange:ran2],[_dataArr[indexPath.row][@"transTime"] substringWithRange:ran3]];
    //cell.transTime.text=string2;
    NSString *timeString=[NSString stringWithFormat:@"%@ %@",string1,string2];
    cell.transDate.text=timeString;

    
    
    if ([_dataArr[indexPath.row][@"isAuthentication"]isEqualToString:@"S"]) {
        cell.isAuthentication.text=@"已认证";
        
    }
    else
    {
        cell.isAuthentication.text=@"未认证";

    }

    if ([_dataArr[indexPath.row][@"isFirstTrans"]isEqualToString:@"Y"]) {
        cell.isFirstTrans.text=@"已进行过收款";
    }
    if ([_dataArr[indexPath.row][@"isFirstTrans"]isEqualToString:@"N"])
    {
        cell.isFirstTrans.text=@"从未进行过收款";
    }
    
    cell.regMerName.text=_dataArr[indexPath.row][@"regMerName"];
 
    cell.regMobile.text=_dataArr[indexPath.row][@"regMobile"];
    NSString*before=[cell.regMobile.text substringToIndex:3];
    
    NSString*after=[cell.regMobile.text substringFromIndex:7];
    
    cell.regMobile.text = [[NSString alloc] initWithFormat:@"(%@****%@)", before, after];

    return cell;
}

#pragma mark  从头开始
-(void)viewDidLayoutSubviews {
    
    if ([_table respondsToSelector:@selector(setSeparatorInset:)]) {
        [_table setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([_table respondsToSelector:@selector(setLayoutMargins:)])  {
        [_table setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}



#pragma mark MJ的代理
//开始的代理
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    //在这里开始网络请求
    if(refreshView == _header)
    {
        _pageNum=1;
         [_dataArr removeAllObjects];
        [self loadData];
       
    }
    else
    {
        _pageNum+=1;
        [self loadData];
      
    }
    [refreshView endRefreshing];//结束刷新，归位
}

-(void)bacClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)dealloc
{
    [_header free];
    [_footer free];
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
