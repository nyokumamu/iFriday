//
//  IFRViewController.m
//  iFriday
//
//  Created by Yosuke Hiraoka on 13/09/14.
//  Copyright (c) 2013年 Yosuke Hiraoka, Tanjo Yuki. All rights reserved.
//

#import "IFRViewController.h"

@interface IFRViewController ()

@end

@implementation IFRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//  フォトライブラリを開く
- (IBAction)openPhotoLibrary:(id)sender {
    /*
     フォトライブラリが使えるかチェック
     カメラを開く場合
     UIImagePickerControllerSourceTypePhotoLibrary  を
     UIImagePickerControllerSourceTypeCamera        に変更
    */
    if( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] )
    {
        // UIImagePickerControllerを作成し初期化 new = alloc + init;
        UIImagePickerController* imagePicker = [ UIImagePickerController new ];
        
        // カメラを開く場合　sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        // 編集可能にする場合はYES
        imagePicker.allowsEditing = YES;
        
        // 自分への通知設定
        imagePicker.delegate = self;
        
        // フォトライブラリを開く
        [self presentViewController:imagePicker animated:YES completion:^{
            // 開いたタイミングで呼ばれる
            NSLog(@"(1)フォトライブラリが開いた");
        }];
    }
}

// 写真撮影後orサムネイル選択後に呼ばれる処理
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* originalImage = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage* editedImage   = (UIImage *)[info objectForKey:UIImagePickerControllerEditedImage];
    
    UIImage* savedImage;
    if (editedImage) {
        savedImage = editedImage;
    } else {
        savedImage = originalImage;
    }
  
  NSLog(@"1");
#ifdef __cplusplus
  NSLog(@"2");
  savedImage = [self EyeDetector:savedImage];
    NSLog(@"3");
#endif
  NSLog(@"4");
  
    _imageView.image = savedImage;
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

// UIImage -> cv::Mat
#ifdef __cplusplus
- (cv::Mat)cvMatFromUIImage:(UIImage *)image
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

- (UIImage *)UIImageFromCVMat:(cv::Mat)cvMat
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

- (UIImage *)EyeDetector:(UIImage *)image {
  
  cv::Mat src = [self cvMatFromUIImage:image];
  cv::Mat gray;
  cv::cvtColor(src, gray, CV_BGR2GRAY);
  // TODO: ここに目を変換する処理を追加する
  NSString* resDir = [[NSBundle mainBundle] resourcePath];
  const char *cascade_name = "haarcascade_eye.xml";
  char cascade_path[PATH_MAX];
  sprintf(cascade_path, "%s/%s", [resDir cStringUsingEncoding:NSASCIIStringEncoding], cascade_name );
  cv::CascadeClassifier nested_cascade;
  if(!nested_cascade.load(cascade_path)) {
    return image;
  }
  
  std::vector<cv::Rect> nestedObjects;
  // 目の検出
  // 画像、出力矩形、縮小スケール、最低矩形数、（フラグ）、最小矩形
  nested_cascade.detectMultiScale(src,
                                  nestedObjects,
                                  1.1,
                                  3,
                                  CV_HAAR_SCALE_IMAGE,
                                  cv::Size(10, 10));
  // 目の位置の表示
  for (std::vector<cv::Rect>::const_iterator itr = nestedObjects.begin();
       itr != nestedObjects.end(); ++itr) {
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

@end
