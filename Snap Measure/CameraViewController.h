#import <UIKit/UIKit.h>
#import "CaptureSessionManager.h"

@interface CameraViewController : UIViewController {
    
}

@property (retain) CaptureSessionManager *captureManager;
@property (nonatomic, retain) UILabel *captureLabel;

@end