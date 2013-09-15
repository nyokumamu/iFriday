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
    
    _imageView.image = savedImage;
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


@end
