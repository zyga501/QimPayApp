//
//  MyViewController.m
//  JYBF
//
//  Created by 王健超 on 15/8/24.
//  Copyright (c) 2015年 wjc. All rights reserved.
//

#import "MyViewController.h"
#import "MyNavigationBar.h"
#import "Header.h"
#import "User.h"
#import "PostAsynClass.h"
#import "UIImageView+WebCache.h"
#import "NSString+Extension.h"
#import "changePWDViewController.h"
#import "changePhoneNumViewController.h"
#import "jiesuanGLViewController.h"
#import "caozuoGuideViewController.h"
#import "yonghuXYViewController.h"
#import "aboutUsViewController.h"
#import "bangdingYHKViewController.h"
#import "nextZhanghuViewController.h"
#import "shimingViewController.h"
#import "feilvxinxiViewController.h"

#import <AVFoundation/AVFoundation.h>
#import "AFHTTPRequestOperationManager.h"
#import "AFURLResponseSerialization.h"
#import "AFHTTPRequestOperation.h"
@interface MyViewController ()<UIScrollViewDelegate,UIAlertViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>
{
    UIView *firstView;
    UIView *secondView;
    UIView *thirdView;
    
    UIImageView *headImage;
    
    UILabel *firsviewtLabel;
    UIScrollView *scrollview;
    UIAlertView *_alert;
    
    UIImagePickerController *picker;
    UIActionSheet *actionSheetCename;
    
    NSString  *filePath;
}
@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:0.9];
    //self.view.backgroundColor=[UIColor lightGrayColor];
    
    
    [self makeNav];
    [self makeUI];
    // Do any additional setup after loading the view.
}
-(void)makeNav
{
    //导航
    [self.navigationController setNavigationBarHidden:YES];
    MyNavigationBar *mnb = [[MyNavigationBar alloc] init];
    mnb.frame = CGRectMake(0, 20*screenWidth/320, 320*screenWidth/320, 44*screenWidth/320);
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:nil andRightBBIImages:nil andTitle:@"我" andClass:self andSEL:nil];
    [self.view addSubview:mnb];
    
    //状态栏颜色
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320*screenWidth/320, 20*screenWidth/320)];    
    statusBarView.backgroundColor=[UIColor colorWithRed:0/255.0 green:55/255.0 blue:113/255.0 alpha:1];
    [self.view addSubview:statusBarView];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}

-(void)makeUI
{
    
    User *user=[User currentUser];
    
    NSMutableURLRequest *rever1 = [PostAsynClass postAsynWithURL:url1 andInterface:url11 andKeyArr:@[@"merId",@"loginId"]andValueArr:@[user.merid,user.phoneText]];
    //开始post请求
    NSData *receive1 = [NSURLConnection sendSynchronousRequest:rever1 returningResponse:nil error:nil];
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString  *str1 = [[NSString alloc] initWithData:receive1 encoding:enc];
    
    NSData *ata1 = [NSData alloc];
    
    ata1 = [str1 dataUsingEncoding:NSUTF8StringEncoding];
    //数据解析
    NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:ata1 options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"输出用户的基本信息%@",dic1);

   
    
    scrollview=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 64*screenWidth/320.0, self.view.frame.size.width, self.view.frame.size.height-64-49)];
    scrollview.contentSize=CGSizeMake(self.view.frame.size.width, 520*screenWidth/320.0);
    scrollview.bounces=NO;
    scrollview.showsVerticalScrollIndicator=NO;
    scrollview.scrollEnabled=YES;
    scrollview.delegate=self;
    scrollview.userInteractionEnabled=YES;
    [self.view addSubview:scrollview];
    
    //头像、用户名、手机号
    firstView=[[UIView alloc] initWithFrame:CGRectMake(0, 6*screenWidth/320.0, self.view.frame.size.width, 100*screenWidth/320.0)];
    firstView.backgroundColor=[UIColor whiteColor];
    [scrollview addSubview:firstView];
    
    //头像
    headImage=[[UIImageView alloc] initWithFrame:CGRectMake(24.0/(screenWidth/320.0), 15.0/(screenWidth/320.0), 70*screenWidth/320.0, 70*screenWidth/320.0)];
    headImage.layer.cornerRadius=headImage.frame.size.width/2;
    headImage.clipsToBounds=YES;
    if([[dic1 objectForKey:@"faceImgUrl"]isEqualToString:@""])
    {
      headImage.image=[UIImage imageNamed:@"touxiang@2x"];
    }
    else
    {
        //headImage.image=[UIImage imageNamed:@"touxiang@2x"];
        [headImage setImageWithURL:[NSURL URLWithString:[dic1 objectForKey:@"faceImgUrl"]]];
    }
    headImage.userInteractionEnabled=YES;
    [firstView addSubview:headImage];
    
   
    
    UIButton *headButton=[UIButton buttonWithType:UIButtonTypeCustom];
    headButton.frame=CGRectMake(0, 0, headImage.frame.size.width, headImage.frame.size.height);
    [headButton addTarget:self action:@selector(headBtn) forControlEvents:UIControlEventTouchUpInside];
    headButton.backgroundColor=[UIColor clearColor];
    [headImage addSubview:headButton];
    //用户名
    UILabel *nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(105*screenWidth/320.0, 20*screenWidth/320.0, 100*screenWidth/320.0, 30*screenWidth/320.0)];
    nameLabel.textAlignment=NSTextAlignmentLeft;
    nameLabel.text=[dic1 objectForKey:@"merName"];
    nameLabel.font=[UIFont boldSystemFontOfSize:16];
    [firstView addSubview:nameLabel];
    //手机号
    UILabel *phoneLabel=[[UILabel alloc] initWithFrame:CGRectMake(105*screenWidth/320.0, 50*screenWidth/320.0, 100*screenWidth/320.0, 30*screenWidth/320.0)];
    phoneLabel.font=[UIFont systemFontOfSize:14];
    phoneLabel.text=[dic1 objectForKey:@"loginId"];
    phoneLabel.textColor=[UIColor colorWithRed:0.71 green:0.71 blue:0.71 alpha:1.0];
    phoneLabel.textAlignment=NSTextAlignmentLeft;
    [firstView addSubview:phoneLabel];
    
    UIImageView *firstJiantou=[[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-40*screenWidth/320.0, 40*screenWidth/320.0, 20*screenWidth/320.0, 20*screenWidth/320.0)];
    firstJiantou.image=[UIImage imageNamed:@"jiantou@3x.png"];
    [firstView addSubview:firstJiantou];
    
    UIButton *detailButton=[UIButton buttonWithType:UIButtonTypeCustom];
    detailButton.frame=CGRectMake(headImage.frame.origin.x+headImage.frame.size.width+20, 0, self.view.frame.size.width-headImage.frame.origin.x-headImage.frame.size.width-20, firstView.frame.size.height);
    detailButton.backgroundColor=[UIColor clearColor];
    [detailButton addTarget:self action:@selector(detailBtn) forControlEvents:UIControlEventTouchUpInside];
    [firstView addSubview:detailButton];
    
    //密码、结算、更换
    secondView=[[UIView alloc] initWithFrame:CGRectMake(0, 115*screenWidth/320.0, self.view.frame.size.width, 160*screenWidth/320.0)];
    secondView.backgroundColor=[UIColor whiteColor];
    secondView.userInteractionEnabled=YES;
    [scrollview addSubview:secondView];
    //
    NSArray *array=@[@"mimaxiugai@2x",@"feilv@2x.png",@"jiesuanguanli@2x",@"gengshoujihao@2x"];
    NSArray *titleArray=@[@"密码修改",@"费率信息",@"结算管理",@"更换手机号"];
    for(int i=0;i<titleArray.count;i++)
    {
        UIImageView *Mimage=[[UIImageView alloc] initWithFrame:CGRectMake(30*screenWidth/320.0, 7.5*screenWidth/320.0+i*40*screenWidth/320.0, 25*screenWidth/320.0, 25*screenWidth/320.0)];
        Mimage.image=[UIImage imageNamed:array[i]];
        [secondView addSubview:Mimage];
        
       firsviewtLabel=[[UILabel alloc] initWithFrame:CGRectMake(80*screenWidth/320.0, 5*screenWidth/320.0+i*40*screenWidth/320.0, 140*screenWidth/320.0, 30*screenWidth/320.0)];
        firsviewtLabel.textAlignment=NSTextAlignmentLeft;
        firsviewtLabel.text=titleArray[i];
        if(i==1)
        {
            if(![user.sm isEqualToString:@"S"])
            {
                firsviewtLabel.text=@"绑定收款银行卡";
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"bangding"];
            }
            else
            {
              [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"bangding"];
            }
            
        }
        firsviewtLabel.font=[UIFont systemFontOfSize:15*screenWidth/320.0];
        [secondView addSubview:firsviewtLabel];
        
        UIImageView *jiantouImage=[[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-40*screenWidth/320.0, 10*screenWidth/320.0+i*40*screenWidth/320.0, 20*screenWidth/320.0, 20*screenWidth/320.0)];
        jiantouImage.image=[UIImage imageNamed:@"jiantou@3x.png"];
        [secondView addSubview:jiantouImage];
        
        UIButton *firstButton=[UIButton buttonWithType:UIButtonTypeCustom];
        firstButton.frame=CGRectMake(0, i*40*screenWidth/320.0, self.view.frame.size.width, 40*screenWidth/320.0);
        firstButton.tag=100+i;
        [firstButton addTarget:self action:@selector(firstBtn:) forControlEvents:UIControlEventTouchUpInside];
        firstButton.backgroundColor=[UIColor clearColor];
        [secondView addSubview:firstButton];
        
 
    }
    //横线
    for(int j=0;j<titleArray.count-1;j++)
    {
        UIImageView *lineImage=[[UIImageView alloc] initWithFrame:CGRectMake(0*screenWidth/320.0, 40*screenWidth/320.0+j*40*screenWidth/320.0, self.view.frame.size.width, 0.5*screenWidth/320.0)];
        lineImage.backgroundColor=[UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:0.85];
        [secondView addSubview:lineImage];
    }
    
    //操作手册、用户协议、关于我们
    thirdView=[[UIView alloc] initWithFrame:CGRectMake(0, 284*screenWidth/320.0, self.view.frame.size.width, 160*screenWidth/320.0)];
    thirdView.backgroundColor=[UIColor whiteColor];
    thirdView.userInteractionEnabled=YES;
    [scrollview addSubview:thirdView];
    
    NSArray *array1=@[@"caozuoshouce@2x",@"yonghuxieyi@2x",@"bj_banbengengxin@2x",@"guanyuwomen@2x",@"bj_zhanghuxiangqing@2x"];
    NSArray *titleArray1=@[@"操作手册",@"用户协议",@"最新版本",@"关于我们"];
    for(int i=0;i<titleArray1.count;i++)
    {
        UIImageView *Mimage=[[UIImageView alloc] initWithFrame:CGRectMake(30*screenWidth/320.0, 7.5*screenWidth/320.0+i*40*screenWidth/320.0, 25*screenWidth/320.0, 25*screenWidth/320.0)];
        Mimage.image=[UIImage imageNamed:array1[i]];
        [thirdView addSubview:Mimage];
        
        UILabel *firstLabel=[[UILabel alloc] initWithFrame:CGRectMake(80*screenWidth/320.0, 5*screenWidth/320.0+i*40*screenWidth/320.0, 150*screenWidth/320.0, 30*screenWidth/320.0)];
        firstLabel.textAlignment=NSTextAlignmentLeft;
        firstLabel.text=titleArray1[i];
        firstLabel.font=[UIFont systemFontOfSize:15*screenWidth/320.0];
        [thirdView addSubview:firstLabel];
        
        if(i==2)
        {
            UILabel *banbenLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-90*screenWidth/320.0, 5*screenWidth/320.0+i*40*screenWidth/320.0, 50*screenWidth/320.0, 30*screenWidth/320.0)];
            banbenLabel.text=[NSString stringWithFormat:@"v%@",user.BenDiBanBen];
            banbenLabel.textColor=[UIColor lightGrayColor];
            banbenLabel.font=[UIFont systemFontOfSize:14];
            banbenLabel.textAlignment=NSTextAlignmentCenter;
            [thirdView addSubview:banbenLabel];
        }
        
        UIImageView *jiantouImage1=[[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-40*screenWidth/320.0, 10*screenWidth/320.0+i*40*screenWidth/320.0, 20*screenWidth/320.0, 20*screenWidth/320.0)];
        if(i==2)
        {
            jiantouImage1.image=nil;
        }
        else
        {
            jiantouImage1.image=[UIImage imageNamed:@"jiantou@3x.png"];
        }
        [thirdView addSubview:jiantouImage1];
        
        UIButton *secondButton=[UIButton buttonWithType:UIButtonTypeCustom];
        secondButton.frame=CGRectMake(0, i*40*screenWidth/320.0, self.view.frame.size.width, 40*screenWidth/320.0);
        secondButton.tag=200+i;
        [secondButton addTarget:self action:@selector(secondBtn:) forControlEvents:UIControlEventTouchUpInside];
        secondButton.backgroundColor=[UIColor clearColor];
        [thirdView addSubview:secondButton];
    }
//    //横线
    for(int j=0;j<titleArray1.count-1;j++)
    {
        UIImageView *lineImage=[[UIImageView alloc] initWithFrame:CGRectMake(0*screenWidth/320.0, 40*screenWidth/320.0+j*40*screenWidth/320.0, self.view.frame.size.width, 0.5*screenWidth/320.0)];
        lineImage.backgroundColor=[UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:0.85];
        [thirdView addSubview:lineImage];
    }

    //退出按钮
    UIButton *exitButton=[UIButton buttonWithType: UIButtonTypeCustom];
    exitButton.frame=CGRectMake(30*screenWidth/320.0, 455*screenWidth/320.0, self.view.frame.size.width-30*screenWidth/320.0*2, 50*screenWidth/320.0);
    [exitButton setTitle:@"退出登录" forState:UIControlStateNormal];
    exitButton.backgroundColor=[UIColor colorWithRed:0/225.0 green:55/255.0 blue:113/255.0 alpha:1.0];
    [exitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    exitButton.titleLabel.font=[UIFont boldSystemFontOfSize:16];
    [exitButton addTarget:self action:@selector(exitBtn) forControlEvents:UIControlEventTouchUpInside];
    [scrollview addSubview:exitButton];
    
    
   
}
#pragma mark  头像设置
-(void)headBtn
{
    NSLog(@"被点击了");
    
    actionSheetCename = [[UIActionSheet alloc]
                         initWithTitle:nil
                         delegate:self
                         cancelButtonTitle:@"取消"
                         destructiveButtonTitle:nil
                         otherButtonTitles:@"拍照", @"从相册选择", nil];
    actionSheetCename.tag = 201;
    actionSheetCename.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheetCename showInView:self.view];

}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    picker=[[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.allowsEditing=YES;
    switch (buttonIndex)
    {
        case 0:
        {
            
            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
            {
                picker.sourceType=UIImagePickerControllerSourceTypeCamera;
                
            }
            else
            {
                return;
            }
        }
            
            break;
        case 1:
        {
            
            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary])
            {
                picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
                
            }
        }
            
            break;
            
        default:
            return;
            break;
    }
    
    //[self presentModalViewController:picker animated:YES];
    [self presentViewController:picker animated:YES completion:nil];
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    //UIImage *image1 = [info objectForKey:UIImagePickerControllerEditedImage];
    
    headImage.image = image;
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSData *data;
        data = UIImageJPEGRepresentation(image, 0.05);//图片的压缩系数 1为正常大小
        
        //图片保存的路径
        //这里将图片放在沙盒的documents文件夹中
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        
        //文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:[NSString stringWithFormat:@"%@%@",@"/image",@".png"]] contents:data attributes:nil];
        
        //得到选择后沙盒中图片的完整路径
        filePath = [[NSString alloc]initWithFormat:@"%@%@%@",DocumentsPath,  @"/image",@".png"];
        NSLog(@"图片路径是%@",filePath);
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self panduan];
    
}
-(void)panduan
{
//    User *user=[User currentUser];
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"merId"] = user.merid;
//    NSString *strr = [filePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    
//    params[@"attachPath"] = strr;
//    NSLog(@"输出路径是%@",strr);
//    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
//
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    manager.responseSerializer= [AFHTTPResponseSerializer serializer];
//    
//    [manager POST:@"http://115.29.178.149/mobile/ss/uploadFaceImg.do" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        [formData appendPartWithFileData:UIImageJPEGRepresentation(headImage.image, 0.5) name:@"attachPath" fileName:[NSString stringWithFormat:@"%@%@",@"image",@".png"] mimeType:@"image/png"];
//        
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        //显示是否上传成功
//        NSLog(@"5555555%@",responseObject);
//    }];
    
    
    
    //   //把图片上传到服务器
    User * user = [User currentUser];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"merId"] = user.merid;
    NSString *strr = [filePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    params[@"attachPath"] = strr;
    NSLog(@"输出路径是%@",strr);
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager POST:@"http://121.41.118.80/mobile/ss/uploadFaceImg.do" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
    {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(headImage.image, 0.05) name:@"attachPath" fileName:[NSString stringWithFormat:@"%@%@",@"image",@".png"] mimeType:@"image/png"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSLog(@"*----------*****&7&&&7tupian1shangchuanchenggong%@",responseObject);
        NSString *sre = [responseObject objectForKey:@"respDesc"];
        NSLog(@"&&&&&&&&&&&&&%@",sre);
        [self toastResult:sre];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        
    }];
    
}
-(void)toastResult:(NSString *) toastMsg{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:toastMsg
                          message:nil
                          delegate:self
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil];
    [alert show];
}
-(void)detailBtn
{
    nextZhanghuViewController *nzvc=[[nextZhanghuViewController alloc] init];
    [self.navigationController pushViewController:nzvc animated:YES];
}
-(void)firstBtn:(UIButton *)firstbutton
{
    //NSLog(@"点击了地%d个按钮",firstbutton.tag-100);
    User *user=[User currentUser];
    switch (firstbutton.tag)
    {
        case 100:
        {
            changePWDViewController *cpvc=[[changePWDViewController alloc] init];
            [self.navigationController pushViewController:cpvc animated:YES];
           break;
        }
        case 101:
        {
            feilvxinxiViewController *flvc=[[feilvxinxiViewController alloc] init];
            [self.navigationController pushViewController:flvc animated:YES];
            break;
        }
        case 102:
        {
            if([[[NSUserDefaults standardUserDefaults] objectForKey:@"bangding"] isEqualToString:@"2"])
            {
                jiesuanGLViewController *jsvc=[[jiesuanGLViewController alloc] init];
                [self.navigationController pushViewController:jsvc animated:YES];
                 NSLog(@"走到这了1");
                break;
            }
            else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"bangding"] isEqualToString:@"1"])
            {
                NSMutableURLRequest *rever = [PostAsynClass postAsynWithURL:url1 andInterface:url11 andKeyArr:@[@"merId",@"loginId"]andValueArr:@[user.merid,user.phoneText]];
                //
                NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
                
                NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                
                
                //NSString *string=[receive stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                
                NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
                
                NSData *ata = [NSData alloc];
                
                ata = [str dataUsingEncoding:NSUTF8StringEncoding];
                
                NSDictionary *dic= [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];
                user.sm=[dic objectForKey:@"isAuthentication"];
                if([user.sm isEqualToString:@"I"])
                {
                    [self toastResult:@"审核中，无需绑定收款银行卡"];
                    break;
                }

                shimingViewController *svc=[[shimingViewController alloc] init];
                [self.navigationController pushViewController:svc animated:YES];
                 NSLog(@"走到这了2");
                break;
            }
           
            
        }
            case 103:
        {
            changePhoneNumViewController *cnvc=[[changePhoneNumViewController alloc] init];
            [self.navigationController pushViewController:cnvc animated:YES];
            break;
        }
        default:
            break;
            
    }
    
}
-(void)secondBtn:(UIButton *)secbutton
{
    //NSLog(@"点击了地%d个按钮",secbutton.tag-200);
    User *user=[User currentUser];
    switch (secbutton.tag)
    {
        case 200:
        {
            caozuoGuideViewController *cvc=[[caozuoGuideViewController alloc] init];
            [self.navigationController pushViewController:cvc animated:YES];
            break;
        }
            
        case 201:
        {
            yonghuXYViewController *yvc=[[yonghuXYViewController alloc] init];
            [self.navigationController pushViewController:yvc animated:YES];
            break;
        }
        case 202:
        {
//            if([user.banBen isEqualToString:user.BenDiBanBen])
//            {
//                [self toastResult:@"当前是最新版本，不需要更新"];
//                break;
//            }
//            else
//            {
//                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"版本更新" message:@"存在最新的版本程序，确认是否更新" delegate:self cancelButtonTitle:@"暂不更新" otherButtonTitles:@"更新版本", nil];
//                [alertView show];
//                alertView.tag=3;
//                //
//                break;
//            }
            break;
 
        }
        case 203:
        {
            aboutUsViewController *avc=[[aboutUsViewController alloc] init];
            [self.navigationController pushViewController:avc animated:YES];
            break;
        }
        default:
            break;
            
    }
}
//退出程序点击事件
-(void)exitBtn
{
    NSLog(@"退出程序");
    _alert= [[UIAlertView alloc]initWithTitle:@"确认退出" message:@"确认是否退出系统！" delegate:self cancelButtonTitle:@"暂不退出" otherButtonTitles:@"退出",nil];
    [_alert show];
    _alert.tag=2;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //如果一个界面有多个提示框，通过tag值区分，就像textField一样
    User *user=[User currentUser];
    //通过buttonIndex来确定点击的是提示框上的哪个按钮
    if (!buttonIndex)
    {
        
    }
    else
    {
        if(alertView.tag==2)
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        if(alertView.tag==3)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:user.URL]];
        }
        
    }
}

-(void)btn
{
    NSLog(@"被点击了");
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
