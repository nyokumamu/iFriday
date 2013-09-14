//
//  IFREyeDetector.cpp
//  iFriday
//
//  Created by tanjo yuuki on 2013/09/14.
//  Copyright (c) 2013年 Yosuke Hiraoka, Tanjo Yuki. All rights reserved.
//

#include "IFREyeDetector.h"

#ifdef __cplusplus
+ (cv::Mat)cvMatFromUIImage:(UIImage *)image
{
  CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
  CGFloat cols = image.size.width;
  CGFloat rows = image.size.height;
  
  cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels
  
  CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                  cols,                       // Width of bitmap
                                                  rows,                       // Height of bitmap
                                                  8,                          // Bits per component
                                                  cvMat.step[0],              // Bytes per row
                                                  colorSpace,                 // Colorspace
                                                  kCGImageAlphaNoneSkipLast |
                                                  kCGBitmapByteOrderDefault); // Bitmap info flags
  
  CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
  CGContextRelease(contextRef);
  CGColorSpaceRelease(colorSpace);
  
  return cvMat;
}

+ (cv::Mat)cvMatGrayFromUIImage:(UIImage *)image
{
  CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
  CGFloat cols = image.size.width;
  CGFloat rows = image.size.height;
  
  cv::Mat cvMat(rows, cols, CV_8UC1); // 8 bits per component, 1 channels
  
  CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to data
                                                  cols,                       // Width of bitmap
                                                  rows,                       // Height of bitmap
                                                  8,                          // Bits per component
                                                  cvMat.step[0],              // Bytes per row
                                                  colorSpace,                 // Colorspace
                                                  kCGImageAlphaNoneSkipLast |
                                                  kCGBitmapByteOrderDefault); // Bitmap info flags
  
  CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
  CGContextRelease(contextRef);
  CGColorSpaceRelease(colorSpace);
  
  return cvMat;
}

+ (UIImage *)UIImageFromCVMat:(cv::Mat)cvMat
{
  NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
  CGColorSpaceRef colorSpace;
  
  if (cvMat.elemSize() == 1) {
    colorSpace = CGColorSpaceCreateDeviceGray();
  } else {
    colorSpace = CGColorSpaceCreateDeviceRGB();
  }
  
  CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
  
  // Creating CGImage from cv::Mat
  CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                      cvMat.rows,                                 //height
                                      8,                                          //bits per component
                                      8 * cvMat.elemSize(),                       //bits per pixel
                                      cvMat.step[0],                            //bytesPerRow
                                      colorSpace,                                 //colorspace
                                      kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                      provider,                                   //CGDataProviderRef
                                      NULL,                                       //decode
                                      false,                                      //should interpolate
                                      kCGRenderingIntentDefault                   //intent
                                      );
  
  
  // Getting UIImage from CGImage
  UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
  CGImageRelease(imageRef);
  CGDataProviderRelease(provider);
  CGColorSpaceRelease(colorSpace);
  
  return finalImage;
}

+ (UIIMage *)EyeDetector:(UIIMage *)image {
  
  cv::Mat src = [self cvMatFromUIImage:image];
  cv::Mat gray = [self cvMatGrayFromUIImage:image];
  
  // TODO: ここに目を変換する処理を追加する
  std::string nested_cascadeName = "iFriday/Data/haarcascades/haarcascade_eye.xml";
  cv::CascadeClassifier nested_cascade;
  if(!nested_cascalde.load(nested_cascadeName)) {
    return image;
  }
  
  std::vector nestedObjects;
  // 目の検出
  // 画像、出力矩形、縮小スケール、最低矩形数、（フラグ）、最小矩形
  nested_cascade.detectMultiScale(gray,
                                  nestedObjects,
                                  1.1,
                                  3,
                                  CV_HAAR_SCALE_IMAGE,
                                  cv::Size(10, 10));
  // 目の位置の表示
  for (std::vector::const_iterator itr = nestedObjects.begin();
       itr != nestedOjbects.end(); ++nr) {
    cv::rectangle(src,
                  cv::Point(itr->x, itr->y),
                  cv::Point(itr->x + itr->width, itr->y + itr->height),
                  cv::Scalar(255, 0, 0),
                  3,
                  4);
  }
  
  UIImage *uiimage = [self UIImageFromCVMat:src];
  
  return uiimage;
}
#endif