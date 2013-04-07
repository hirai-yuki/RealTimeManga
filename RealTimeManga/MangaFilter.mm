//
//  MangaFilter.m
//  RealTimeProcessing
//
//  Created by hirai.yuki on 2013/04/07.
//  Copyright (c) 2013年 hirai.yuki. All rights reserved.
//

#import "MangaFilter.h"
#import "OpenCVUtil.h"

@implementation MangaFilter

+ (UIImage *)doFilter:(UIImage *)image
{
    UIImage *lineImage = [MangaFilter lineFilter:image];
    UIImage *monochromeImage = [MangaFilter monochromeFilter:image];
    
    CGRect imageRect = CGRectMake(0.0f, 0.0f, monochromeImage.size.width, monochromeImage.size.height);
    
    // オフスクリーン描画のためのグラフィックスコンテキストを用意
    UIGraphicsBeginImageContext(monochromeImage.size);
    
    // 白黒部分の画像をコンテキストに描画
    [monochromeImage drawInRect:imageRect];
    
    // 輪郭画像をコンテキストに描画
    [lineImage drawInRect:imageRect];
    
    // 4-4.合成画像をコンテキストから取得
    UIImage *margedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 4-5.オフスクリーン描画を終了
    UIGraphicsEndImageContext();
    
    return margedImage;
}

+ (UIImage *)lineFilter:(UIImage *)image
{
    // CGImageからIplImageを作成
    IplImage *srcImage       = [OpenCVUtil IplImageFromUIImage:image];
    
    IplImage *grayscaleImage = cvCreateImage(cvGetSize(srcImage), IPL_DEPTH_8U, 1);
    IplImage *edgeImage      = cvCreateImage(cvGetSize(srcImage), IPL_DEPTH_8U, 1);
    IplImage *dstImage       = cvCreateImage(cvGetSize(srcImage), IPL_DEPTH_8U, 3);
    
    // グレースケール画像に変換
    cvCvtColor(srcImage, grayscaleImage, CV_BGR2GRAY);
    
    // グレースケール画像を平滑化
    cvSmooth(grayscaleImage, grayscaleImage, CV_GAUSSIAN, 3, 0, 0);
    
    // エッジ検出画像を作成
    cvCanny(grayscaleImage, edgeImage, 20, 120);
    
    // エッジ検出画像色を反転
    cvNot(edgeImage, edgeImage);
    
    // CGImage用にBGRに変換
    cvCvtColor(edgeImage, dstImage, CV_GRAY2BGR);
    
    // IplImageからCGImageを作成
    UIImage *effectedImage = [OpenCVUtil UIImageFromIplImage:dstImage];
    
    cvReleaseImage(&srcImage);
    cvReleaseImage(&grayscaleImage);
    cvReleaseImage(&edgeImage);
    cvReleaseImage(&dstImage);
    
    // 白色の部分を透過する
    const float colorMasking[6] = {255, 255, 255, 255, 255, 255};
    CGImageRef imageRef = CGImageCreateWithMaskingColors(effectedImage.CGImage, colorMasking);
    UIImage *lineImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return lineImage;
}

+ (UIImage *)monochromeFilter:(UIImage *)image
{
    // CGImageからIplImageを作成
    IplImage *srcImage       = [OpenCVUtil IplImageFromUIImage:image];
    IplImage *grayScaleImage = cvCreateImage(cvGetSize(srcImage), IPL_DEPTH_8U, 1);
    IplImage *dstImage       = cvCreateImage(cvGetSize(srcImage), IPL_DEPTH_8U, 3);
    
    // グレースケール画像に変換
    cvCvtColor(srcImage, grayScaleImage, CV_BGR2GRAY);
    
    // グレースケール画像を1画素ずつ走査して３値化する
    for(int y = 0; y < grayScaleImage->height; y++) {
        for(int x = 0; x < grayScaleImage->width; x++) {
            int a = grayScaleImage->widthStep * y + x;
            uchar p = grayScaleImage->imageData[a];
            
            if (p < 70) {
                // 70より小さい場合、黒
                grayScaleImage->imageData[a] = 0;
            } else if (70 <= p && p < 120) {
                // 70以上、120未満の場合、灰色
                grayScaleImage->imageData[a] = 100;
            } else {
                // 120以上の場合、白
                grayScaleImage->imageData[a] = 255;
            }
        }
    }
    
    // CGImage用にBGRに変換
    cvCvtColor(grayScaleImage, dstImage, CV_GRAY2BGR);
    
    // IplImageからCGImageを作成
    UIImage *effectedImage = [OpenCVUtil UIImageFromIplImage:dstImage];
    
    cvReleaseImage(&srcImage);
    cvReleaseImage(&grayScaleImage);
    cvReleaseImage(&dstImage);
    
    // 灰色の部分を透過する
    const float colorMasking[6] = {100, 100, 100, 100, 100, 100};
    CGImageRef imageRef = CGImageCreateWithMaskingColors(effectedImage.CGImage, colorMasking);
    UIImage *monochromeFilter = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return monochromeFilter;
}

@end
