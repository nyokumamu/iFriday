//
//  IFRViewController.h
//  iFriday
//
//  Created by Yosuke Hiraoka on 13/09/14.
//  Copyright (c) 2013年 Yosuke Hiraoka, Tanjo Yuki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IFRViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property IBOutlet UIImageView* imageView;
@end
