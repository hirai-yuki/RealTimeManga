//
//  AVFoundationUtil.h
//  RealTimeProcessing
//
//  Created by hirai.yuki on 2013/04/07.
//  Copyright (c) 2013年 hirai.yuki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreVideo/CoreVideo.h>

/**
 AVFoundation.framework用ユーティリティクラス
 */
@interface AVFoundationUtil : NSObject

/**
 サンプルバッファのデータから`UIImage`インスタンスを生成する
 
 @param     sampleBuffer       サンプルバッファ
 @return    生成した`UIImage`インスタンス
 */
+ (UIImage *)imageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer;

/**
 デバイスの向きからカメラAPIの向きを判別する
 
 @param     deviceOrientation   デバイスの向き
 @return    カメラの向き
 */
+ (AVCaptureVideoOrientation)videoOrientationFromDeviceOrientation:(UIDeviceOrientation)deviceOrientation;

@end
