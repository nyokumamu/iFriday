//
//  IFRSaveImageViewController.m
//  iFriday
//

#import <Social/Social.h>

#import "IFRViewController.h"
#import "IFRSaveImageViewController.h"

const NSInteger kIFRTabBarTagFacebook = 100;
const NSInteger kIFRTabBarTagTwitter  = 101;
const NSInteger kIFRTabBarTagSave     = 102;

@interface IFRSaveImageViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)postFacebook:(id)sender;
- (IBAction)postTwitter:(id)sender;
- (IBAction)saveImage:(id)sender;
- (BOOL)postWithService:(NSString *)serviceType;
- (BOOL)saveImage;
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
  if (_image) {
    [_imageView setContentMode:UIViewContentModeCenter];
    _imageView.image = _image;
  } else {
    IFRViewController *viewController = [[IFRViewController alloc] init];
    [self.view addSubview:viewController.self.view];
  }
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

- (IBAction)postFacebook:(id)sender {
  [self saveImage];
  [self postWithService:SLServiceTypeFacebook];
}

- (IBAction)postTwitter:(id)sender {
  [self saveImage];
  [self postWithService:SLServiceTypeTwitter];
}

- (IBAction)saveImage:(id)sender {
  [self saveImage];
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
    NSLog(@"OK");
    NSData *data = UIImagePNGRepresentation(_image);
    UIImage *png = [UIImage imageWithData:data];
    UIImageWriteToSavedPhotosAlbum(png, self, @selector(savingImageIsFinished:didFinishSavingWithError:contextInfo:), nil);
    return YES;
  }
  return NO;
}

- (void) savingImageIsFinished:(UIImage *)_image didFinishSavingWithError:(NSError *)_error contextInfo:(void *)_contextInfo {
  if (_error) {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"" message:@"Error" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
  } else {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"" message:@"Save" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
  }
}

@end
