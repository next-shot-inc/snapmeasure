#import "CameraViewController.h"

@interface CameraViewController ()
 -(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
@end

@implementation CameraViewController

@synthesize captureManager;
@synthesize captureLabel;

- (void)viewDidLoad {
    
    [self setCaptureManager:[[[CaptureSessionManager alloc] init] autorelease]];
    
    [[self captureManager] addVideoInput];
    [[self captureManager] addStillImageOutput];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveImageToPhotoAlbum) name:kImageCapturedSuccessfully object:nil];
    
    [[self captureManager] addVideoPreviewLayer];
    CGRect layerRect = [[[self view] layer] bounds];
    [[[self captureManager] previewLayer] setBounds:layerRect];
    [[[self captureManager] previewLayer] setPosition:CGPointMake(CGRectGetMidX(layerRect),
                                                                  CGRectGetMidY(layerRect))];
    [[[self view] layer] addSublayer:[[self captureManager] previewLayer]];
    
    /** un used graphic
    UIImageView *overlayImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overlaygraphic.png"]];
    [overlayImageView setFrame:CGRectMake(30, 100, 260, 200)];
    [[self view] addSubview:overlayImageView];
    [overlayImageView release];
     **/
    
    UIButton *overlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [overlayButton setImage:[UIImage imageNamed:@"scanbutton.png"] forState:UIControlStateNormal];
    //calculate button position
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    double xPos = (screenRect.size.width/2)-30;
    double yPos = screenRect.size.height-(screenRect.size.height/20);
    [overlayButton setFrame:CGRectMake(xPos, yPos, 60, 30)];
    [overlayButton addTarget:self action:@selector(scanButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:overlayButton];
    
    /** not used
    UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 50, 120, 30)];
    [self setScanningLabel:tempLabel];
    [tempLabel release];
    [scanningLabel setBackgroundColor:[UIColor clearColor]];
    [scanningLabel setFont:[UIFont fontWithName:@"Courier" size: 18.0]];
    [scanningLabel setTextColor:[UIColor redColor]];
    [scanningLabel setText:@"Scanning..."];
    [scanningLabel setHidden:YES];
    [[self view] addSubview:scanningLabel];
     **/
    
    [[captureManager captureSession] startRunning];
}


- (void) scanButtonPressed {
    [[self captureLabel] setHidden:NO];
    [[self captureManager] captureStillImage];
}

- (void)hideLabel:(UILabel *)label {
    [label setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)saveImageToPhotoAlbum
{
    UIImageWriteToSavedPhotosAlbum([[self captureManager] stillImage], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error != NULL) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Image couldn't be saved" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else {
        [[self captureLabel] setHidden:YES];
    }
}

- (void)dealloc {
    [captureManager release], captureManager = nil;
    [captureLabel release], captureLabel = nil;
    [super dealloc];
}

@end

