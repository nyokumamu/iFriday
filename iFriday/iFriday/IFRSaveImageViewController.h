//
//  IFRSaveImageViewController.h
//  iFriday
//

#import <UIKit/UIKit.h>

@interface IFRSaveImageViewController : UIViewController <UITabBarDelegate>
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (strong, nonatomic) UIImage *image;
@end
