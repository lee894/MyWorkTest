//
//  RootViewController.m
//  MyWorkTest
//
//  Created by li yang on 12-8-20.
//  Copyright (c) 2012年 li yang. All rights reserved.
//

#import "RootViewController.h"

#define  SETIMAGE(X) [(UIImageView *)self.view setImage:X];

@interface RootViewController ()

@end

void centerText (CGContextRef context, NSString *fonrname, float textsize, NSString *text, 
                 CGPoint point, UIColor *color)
{
    CGContextSaveGState(context);
    CGContextSelectFont(context, [fonrname UTF8String], 24.0, kCGEncodingMacRoman);
    CGContextSaveGState(context);
    CGContextSetTextDrawingMode(context, kCGTextInvisible);
    CGContextShowGlyphsAtPoint(context, 0.0f, 0.0f, [text UTF8String], text.length);
    CGPoint endpoint = CGContextGetTextPosition(context);
//    CFShow(NSStringFromCGPoint(endpoint));
    CGContextRestoreGState(context);
    
    CGSize stringSize = [text sizeWithFont:[UIFont fontWithName:fonrname size:textsize]];
    
    //draw the text
    CGContextSetShouldAntialias(context, true);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextSetTextMatrix(context, CGAffineTransformMake(1, 0, 0, -1, 0, 0));
    CGContextShowGlyphsAtPoint(context, point.x-endpoint.x/2., point.y+stringSize.height/3., 
                               [text UTF8String], text.length);
    CGContextRestoreGState(context);
    
}


@implementation RootViewController

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
    
    self.title = @"测试用例";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"图片" style:UIBarButtonItemStylePlain target:self action:@selector(touchDown:)];
}

-(void)touchDown:(id)sender{
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
        ipc.delegate = self;
        ipc.allowsEditing = NO;
        ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
        ipc.showsCameraControls = NO;       //??
    [self presentModalViewController:ipc animated:YES];
        
        [NSTimer scheduledTimerWithTimeInterval:1.0f target:ipc selector:@selector(takePicture) 
                                       userInfo:nil repeats:NO];
    }
    else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"show" message:@"无照相功能"
                                                        delegate:nil cancelButtonTitle:@"取消"
                                              otherButtonTitles:nil];
    [alert show];
    }

}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissModalViewControllerAnimated:YES];
}

//3.x
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
//    SETIMAGE([info objectForKey:@"UIImagePickerControllerOriginalImage"]);
    
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    [self dismissModalViewControllerAnimated:YES];
    
    //write to file   
    [UIImageJPEGRepresentation(image, 1.0f) writeToFile:[self findUniqueSavePath] atomically:YES];
    
    UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
//    [UIImageJPEGRepresentation(image, 1.0f) writeToFile:[self findUniqueSavePath] atomically:YES];
    
}

//get image path
-(NSString *)findUniqueSavePath{
    int i = 1;
    NSString *path;

    do {   
        path = [NSString stringWithFormat:@"%@/Doucoments/IMAGE_%04d.PNG",NSHomeDirectory(),i++];
        NSLog(@"地址：%@",path);
        
    } while ([[NSFileManager defaultManager] fileExistsAtPath:path]);
    
    return path;
}

-(UIImage *)createImageWithColor:(UIColor *)color{

    
    
    
    return nil;
}



//-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfoP
//{
//}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
