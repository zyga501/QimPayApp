//
//  saoYSViewController.m
//  JYBF
//
//  Created by 王健超 on 15/9/7.
//  Copyright (c) 2015年 wjc. All rights reserved.
//

#import "saoYSViewController.h"
#import "User.h"
#import "Header.h"
#import "PostAsynClass.h"
#import "MyNavigationBar.h"
#import <AVFoundation/AVFoundation.h>
#import "NEXTsysViewController.h"
#import "SaoMiaoViewController.h"
//获取屏幕的高度
#define HEIGHT [UIScreen mainScreen].bounds.size.height
//获取屏幕的宽度
#define WIDTH  [UIScreen mainScreen].bounds.size.width
@interface saoYSViewController ()<AVCaptureMetadataOutputObjectsDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    int num;
    UILabel *_alertLabel;   //提示文字
    UIImageView *_imgView;  //扫描框图片
    UIImageView *_lineView; //扫描线
    NSTimer *_timer;        //上下动的计时器
    BOOL _upOrdown;         //上下动的标记
    UIView *_seccessView;   //扫描成功覆盖扫描二维码的view
    NSArray *dateArray;
    NSString *stringValue;
}
@property(nonatomic, strong)AVCaptureDevice * device;//
@property(nonatomic, strong)AVCaptureDeviceInput * input;//音视频设备输入端
@property(nonatomic, strong)AVCaptureMetadataOutput * output;//音视频输出端
@property(nonatomic, strong)AVCaptureSession *session;// 会话条
@property(nonatomic, strong)AVCaptureVideoPreviewLayer * preview;//捕捉视频预览层



@end

@implementation saoYSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeNav];
    [self makeUI];
    self.view.backgroundColor=[UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:0.7];

    //相机界面的定制在self.view上加载即可
    BOOL Custom= [UIImagePickerController
                  isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];//判断摄像头是否能用
    if (Custom)
    {
        [self stepIntoCamera];//启动摄像头
    }
    else
    {
        UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"提示" message:@"摄像头不能使用" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [al show];
    }
    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(stepIntoCamera) name:@"stepIntoCamera" object:nil];

    // Do any additional setup after loading the view.
}
-(void)makeNav
{
    //导航
    [self.navigationController setNavigationBarHidden:YES];
    MyNavigationBar *mnb = [[MyNavigationBar alloc] init];
    mnb.frame = CGRectMake(0, 20*screenWidth/320, 320*screenWidth/320, 44*screenWidth/320);
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:[NSArray arrayWithObject:@"title_back.png"] andRightBBIImages:nil andTitle:@"扫一扫" andClass:self andSEL:@selector(bacClick:)];
    [self.view addSubview:mnb];
}
-(void)makeUI
{
    //User *user=[User currentUser];
    //状态栏颜色
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320*screenWidth/320, 20*screenWidth/320)];
    
    statusBarView.backgroundColor=[UIColor colorWithRed:0/255.0 green:55/255.0 blue:113/255.0 alpha:1];
    
    [self.view addSubview:statusBarView];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    
    _alertLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 74*screenWidth/320.0, WIDTH, 30*screenWidth/320.0)];
    _alertLabel.backgroundColor = [UIColor clearColor];
    _alertLabel.numberOfLines = 2;
    _alertLabel.textColor = [UIColor whiteColor];
    _alertLabel.text = @"将取景框对准二维码，即可自动扫描。";
    _alertLabel.textAlignment = NSTextAlignmentCenter;
    
    _alertLabel.lineBreakMode = NSLineBreakByWordWrapping;
    //    NSLineBreakByWordWrapping, 以空格为边界，保留单词
    //    NSLineBreakByCharWrapping, 保留整个字符
    //    NSLineBreakByClipping,     简单剪裁，到边界为止
    //    NSLineBreakByTruncatingHead,前面部分文字以....方式省略，显示尾部文字内容
    //    NSLineBreakByTruncatingTail,结尾的内容以....方式省略，显示头的文字内容
    //    NSLineBreakByTruncatingMiddle,中间的内容以....方式省略，显示首尾的内容
    
    _alertLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_alertLabel];
    
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 114, WIDTH-100, WIDTH-100)];
    _imgView.image = [UIImage imageNamed:@"pick_bg@2x.png"];
    [self.view addSubview:_imgView];
    
    _lineView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 160, WIDTH-100, 2)];
    _lineView.center = CGPointMake(WIDTH/2, _imgView.center.y);
    _lineView.image = [UIImage imageNamed:@"line@2x.png"];
    [self.view addSubview:_lineView];
    
    
    //定时器
    _timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    //开始时扫描线向下运动
    _upOrdown = NO;
    num = 0;

}
#pragma mark - 扫描线移动动画
-(void)animation1
{
    if (_upOrdown == NO)
    {
        _lineView.center = CGPointMake(WIDTH/2, _imgView.center.y+(num++));
        if (num == 100)
        {
            _upOrdown = YES;
        }
    }
    else
    {
        _lineView.center = CGPointMake(WIDTH/2, _imgView.center.y+(num--));
        if (num == -100)
        {
            _upOrdown = NO;
        }
    }
}

#pragma mark - 开启关闭闪光灯
-(void)flashLightClick:(UIButton *)btn
{
    NSLog(@"BBBB");
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if (device.torchMode==AVCaptureTorchModeOff)
    {
        //闪光灯开启
        [device lockForConfiguration:nil];
        [device setTorchMode:AVCaptureTorchModeOn];
    }
    else
    {
        //闪光灯关闭
        [device setTorchMode:AVCaptureTorchModeOff];
    }
}


#pragma mark 选择相册
- (void)pressPhotoLibraryButton:(UIButton *)button
{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //翻转效果
    picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    //选择后的图片可被编辑
    picker.allowsEditing = YES;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark 开启相机
- (void)stepIntoCamera
{
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    _output = [[AVCaptureMetadataOutput alloc] init];
    
    //[_output setRectOfInterest:CGRectMake((104)/HEIGHT,50/WIDTH,(WIDTH-90)/HEIGHT,(WIDTH-90)/WIDTH)];
    [_output setRectOfInterest:CGRectMake(0.1,0.18,0.78,0.86)];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    _session = [[AVCaptureSession alloc] init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    //AVMetadataObjectTypeAztecCode  二维码生成器
    //AVMetadataMachineReadableCodeObjectInternal
    /*交错式25条码(Interleaved 2 of 5 Code):AVMetadataObjectTypeInterleaved2of5Code*/
    /**AVMetadataObjectTypeITF14Code:
     ITF-14条码符号的放大系数范围为0.625～1.200，条码符号的大小随放大系数的变化而变化。当放大系数为1.000时，ITF-14条码符号各个部分的尺寸如图21所示。条码符号四周应设置保护框。保护框的线宽为4.8mm，线宽不受放大系数的影响。下图为ITF-14条码符号（放大系数为1.000）。*/
    
    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeUPCECode,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode39Mod43Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode93Code,AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeInterleaved2of5Code];
    // Preview :预览
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame =_imgView.frame;
    [self.view.layer insertSublayer:self.preview atIndex:1];
    // Start
    [_session startRunning];
}
-(void)viewDidDisappear:(BOOL)animated
{
     //[self.view.layer insertSublayer:self.preview atIndex:1];
    //[_session startRunning];
    [_preview removeFromSuperlayer];
}
#pragma mark -- AVCaptureMetadataOutputObjectsDelegate//IOS7下触发
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
   // NSString *stringValue;
    if (metadataObjects.count>0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        //NSLog(@"shuchuis` %@,%@",stringValue,self.navigationController);
        [_session stopRunning];
        
//        NEXTsysViewController *nvc= [[NEXTsysViewController alloc] init];
//        nvc.string=stringValue;
//        [self.navigationController pushViewController:nvc animated:YES];
        
        @try {
            dateArray = [stringValue componentsSeparatedByString:@"^"];
            
            NSRange   ange1 =NSMakeRange(0, 5);
            NSRange   ange2 =NSMakeRange(0, 6);
            
            NSString *u1 = [stringValue substringWithRange:ange1];
            NSString *u2 = [stringValue substringWithRange:ange2];
            
            NSLog(@"%@",u1);
            
            if ([u1 isEqualToString:@"http:"]||[u2 isEqualToString:@"https:"])
            {
                NSString *saomiaostring=[NSString stringWithFormat:@"扫描结果为:%@,是否打开",stringValue];
                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:saomiaostring delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alertView show];
                alertView.tag=3;
                return;
            }
            
            NEXTsysViewController *nvc= [[NEXTsysViewController alloc] init];
            nvc.string=stringValue;
            nvc.namestring=[dateArray objectAtIndex:2];
            nvc.phonenumstring=[dateArray objectAtIndex:3];
            nvc.numstring=[dateArray objectAtIndex:4];
            nvc.textstring=[dateArray objectAtIndex:5];
            [self.navigationController pushViewController:nvc animated:YES];
            _session = [[AVCaptureSession alloc] init];
            
        }
        @catch (NSException *exception) {
            
            
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"二维码错误，请扫描正确二维码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView show];
            alertView.tag=2;
            return;
        }
        @finally
        {
            
        }


    }
    
}


-(void)bacClick:(UIButton*)btn
{
    
    [self.navigationController popViewControllerAnimated:YES];
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
