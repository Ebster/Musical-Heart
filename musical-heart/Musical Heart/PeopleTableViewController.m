//
//  PeopleTableViewController.m
//  Musical Heart
//
//  Created by Stephan Swart on 2014/10/17.
//  Copyright (c) 2014 Gerub. All rights reserved.
//

#import "PeopleTableViewController.h"
#import "ProfileTableViewController.h"
#import "Person.h"

@interface PeopleTableViewController ()
{
    NSArray *peopleList;
    
}

@end

@implementation PeopleTableViewController

@synthesize tvPeople;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //peopleList = [self getPersons];
    UIImage *backgroundimage = [[UIImage imageNamed:@"background.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(300,300,0,300)];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundimage];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewDidAppear:(BOOL)animated
{
    peopleList = [self getPersons];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Core Data loading

- (NSArray *)getPersons
{
    AppDelegate *appDelegate =
    [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context =
    [appDelegate managedObjectContext];
    
    NSEntityDescription *entityDesc =
    [NSEntityDescription entityForName:@"Person"
                inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    /*NSPredicate *pred =
    [NSPredicate predicateWithFormat:@"(personName = %@)",
     _name.text];
    [request setPredicate:pred];
     */
    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request
                                              error:&error];
    
    
        /*UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Hello" message: [NSString stringWithFormat:@"%li", (long)objects.count] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];*/
    
    return objects;

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return peopleList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"personCell" forIndexPath:indexPath];
    
    NSString *personNameUpper = [(NSManagedObject *)[peopleList objectAtIndex:indexPath.row] valueForKey:@"personName"];
    cell.textLabel.text = [personNameUpper uppercaseString];
    
    [cell.textLabel.text uppercaseString];
    [cell.textLabel setBackgroundColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.0]];
    
    [cell.textLabel setTextColor:[UIColor colorWithRed:156.0 green:153.0 blue:139.0 alpha:0.5]];
 
    
    cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"cellBackground.png"]stretchableImageWithLeftCapWidth:100.0 topCapHeight:20.0]];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"cellBackground.png"]stretchableImageWithLeftCapWidth:100.0 topCapHeight:20.0]];
    
   
    

    
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSString *name = [(NSManagedObject *)[peopleList objectAtIndex:indexPath.row] valueForKey:@"personName"];
    NSString *email = [(NSManagedObject *)[peopleList objectAtIndex:indexPath.row] valueForKey:@"personEmail"];
    NSString *contact = [(NSManagedObject *)[peopleList objectAtIndex:indexPath.row] valueForKey:@"personContact"];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:name message:[NSString stringWithFormat:@"%@\n%@",email,contact] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
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
    if ([segue.identifier isEqualToString:@"profileSegue"]) {
        ProfileTableViewController *destinationController = [segue destinationViewController];
        destinationController.person = [peopleList objectAtIndex:tvPeople.indexPathForSelectedRow.row];
    }
    
    
    // Pass the selected object to the new view controller.
}


@end
