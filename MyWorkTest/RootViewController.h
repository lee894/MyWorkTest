//
//  RootViewController.h
//  MyWorkTest
//
//  Created by li yang on 12-8-20.
//  Copyright (c) 2012年 li yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController<UINavigationControllerDelegate, 
UIImagePickerControllerDelegate
>


-(NSString *)findUniqueSavePath;

@end
