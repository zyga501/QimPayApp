//
//  shimingViewController.m
//  JYBF
//
//  Created by 王健超 on 15/8/24.
//  Copyright (c) 2015年 wjc. All rights reserved.
//

#import "shimingViewController.h"
#import "Header.h"
#import "MyNavigationBar.h"
#include "PostAsynClass.h"
#import <AVFoundation/AVFoundation.h>
#import "AFHTTPRequestOperationManager.h"
#import "AFURLResponseSerialization.h"
#import "AFHTTPRequestOperation.h"
#import "shiModelViewController.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"
#import "User.h"
@interface shimingViewController ()<UITextViewDelegate>
{
    UIButton *_altBtn;
    
    UITextField *_name;
    
    UITextField *_number;
    
    UITextField *_nameId;
    UITextView *_fenhang;
    
    UILabel *_lab;
    
    UITextField *_field;
    
    UIButton *_upBtn;
    
    UIButton *_downBtn;
    
    AVCaptureSession * _AVSession;//调用闪光灯的时候创建的类
    
    UIActionSheet *_as;
    
    NSString *_str;
    
    NSDictionary *dic;
    UIImageView *_view;
    UIImageView *_imageView;
    
    UIImageView *smallimage;
    
    
    NSDictionary *_dic1;
    
    int _btndownTag;
    
    int _select;
    
    //scrollerView布局
    UIScrollView *_scr;
    
    MBProgressHUD* progress_;
    //姓名
    UITextField *fielab;
    
    UIImage *_img1;
    
    UIImage *_img2;
    
    UIImage *_img3;
    
}
@property (nonatomic,strong) UIImage * iamge;

@end

@implementation shimingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _select = 0;
    [self makeNav];
    [self makeUI];
    
     self.view.backgroundColor=[UIColor whiteColor];
    // Do any additional setup after loading the view.
}
-(void)makeNav
{
    //导航
    [self.navigationController setNavigationBarHidden:YES];
    MyNavigationBar *mnb = [[MyNavigationBar alloc] init];
    mnb.frame = CGRectMake(0, 20*screenWidth/320, 320*screenWidth/320, 44*screenWidth/320);
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:[NSArray arrayWithObject:@"title_back.png"] andRightBBIImages:nil andTitle:@"绑定银行卡" andClass:self andSEL:@selector(bbaClick:)];
    [self.view addSubview:mnb];
 
}
-(void)bbaClick:(UIButton*)btn
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}
-(void)makeUI
{

    //状态栏颜色
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320*screenWidth/320, 20*screenWidth/320)];
    
    statusBarView.backgroundColor=[UIColor colorWithRed:0/255.0 green:55/255.0 blue:113/255.0 alpha:1];
    
    [self.view addSubview:statusBarView];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    
    //scrolView布局
    _scr = [[UIScrollView alloc] initWithFrame:CGRectMake(0,64, screenWidth, screenHeight)];
    
    _scr.contentSize = CGSizeMake(0, 568);
    _scr.bounces = NO;//设置是否反弹
    _scr.showsVerticalScrollIndicator = NO;//设置纵向滑块的隐藏
    [self.view addSubview:_scr];

    //模板
    UIButton *bon=[UIButton buttonWithType:UIButtonTypeSystem];
    bon.frame=CGRectMake(20, 343*screenWidth/320, 100, 20);
    [bon setTitle:@"查看认证示例" forState:UIControlStateNormal];
    [bon addTarget:self action:@selector(bu) forControlEvents:UIControlEventTouchUpInside];
    [_scr addSubview:bon];
 
    //注意
    NSArray *titA=@[@"1、必须上传身份证和银行卡的正、反面照片",@"2、手持证件照片需拍到持有人五官",@"3、不能配戴眼镜拍照，拍照时请勿遮住脸部"];
    for(int i=0;i<3;i++)
        
    {
        
        UILabel *xuzhi=[[UILabel alloc] initWithFrame:CGRectMake(20*screenWidth/320, (363+i*21)*screenWidth/320, 300*screenWidth/320, 20*screenWidth/320)];
        xuzhi.text=titA[i];
        xuzhi.textColor=[UIColor grayColor];
        xuzhi.font=[UIFont systemFontOfSize:13];
        [_scr addSubview:xuzhi];
        
    }
    

    
    User *user=[User currentUser];
    //结算户主
    fielab=[[UITextField alloc] initWithFrame:CGRectMake(100*screenWidth/320, 105*screenWidth/320, 100*screenWidth/320, 20*screenWidth/320)];
    fielab.delegate=self;
    fielab.font=[UIFont systemFontOfSize:14];
    fielab.text=user.name;
    fielab.textColor=[UIColor grayColor];
    [_scr addSubview:fielab];
    NSLog(@"$$$#$#$#$#$#$__________%@",fielab.text);
    
    
    //横条竖条
    for(int i=0;i<4;i++)
    {
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(10*screenWidth/320, (50+i*40)*screenWidth/320, self.view.frame.size.width-20, 0.5*screenWidth/320)];
        view.backgroundColor=[UIColor lightGrayColor];
        [_scr addSubview:view];
    }
 
    for(int i=0;i<4;i++)
    {
        UIView *view2=[[UIView alloc] initWithFrame:CGRectMake(80*screenWidth/320, (25+i*40)*screenWidth/320, 1*screenWidth/320, 20*screenWidth/320)];
        view2.backgroundColor=[UIColor lightGrayColor];
        [_scr addSubview:view2];
    }
    NSArray *arr=@[@"结算银行",@"身份证号",@"结算户主",@"结算卡号"];
    for(int i=0;i<arr.count;i++)
    {
        UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(20*screenWidth/320, (24+i*40)*screenWidth/320, 60*screenWidth/320,20*screenWidth/320 )];
        lab.text=arr[i];
        lab.font=[UIFont systemFontOfSize:13];
        lab.textColor=[UIColor lightGrayColor];
        [_scr addSubview:lab];
    }

    NSMutableURLRequest *rever = [PostAsynClass postAsynWithURL:url1 andInterface:url11 andKeyArr:@[@"merId",@"loginId"]andValueArr:@[user.merid,user.phoneText]];
    //
    NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    
    //NSString *string=[receive stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
    
    NSData *ata = [NSData alloc];
    
    ata = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dicc= [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];
    
    //身份证
    _nameId=[[UITextField alloc] initWithFrame:CGRectMake(100*screenWidth/320,60*screenWidth/320, 250*screenWidth/320, 30*screenWidth/320) ];
    _nameId.delegate=self;
    _nameId.text = [[dicc objectForKey:@"certId" ] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    _nameId.font=[UIFont systemFontOfSize:14];
    _nameId.textColor=[UIColor lightGrayColor];
    [_scr addSubview:_nameId];
    
    _altBtn=[UIButton buttonWithType:UIButtonTypeSystem];
    _altBtn.frame=CGRectMake(20*screenWidth/320, 20*screenWidth/320, 250*screenWidth/320, 30*screenWidth/320);
    [_altBtn setTitle:@"选择结算银行" forState:UIControlStateNormal];
    
    [_altBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_altBtn addTarget:self action:@selector(alert:) forControlEvents:UIControlEventTouchUpInside];
    [_scr addSubview:_altBtn];
    
    //结算卡号
    _field=[[UITextField alloc] initWithFrame:CGRectMake(100*screenWidth/320,140*screenWidth/320, 250*screenWidth/320, 30*screenWidth/320)];
    _field.delegate=self;
    _field.font=[UIFont systemFontOfSize:14];
    [_scr addSubview:_field];
    
//    //分行输入
//    _fenhang=[[UITextView alloc] initWithFrame:CGRectMake(100*screenWidth/320,180*screenWidth/320, 200*screenWidth/320, 30*screenWidth/320)];
//    _fenhang.delegate=self;
//    _fenhang.font=[UIFont systemFontOfSize:14];
//    [_scr addSubview:_fenhang];
    
    UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(10*screenWidth/320, 180*screenWidth/320, self.view.frame.size.width-20, 40*screenWidth/320)];
    lab.font=[UIFont systemFontOfSize:13];
    lab.numberOfLines=0;
    lab.textColor=[UIColor grayColor];
    lab.adjustsFontSizeToFitWidth=YES;
    lab.text=@"请拍摄如下照片用于认证（上传图片占用较大流量，建议使用wifi）";
    [_scr addSubview:lab];
    
    
    NSArray *upArr=@[@"身份证+银行卡(正面)",@"身份证+银行卡(反面)",@"手持身份证+银行卡(正面)"];
    for(int i=0;i<3;i++)
    {
        
        _upBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _upBtn.frame=CGRectMake((13+i*103)*screenWidth/320, 230*screenWidth/320, (self.view.frame.size.width-47)/3, 110*screenWidth/320);
        [_upBtn setBackgroundImage:[UIImage imageNamed:@"lh_shimrz_bg.png"] forState:UIControlStateNormal];
        [_upBtn setTitle:upArr[i] forState:UIControlStateNormal];
        [_upBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_upBtn addTarget:self action:@selector(btnn:) forControlEvents:UIControlEventTouchUpInside];
        _upBtn.titleEdgeInsets=UIEdgeInsetsMake(60*screenWidth/320, 0, 0, 0);
        _upBtn.titleLabel.font=[UIFont systemFontOfSize:13];
        //按钮文字换行
        _upBtn.titleLabel.numberOfLines=0;
        [_upBtn.titleLabel sizeToFit];
        
        [_scr addSubview:_upBtn];
        _upBtn.tag=100+i;
    }

    UIButton *btn=[UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame=CGRectMake(20*screenWidth/320, 430*screenWidth/320, self.view.frame.size.width-40, 40*screenWidth/320);
    [btn setTitle:@"提交结算银行卡" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor=[UIColor colorWithRed:0/255.0 green:55/255.0 blue:113/255.0 alpha:1];
    [btn addTarget:self action:@selector(btton) forControlEvents:UIControlEventTouchUpInside];
    [_scr addSubview:btn];
    
}

-(void)bu
{
    shiModelViewController *mo=[[shiModelViewController alloc] init];
    [self.navigationController pushViewController:mo animated:YES];
}
-(void)btnn:(UIButton*)btn
{
    //设置照相机
    NSString *mediaType = AVMediaTypeVideo;
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"相机被禁止访问，请设置开通后重新登录" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        
        
        return;
    }
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing=YES;
        picker.sourceType = sourceType;
        
        _btndownTag = btn.tag;
        
        //smallimage=[[UIImageView alloc]initWithFrame:btn.frame];
        
        [self presentModalViewController:picker animated:YES];
    }
    else
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
    
    
}

//当选择一张图片后进入这里

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSData *data;
        //        if (UIImagePNGRepresentation(image) == nil)
        //        {
        data = UIImageJPEGRepresentation(image, 0.05);//图片的压缩系数 1为正常大小
        //        }
        //        else
        //        {
        //            data = UIImagePNGRepresentation(image);
        //        }
        
        
        //图片保存的路径
        //这里将图片放在沙盒的documents文件夹中
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        
        
        //文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:[NSString stringWithFormat:@"%@%d%@",@"/image",_btndownTag,@".png"]] contents:data attributes:nil];
        
        //得到选择后沙盒中图片的完整路径
        filePath = [[NSString alloc]initWithFormat:@"%@%@%d%@",DocumentsPath,  @"/image",_btndownTag,@".png"];
        
        //关闭相册界面
        [picker dismissModalViewControllerAnimated:YES];
        //创建一个选择后图片的小图标放在下方
        //类似微薄选择图后的效果
        
        UIButton * btn =(UIButton*)[self.view viewWithTag:_btndownTag];
        
        [btn setImage:image forState:UIControlStateNormal];
        
        switch (_btndownTag) {
            case 100:
            {
                _img1 = image;
                [btn setImage:_img1 forState:UIControlStateNormal];
                
            }
                break;
            case 101:
            {
                _img2 = image;
                [btn setImage:_img2 forState:UIControlStateNormal];
            }
                break;
                
            case 102:
            {
                _img3 = image;
                [btn setImage:_img3 forState:UIControlStateNormal];
            }
                break;
                
                //            default:
                //                break;
        }
        

        //
        //
//        smallimage.image = image;
//        
//        smallimage.tag = _btndownTag+1000;
//        //        self.iamge = image;
//        //加在视图中
//        [_scr addSubview:smallimage];
        //    //图片上传
      
    }
    
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker

{
    
    NSLog(@"您取消了选择图片");
    
    [picker dismissModalViewControllerAnimated:YES];
    
}

-(void)sendInfo

{
    
    NSLog(@"图片的路径是：%@", filePath);

    NSLog(@"您输入框中的内容是：%@", _textEditor.text);
    
}

//提交实名
//-(void)btton
//{
//    if(_str==nil ){
//        [self toastResult:@"请选择结算银行"];
//        return;
//    }
//    
//    if (_nameId.text ==nil||[@"" isEqual:_nameId.text]) {
//        [self toastResult:@"请输入身份证号码"];
//        return;
//    }
//    if([_nameId.text length] >19 ||[_nameId.text length] <15){
//        [self toastResult:@"身份证长度必须15~18位"];
//        return;
//    }
//    if (_field.text == nil||[@"" isEqual:_field.text]) {
//        [self toastResult:@"请输入银行卡号"];
//        return;
//    }
//    if([_field.text length]< 10){
//        [self toastResult:@"卡号长度必须大于10位"];
//        return;
//    }
////    if(!(_fenhang.text!=NULL&&(_fenhang.text.length>=5&&_fenhang.text.length<=25)))
////    {
////        [self toastResult:@"请重新输入支行名称"];
////        return;
////    }
//
//    User * user = [User currentUser];
//    
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"merId"] = user.merid;
//    //  params[@"attachPath"] = UIImageJPEGRepresentation(self.iamge, 0.5);
//    NSString *str = nil;
//    int a;
//    switch (_select) {
//        case 0:
//        {
//            self.iamge =  _img1;
//            str =  @"身份证+银行卡(正面).png";
//            a = 1100;
//        }
//            break;
//        case 1:
//        {
//            self.iamge =  _img2;
//            str =  @"身份证+银行卡(反面).png";
//            a = 1101;
//        }
//            break;
//        case 2:
//        {
//            self.iamge =  _img3;
//            str =  @"手持身份证+银行卡(正面).png";
//            a = 1102;
//        }
//            break;
//        default:
//            break;
//    }
//    
//    
////    
////    UIImageView *img = (UIImageView*)[self.view viewWithTag:a];
////    
////    
////    //判断图片不足3张不上传图片
//    if(_img1==nil||_img2==nil||_img3==nil)
//    {
//        
//        [self toastResult:@"请把照片拍全在进行认证"];
//        return;
//        
//    }
//    
//    NSString *strr = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    
//    params[@"attachName"] = strr;
//    
//    
//    //_select++;
//    //开始提交照片就开始弹出菊花
//    
//    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeGradient];
//    
//    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
//    
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    
//    [manager POST:@"http://121.41.118.80/mobile/ss/uploadAttach.do" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        _btndownTag=_select+100;
//        [formData appendPartWithFileData:UIImageJPEGRepresentation(self.iamge, 0.05) name:@"attachPath" fileName:[NSString stringWithFormat:@"%@%d%@",@"image",_btndownTag,@".png"] mimeType:@"image/png"];
//        
//    } success:^(AFHTTPRequestOperation *operation, id responseObject)
//     {
//        if (_select==2) {
//            
//            [self btndown];
//
//            return ;
//        }
//        else
//        {
//            _select++;
//            [self btton];
//            
//        }
//        
//        NSLog(@"55555555555555555555555555%@",responseObject);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
//    {
//        NSLog(@"6666666666666666666666666%@",error);
//  
//        return ;
//    }];
//  
//}
-(void)btton
{
    if(_str==nil ){
        [self toastResult:@"请选择结算银行"];
        return;
    }
    
    if (_nameId.text ==nil||[@"" isEqual:_nameId.text]) {
        [self toastResult:@"请输入身份证号码"];
        return;
        
    }
    if([_nameId.text length] >18 ||[_nameId.text length] <15){
        [self toastResult:@"身份证长度必须15~18位"];
        return;
    }
    
    if (_field.text == nil||[@"" isEqual:_field.text]) {
        [self toastResult:@"请输入银行卡号"];
        return;
    }
    if([_field.text length]< 10){
        [self toastResult:@"卡号长度必须大于10位"];
        return;
    }
    
    
    
    //判断图片不足3张不上传图
    
    if(_img1==nil||_img2==nil||_img3==nil)
    {
        
        [self toastResult:@"请把照片拍全在进行认证"];
        return;
        
    }
    
    //开始提交照片就开始弹出菊花
    progress_ = [[MBProgressHUD alloc] initWithView:_scr];
    [self.view addSubview:progress_];
    [self.view bringSubviewToFront:progress_];
    progress_.delegate = self;
    progress_.labelText = @"加载中...";
    [progress_ show:YES];
    
    User * user = [User currentUser];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"merId"] = user.merid;
    //  params[@"attachPath"] = UIImageJPEGRepresentation(self.iamge, 0.5);
    NSString *str = nil;
    
    
    __block BOOL a1 = false,a2=false,a3=false;
    int b1=0,b2=0,b3=0;
    
    for (_select = 0; _select < 3; _select ++) {
        
        switch (_select) {
            case 0:
            {
                self.iamge =  _img1;
                
                str =  @"身份证+银行卡(正面).png";
                b1 = 1100;
                a1 = NO;
                
            }
                break;
            case 1:
            {
                str =  @"身份证+银行卡(反面).png";
                b2 = 1101;
                self.iamge =  _img2;
                a2 = NO;
                
            }
                break;
            case 2:
            {
                
                str =  @"手持身份证+银行卡(正面).png";
                b3 = 1102;
                
                a3 = NO;
                self.iamge = _img3;
                
            }
                break;
            default:
                break;
        }
        
        
        NSString *strr = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        params[@"attachName"] = strr;
        
        
        
        AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
        
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        
        _btndownTag = _btndownTag+_select;
        
        
        NSString *name =  [NSString stringWithFormat:@"%@%d%@",@"image",_btndownTag,@".png"];
        
        
        NSString *url = [[NSString  alloc]initWithFormat:@"%@%@", url1, url07];
        
        NSLog(@"$$$$$$$$$$$$$$$$$%@",url);
        
        [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:UIImageJPEGRepresentation(self.iamge, 0.05) name:@"attachPath" fileName:name  mimeType:@"image/png"];
            
            NSLog(@"!!!!!!!!!!!!!!!!!!!!!!!!---%@",name);
            
            
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            
            NSLog(@"55555555555555555555555555%@11111()%d",responseObject,_select);
            
            if ( [name isEqualToString:@"image102.png"]) {
                a1 = YES;
            }
            else if ([name isEqualToString:@"image103.png"])
            {
                a2 = YES;
                
            }
            else if ([name isEqualToString:@"image105.png"])
            {
                a3 = YES;
                
            }
            
            NSLog(@"ifReadOnlya1 value: %@" ,a1?@"YES":@"NO");
            NSLog(@"ifReadOnlya2 value: %@" ,a2?@"YES":@"NO");
            
            NSLog(@"ifReadOnlya3 value: %@" ,a3?@"YES":@"NO");
            
            if (a1&&a2&&a3) {
                
                [self btndown];
                //                [self tijiao];
                return ;
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"6666666666666666666666666%@",error);
            
            //            if (a1==NO||a2==NO||a3==NO)
            //            {
            //
            //                //                [self btndown];
            //                //                [self tijiao];
            //                [self toastResult:@"图片上传失败，请检查您的网络"];
            //                [self.navigationController popViewControllerAnimated:YES];
            //
            //
            //                return ;
            //            }
            
            
            return ;
        }];
    }
    
}

- (void)btndown
{
 
        User *user=[User currentUser];
    
    if ([user.sm isEqualToString:@"I"]) {
        
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"审核中，无需重复提交" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [self.navigationController popViewControllerAnimated:YES];
        return;
        
    }

    _select=0;
    //结算卡银行
    NSStringEncoding enc1 = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
    //
    NSString *strr = [fielab.text stringByAddingPercentEscapesUsingEncoding:enc1];
    NSMutableURLRequest *rever1 = [PostAsynClass postAsynWithURL:url1 andInterface:url06 andKeyArr:@[@"merId",@"openAcctName",@"openAcctId",@"openBankId",@"cardType"]andValueArr:@[user.merid,strr,_field.text,_str,@"J"]];
    NSData *receive1 = [NSURLConnection sendSynchronousRequest:rever1 returningResponse:nil error:nil];
    //NSString *string=[receive stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString  *str1 = [[NSString alloc] initWithData:receive1 encoding:enc1];
    NSData *ata1 = [NSData alloc];
    ata1 = [str1 dataUsingEncoding:NSUTF8StringEncoding];
    
    _dic1= [NSJSONSerialization JSONObjectWithData:ata1 options:NSJSONReadingMutableLeaves error:nil];
    NSString *sre = [_dic1 objectForKey:@"respDesc"];
    NSLog(@"&&&&&&&&&&&&&%@",sre);
    
    //取消等待图
    [SVProgressHUD dismiss];
    
    if(![[_dic1 objectForKey:@"respCode"]isEqualToString:@"000"])
    {
        [self toastResult:sre];
        
    }
    
    if ([[_dic1 objectForKey:@"respCode"] isEqualToString:@"008"])
    {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"未登录或登录失效，请重新登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        alertView.tag=2;
    }
   
    NSLog(@"jiesuankahao%@",_dic1);
  
    if ([[_dic1 objectForKey:@"respCode"] isEqualToString:@"000"]) {
        
        
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
        
        NSString *strr = [fielab.text stringByAddingPercentEscapesUsingEncoding:enc];
        
        NSMutableURLRequest *rever = [PostAsynClass postAsynWithURL:url1 andInterface:url08 andKeyArr:@[@"merId",@"merName",@"certId"]andValueArr:@[user.merid,strr,_nameId.text]];
        //
        NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
        //NSString *string=[receive stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
        NSData *ata = [NSData alloc];        
        ata = [str dataUsingEncoding:NSUTF8StringEncoding];
        dic= [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];

        NSLog(@"tijiaoshiming%@",dic);
        NSString *sre = [dic objectForKey:@"respDesc"];
        NSLog(@"&&&&&&&&&&&&&%@",sre);
        
        //取消等待图
        [SVProgressHUD dismiss];
        
        
        if(![[dic objectForKey:@"respCode"]isEqualToString:@"000"])
        {
            [self toastResult:sre];
            
        }
        
    }
    if ([[dic objectForKey:@"respCode"] isEqualToString:@"000"]) {
        
        
        [self toastResult:@"已提交，请等待审核"];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}
//点击return 按钮 去掉
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //如果一个界面有多个提示框，通过tag值区分，就像textField一样
    
    //通过buttonIndex来确定点击的是提示框上的哪个按钮
    if (!buttonIndex) {
        
        
    } else {
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }
}

//用户未输入任何信息提示
-(void)toastResult:(NSString *) toastMsg{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:toastMsg
                          message:nil
                          delegate:self
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark - 登陆失败之后显示的警示框
- (void)showFailAlertView
{
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"登录失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
    
}

#pragma mark -触摸隐藏键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_field  resignFirstResponder];
//    [_fenhang resignFirstResponder];
    [_nameId resignFirstResponder];
}
-(void)alert:(UIButton*)btn
{
    // @"中国农业银行",@"中国建设银行",@"中国交通银行",@"招商银行",@"中信银行",@"光大银行",@"北京银行"
    
    _as = [[UIActionSheet alloc]initWithTitle:@"请选择银行" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"中国工商银行",@"中国农业银行",@"中国建设银行",@"中国交通银行",@"招商银行",@"中信银行",@"光大银行",@"北京银行", nil];
    
    //在某个view中展示
    [_as showInView:self.view];
    
    
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex

{
    
    //通过buttonIndex来确定点击的是actionSheet上的哪个按钮
    
    switch (buttonIndex) {
        case 0:
            _str =@"icbc";
            [_altBtn setTitle:@"中国工商银行" forState:UIControlStateNormal];
            break;
        case 1:
            _str=@"abc";
            [_altBtn setTitle:@"中国农业银行" forState:UIControlStateNormal];
            
            break;
        case 2:
            _str =@"ccb";
            [_altBtn setTitle:@"中国建设银行" forState:UIControlStateNormal];
            break;
        case 3:
            _str =@"bankcomm";
            [_altBtn setTitle:@"中国交通银行" forState:UIControlStateNormal];
            break;
        case 4:
            _str=@"cmb";
            [_altBtn setTitle:@"招商银行" forState:UIControlStateNormal];
            break;
        case 5:
            _str=@"ecitic";
            [_altBtn setTitle:@"中信银行" forState:UIControlStateNormal];
            break;
        case 6:
            _str=@"cebbank";
            [_altBtn setTitle:@"光大银行" forState:UIControlStateNormal];
            
            break;
        case 7:
            _str=@"bankofbj";
            [_altBtn setTitle:@"北京银行" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    
    
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
