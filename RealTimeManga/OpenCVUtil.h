//
//  OpenCVUtil.h
//  RealTimeProcessing
//
//  Created by hirai.yuki on 2013/04/07.
//  Copyright (c) 2013年 hirai.yuki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <opencv2/opencv.hpp>

/**
 OpenCV用ユーティリティクラス
 */
@interface OpenCVUtil : NSObject

/**
 `UIImage`インスタンスをOpenCV画像データに変換するメソッド
 
 @param     image       `UIImage`インスタンス
 @return    `IplImage`インスタンス
 */
+ (IplImage *)IplImageFromUIImage:(UIImage *)image;

/**
 OpenCV画像データを`UIImage`インスタンスに変換するメソッド
 
 @param     image `IplImage`インスタンス
 @return    `UIImage`インスタンス
 */
+ (UIImage *)UIImageFromIplImage:(IplImage*)image;

@end
