//
//  ControllerScanCode.m
//  iOrange
//
//  Created by XiangKai Yin on 6/27/15.
//  Copyright © 2015 yinxiangkai. All rights reserved.
//

#import "ControllerScanCode.h"
#import "SlurImageView.h"

@interface ControllerScanCode ()

@end

@implementation ControllerScanCode

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  self.view.backgroundColor = [UIColor grayColor];
  
  UIButton * closeButton = [UIButton buttonWithType:0];
  closeButton.frame = CGRectMake(218, 420, 44, 44);
  [closeButton setBackgroundImage:[UIImage imageNamed:@"home_scan_close"] forState:0];
  [closeButton addTarget:self action:@selector(onTouchBackAction:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:closeButton];
  
  UIButton * lightButton = [UIButton buttonWithType:0];
  lightButton.frame = CGRectMake(58, 420, 44, 44);
  [lightButton setBackgroundImage:[UIImage imageNamed:@"home_scan_light_off"] forState:0];
  [lightButton addTarget:self action:@selector(onTouchOpenLightAction:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:lightButton];
  
  UILabel * labIntroudction= [[UILabel alloc] initWithFrame:CGRectMake(15, 40, 290, 50)];
  labIntroudction.backgroundColor = [UIColor clearColor];
  labIntroudction.numberOfLines=2;
  labIntroudction.textColor=[UIColor whiteColor];
  labIntroudction.textAlignment = NSTextAlignmentCenter;
  labIntroudction.text=@"将二维码/条形码置于矩形方框内";
  [self.view addSubview:labIntroudction];
  
  
  UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 101, 296, 296)];
  imageView.image = [UIImage imageNamed:@"home_scan_pick_bg"];
  [self.view addSubview:imageView];
  
  upOrdown = NO;
  num =0;
  _line = [[UIImageView alloc] initWithFrame:CGRectMake(20, 110, 280, 24)];
  _line.image = [UIImage imageNamed:@"home_scan_line"];
  [self.view addSubview:_line];
  
  timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(onTimerAnimate:) userInfo:nil repeats:YES];

}

-(void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self setupCamera];
}

#pragma mark - 
#pragma mark - events

- (void)onTouchBackAction:(UIButton *)sender {
  [self dismissViewControllerAnimated:YES completion:^{
    [timer invalidate];
  }];
}

- (void)onTouchOpenLightAction:(UIButton *)sender {
  AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
  if (device.torchMode == AVCaptureTorchModeOff) {
    [device lockForConfiguration:nil];
    [device setTorchMode:AVCaptureTorchModeOn];
    [device unlockForConfiguration];
    [sender setBackgroundImage:[UIImage imageNamed:@"home_scan_light_on"] forState:0];
  }else{
    [device lockForConfiguration:nil];
    [device setTorchMode:AVCaptureTorchModeOff];
    [device unlockForConfiguration];
    [sender setBackgroundImage:[UIImage imageNamed:@"home_scan_light_off"] forState:0];
  }
}

- (void)onTimerAnimate:(NSTimer *)timer {
  if (upOrdown == NO) {
    num ++;
    _line.frame = CGRectMake(20, 110+2*num, 280, 24);
    if (2*num == 258) {
      upOrdown = YES;
    }
  }
  else {
    num --;
    _line.frame = CGRectMake(20, 110+2*num, 280, 24);
    if (num == 0) {
      upOrdown = NO;
    }
  }
}

- (void)setupCamera {
  // Device
  _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
  
  // Input
  _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
  
  // Output
  _output = [[AVCaptureMetadataOutput alloc]init];
  [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
//  _output.rectOfInterest =
  // Session
  _session = [[AVCaptureSession alloc]init];
  _session.sessionPreset = AVCaptureSessionPreset1920x1080;
  
  [_session setSessionPreset:AVCaptureSessionPresetHigh];
  if ([_session canAddInput:self.input]) {
    [_session addInput:self.input];
  }
  
  if ([_session canAddOutput:self.output]) {
    [_session addOutput:self.output];
  }
  
  // 条码类型 AVMetadataObjectTypeQRCode
  _output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
  
  // Preview
  _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
  _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
  _preview.frame =CGRectMake(20,110,280,280);
  [self.view.layer insertSublayer:self.preview atIndex:0];
  
  // Start
  [_session startRunning];
}

#pragma mark -
#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
  
  NSString *stringValue;
  
  if ([metadataObjects count] >0) {
    AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
    stringValue = metadataObject.stringValue;
  }
  
  [_session stopRunning];
  [self dismissViewControllerAnimated:YES completion:^ {
     [timer invalidate];
    NSString *dataUTF8 = [stringValue stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if ([_delegateScanCode respondsToSelector:@selector(scanEndResultWithString:)]) {
      [_delegateScanCode scanEndResultWithString:dataUTF8];
    }
   }];
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
