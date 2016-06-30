//
//  ProfileTableViewController.m
//  Musical Heart
//
//  Created by Stephan Swart on 2014/10/17.
//  Copyright (c) 2014 Gerub. All rights reserved.
//

#import "ProfileTableViewController.h"
#import "Tracks.h"
#import "PlayerViewController.h"

@interface ProfileTableViewController ()
{
    NSArray *trackList;
}

@end

@implementation ProfileTableViewController

@synthesize person;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *backgroundimage = [[UIImage imageNamed:@"background.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(300,300,0,300)];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundimage];
    trackList = [person.personTracks allObjects];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewDidAppear:(BOOL)animated
{
    trackList = [person.personTracks allObjects];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return trackList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Tracks *track = (Tracks *)[trackList objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = nil;
    
    if ([track.trackRecorded boolValue] == TRUE) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"recordedCell" forIndexPath:indexPath];
        
        UILabel *textLabel = (UILabel *)[cell.contentView viewWithTag:1];
        textLabel.text = track.trackName;
        UILabel *heartbeatCount = (UILabel *)[cell.contentView viewWithTag:3];
        heartbeatCount.text = [NSString stringWithFormat:@"%@", track.trackHeartrate ];
        
    }
    else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"notRecordedCell" forIndexPath:indexPath];
        cell.textLabel.text = (track).trackName;
    }
    [cell.textLabel.text uppercaseString];
    [cell.textLabel setBackgroundColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.0]];
    
    
    
    [cell.textLabel setTextColor:[UIColor colorWithRed:156.0 green:153.0 blue:139.0 alpha:0.5]];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellBackground.png"]];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellBackground.png"]];
    
    
    return cell;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


 #pragma mark - Navigation
 
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    PlayerViewController *destinationController = [segue destinationViewController];
    destinationController.track = [trackList objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    
}
 

@end
