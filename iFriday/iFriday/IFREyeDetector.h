//
//  IFREyeDetector.h
//  iFriday
//
//  Created by tanjo yuuki on 2013/09/14.
//  Copyright (c) 2013年 Yosuke Hiraoka, Tanjo Yuki. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifdef __cplusplus
#import <opencv2/opencv.hpp>
#endif

@interface IFREyeDetector : NSObject
#ifdef __cplusplus
+ (cv::Mat)cvMatFromUIImage:(UIImage *)image;
+ (cv::Mat)cvMatGrayFromUIImage:(UIImage *)image;
+ (UIImage *)UIImageFromCVMat:(cv::Mat)cvMat;
+ (UIIMage *)EyeDetector:(UIIMage *)image;
#endif
@end