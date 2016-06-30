//
//  NewProfileViewController.m
//  Musical Heart
//
//  Created by Stephan Swart on 2014/10/17.
//  Copyright (c) 2014 Gerub. All rights reserved.
//

#import "NewProfileViewController.h"
#import "Person.h"
#import "Tracks.h"

@interface NewProfileViewController ()

@end

@implementation NewProfileViewController

@synthesize txtName;
@synthesize txtContact;
@synthesize txtEmail;

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.txtName) {
        [txtEmail becomeFirstResponder];
    } else if (theTextField == self.txtEmail) {
        [self.txtContact becomeFirstResponder];
    }else if (theTextField == self.txtContact) {
        [self saveData];
    }
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *backgroundimage = [[UIImage imageNamed:@"background.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(300,300,0,300)];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundimage];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)saveData{
    AppDelegate *delegater = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [delegater managedObjectContext];
    
    Person *newPerson;
    newPerson = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:context];
    
    newPerson.personName = txtName.text;
    newPerson.personEmail = txtContact.text;
    newPerson.personContact = txtEmail.text;
    
    txtName.text = @"";
    txtContact.text = @"";
    txtEmail.text = @"";
    
    Tracks *newGenre1;
    newGenre1 = [NSEntityDescription insertNewObjectForEntityForName:@"Tracks" inManagedObjectContext:context];
    
    newGenre1.trackHeartrate = 0;
    newGenre1.trackName = @"Classical";
    newGenre1.trackRecorded = false;
    newGenre1.trackPeople = newPerson;
    
    Tracks *newGenre2;
    newGenre2 = [NSEntityDescription insertNewObjectForEntityForName:@"Tracks" inManagedObjectContext:context];
    
    newGenre2.trackHeartrate = 0;
    newGenre2.trackName = @"Metal";
    newGenre2.trackRecorded = false;
    newGenre2.trackPeople = newPerson;
    
    Tracks *newGenre3;
    newGenre3 = [NSEntityDescription insertNewObjectForEntityForName:@"Tracks" inManagedObjectContext:context];
    
    newGenre3.trackHeartrate = 0;
    newGenre3.trackName = @"Dubstep";
    newGenre3.trackRecorded = false;
    newGenre3.trackPeople = newPerson;
    
    Tracks *newGenre4;
    newGenre4 = [NSEntityDescription insertNewObjectForEntityForName:@"Tracks" inManagedObjectContext:context];
    
    newGenre4.trackHeartrate = 0;
    newGenre4.trackName = @"Pop";
    newGenre4.trackRecorded = false;
    newGenre4.trackPeople = newPerson;
    
    NSSet *trackList = [NSSet setWithObjects:newGenre1, newGenre2, newGenre3, newGenre4, nil];
    newPerson.personTracks = trackList;
    
    NSError *error;
    [context save:&error];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:true completion:nil];
    });

}
- (IBAction)submit:(id)sender {
    [self saveData];
   }

- (IBAction)cancel:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:true completion:nil];
    });
}
@end
