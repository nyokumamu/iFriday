//
//  IFRSaveImageViewController.m
//  iFriday
//

#import <Social/Social.h>

#import "IFRSaveImageViewController.h"

const NSInteger kIFRTabBarTagFacebook = 100;
const NSInteger kIFRTabBarTagTwitter  = 101;
const NSInteger kIFRTabBarTagSave     = 102;

@interface IFRSaveImageViewController ()
- (BOOL)postWithService:(NSString *)serviceType;
- (BOOL)saveImage;
- (void) savingImageIsFinished:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
@end

@implementation IFRSaveImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  for (int i = 0; i < _tabBar.items.count; i++) {
    UITabBarItem *item = _tabBar.items[i];
    switch (i) {
      case 0:
        item.tag = kIFRTabBarTagFacebook;
        break;
      case 1:
        item.tag = kIFRTabBarTagTwitter;
        break;
      case 2:
        item.tag = kIFRTabBarTagSave;
        break;
    }
  }
}

- (BOOL)postWithService:(NSString *)serviceType
{
  if (_image) {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
      SLComposeViewController *slComposeViewController = [SLComposeViewController composeViewControllerForServiceType:serviceType];
      [slComposeViewController setCompletionHandler:^(SLComposeViewControllerResult result) {
        if (result == SLComposeViewControllerResultDone) {
          // TODO: 画像選択画面に戻る
          SLComposeViewController *composeViewController = [SLComposeViewController composeViewControllerForServiceType:serviceType];
          [composeViewController setInitialText:@"#iFriday"];
          [composeViewController addImage:_image];
          [self presentViewController:composeViewController animated:YES completion:nil];
        } else {
          NSString *message = @"投稿に失敗しました";
          if (serviceType == SLServiceTypeFacebook) {
            message = @"Facebookへの投稿に失敗しました";
          } else if (serviceType == SLServiceTypeTwitter) {
            message = @"Twitterへの投稿に失敗しました";
          }
          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"投稿失敗"
                                                          message:message
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
          [alert show];
        }
      }];
      return YES;
    }
  }
  return NO;
}

- (BOOL)saveImage
{
  if (_image != nil) {
    NSData *data = UIImagePNGRepresentation(_image);
    UIImage *png = [UIImage imageWithData:data];
    UIImageWriteToSavedPhotosAlbum(png, self, @selector(savingImageIsFinished:didFinishSavingWithError:contextInfo:), nil);
    return YES;
  }
  return NO;
}

- (void) savingImageIsFinished:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
  if (error) {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"" message:@"保存に失敗しました" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
  } else {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"" message:@"保存しました" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
  }
}

#pragma mark - UITabBar delegate 

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
  switch (item.tag) {
    case kIFRTabBarTagFacebook:
      [self postWithService:SLServiceTypeFacebook];
      break;
    case kIFRTabBarTagTwitter:
      [self postWithService:SLServiceTypeTwitter];
      break;
    case kIFRTabBarTagSave:
      [self saveImage];
      break;
  }
}

@end
