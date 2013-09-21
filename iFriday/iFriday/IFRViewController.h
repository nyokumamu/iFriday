//
//  IFRViewController.h
//  iFriday
//
//  Created by Yosuke Hiraoka on 13/09/14.
//  Copyright (c) 2013年 Yosuke Hiraoka, Tanjo Yuki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IFRViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
  UIImage *saveImage;
}

@property IBOutlet UIImageView* imageView;
@property IBOutlet UIBarButtonItem *importButton;
@property IBOutlet UIBarButtonItem *saveButton;

@end
