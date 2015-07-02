//
//  ControllerScanCode.h
//  iOrange
//
//  Created by XiangKai Yin on 6/27/15.
//  Copyright © 2015 yinxiangkai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol ScanCodeDelegate <NSObject>

- (void)scanEndResultWithString:(NSString *)link;

@end

@interface ControllerScanCode : UIViewController <AVCaptureMetadataOutputObjectsDelegate>{
  int num;
  BOOL upOrdown;
  NSTimer * timer;
}
@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;
@property (nonatomic, retain) UIImageView * line;
@property (nonatomic,assign)id<ScanCodeDelegate> delegateScanCode;


@end
