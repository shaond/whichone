//
//  PhotoController.m
//  likedislike
//
//  Created by Herbert Yeung on 15/09/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PhotoController.h"
#import <QuartzCore/QuartzCore.h>

@implementation PhotoController

- (void) cameraButtonPressed
{
    //Try to get the delete from sender
    
	// Create image picker controller
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init] ;
    
    // Set source to the camera
	imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
    
    // Delegate is self
	imagePicker.delegate = self;
    
    // Set properties for the camera (No editing and Auto-Flash)
	imagePicker.allowsEditing = NO;
    imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
    
    //imagePicker.showsCameraControls = NO; //This is to remove all camera controls to use one's own
    
    // Display the textfield to enter in values
    UIView *descView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)]; 
    descView.layer.cornerRadius = 10;
    descView.clipsToBounds = YES;
    descView.backgroundColor = [UIColor clearColor];
    [descView setAlpha:1.0]; 
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(30, 360, 250, 50)];
    [textField setBackgroundColor:[UIColor whiteColor]];
    [textField setText:@"   Enter short description "];
    [textField setBorderStyle:UITextBorderStyleRoundedRect];
    [textField setAlpha:0.6];
    [textField setClearsOnBeginEditing:YES];
    [textField setReturnKeyType:UIReturnKeyDone];
    [textField addTarget:self action:@selector(textFieldFinished) forControlEvents:UIControlEventEditingDidEndOnExit];
    //[textField addTarget:self action:@selector(textFieldEdit) forControlEvents:UIControlEventEditingDidBegin];
    
    [descView addSubview:textField];
    imagePicker.cameraOverlayView = descView;
    
    // Show image picker
	[self presentModalViewController:imagePicker animated:YES];	
    [imagePicker release];
    
    /*[NSTimer scheduledTimerWithTimeInterval:0.1
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:descView
                                    repeats:YES];*/
    [descView release];
}

- (void) textFieldFinished 
{
    [self resignFirstResponder]; 
}

- (void)timerFireMethod:(NSTimer*)theTimer {
    UIView *cameraOverlayView = (UIView *)theTimer.userInfo;
    UIView *previewView = cameraOverlayView.superview.superview;
    
    if (previewView != nil) {
        [cameraOverlayView removeFromSuperview];
        [previewView insertSubview:cameraOverlayView atIndex:1];
        
        cameraOverlayView.hidden = NO;
        
        [theTimer invalidate];
    }
}

- (void) alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex
{
	// After saving iamge, dismiss camera
	[self dismissModalViewControllerAnimated:YES];
}

// This is from http://stackoverflow.com/questions/1282830/uiimagepickercontroller-uiimage-memory-and-more
- (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToSizeWithSameAspectRatio:(CGSize)targetSize;
{  
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor) {
            scaleFactor = widthFactor; // scale to fit height
        }
        else {
            scaleFactor = heightFactor; // scale to fit width
        }
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5; 
        }
        else if (widthFactor < heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }     
    
    CGImageRef imageRef = [sourceImage CGImage];
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
    
    if (bitmapInfo == kCGImageAlphaNone) {
        bitmapInfo = kCGImageAlphaNoneSkipLast;
    }
    
    CGContextRef bitmap;
    
    if (sourceImage.imageOrientation == UIImageOrientationUp || sourceImage.imageOrientation == UIImageOrientationDown) {
        bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        
    } else {
        bitmap = CGBitmapContextCreate(NULL, targetHeight, targetWidth, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        
    }   
    
    // In the right or left cases, we need to switch scaledWidth and scaledHeight,
    // and also the thumbnail point
    if (sourceImage.imageOrientation == UIImageOrientationLeft) {
        thumbnailPoint = CGPointMake(thumbnailPoint.y, thumbnailPoint.x);
        CGFloat oldScaledWidth = scaledWidth;
        scaledWidth = scaledHeight;
        scaledHeight = oldScaledWidth;
        
        CGContextRotateCTM (bitmap, (90 * M_PI / 180.0));
        CGContextTranslateCTM (bitmap, 0, -targetHeight);
        
    } else if (sourceImage.imageOrientation == UIImageOrientationRight) {
        thumbnailPoint = CGPointMake(thumbnailPoint.y, thumbnailPoint.x);
        CGFloat oldScaledWidth = scaledWidth;
        scaledWidth = scaledHeight;
        scaledHeight = oldScaledWidth;
        
        CGContextRotateCTM (bitmap, (-90 * M_PI / 180.0));
        CGContextTranslateCTM (bitmap, -targetWidth, 0);
        
    } else if (sourceImage.imageOrientation == UIImageOrientationUp) {
        // NOTHING
    } else if (sourceImage.imageOrientation == UIImageOrientationDown) {
        CGContextTranslateCTM (bitmap, targetWidth, targetHeight);
        CGContextRotateCTM (bitmap, (-180 * M_PI / 180.0));
    }
    
    CGContextDrawImage(bitmap, CGRectMake(thumbnailPoint.x, thumbnailPoint.y, scaledWidth, scaledHeight), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage* newImage = [UIImage imageWithCGImage:ref];
    
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return newImage; 
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    UIAlertView *alert;
    
	// Unable to save the image  
    if (error)
    {
        alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                           message:@"Unable to save image to Photo Album." 
                                          delegate:self cancelButtonTitle:@"Ok" 
                                 otherButtonTitles:nil];
    }
	else
    {
        // Ask user if they want a 2nd photo. 
        alert = [[UIAlertView alloc] initWithTitle:@"Success" 
                                           message:@"Image saved to Photo Album." 
                                          delegate:self cancelButtonTitle:@"Ok" 
                                 otherButtonTitles:nil];
    }
    
    
    [alert show];
    [alert release];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	// Access the uncropped image from info dictionary
	UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    // Scale the image and save this in the aspect ratio we want
    image = [self imageWithImage:image scaledToSizeWithSameAspectRatio:CGSizeMake(612, 612)];
    
	// Save image
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
	[picker release];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.        
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [self cameraButtonPressed];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
