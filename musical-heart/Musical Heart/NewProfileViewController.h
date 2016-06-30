//
//  NewProfileViewController.h
//  Musical Heart
//
//  Created by Stephan Swart on 2014/10/17.
//  Copyright (c) 2014 Gerub. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface NewProfileViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtContact;
- (IBAction)submit:(id)sender;
- (IBAction)cancel:(id)sender;

@end
