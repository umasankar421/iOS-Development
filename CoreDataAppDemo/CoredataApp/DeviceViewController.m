//
//  DeviceViewController.m
//  CoredataApp
//
//  Created by ankit on 10/12/16.
//  Copyright © 2016 anyone. All rights reserved.
//

#import "DeviceViewController.h"
#import "AppDelegate.h"
#import "DeviceDetailViewController.h"
@interface DeviceViewController ()

@property (strong) NSMutableArray *devices;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailTextLabel;

@end

@implementation DeviceViewController
@synthesize myTableView;
- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor redColor]] ;
    [self.navigationItem setTitle:@"CoreData"];
    [self.navigationItem setLeftBarButtonItem:self.editButtonItem];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    

}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Fetch the devices from persistent data store
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Device"];
    self.devices = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return self.devices.count;
    //return 0;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 static NSString *CellIdentifier = @"Cell";
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
 
 // Configure the cell...
 NSManagedObject *device = [self.devices objectAtIndex:indexPath.row];
 [cell.textLabel setText:[NSString stringWithFormat:@"%@ %@", [device valueForKey:@"name"], [device valueForKey:@"version"]]];
 [cell.detailTextLabel setText:[device valueForKey:@"company"]];
    NSLog(@"textLabel=%@",cell.textLabel);
    NSLog(@"detailTextLabel=%@",cell.detailTextLabel);
 return cell;

}

///========this code to get whic cell tapped============//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableView *Mycell = (UITableView *)[tableView cellForRowAtIndexPath:indexPath]; // SimpletableCell is your cell you can add your cell here like UITableViewCell..
    //self.lbl1.text = Mycell.textLabel.text;// cell.lbl3 is a label of cell.
   // self.lbl2.text = cell.detailTextLabel.text;// here only two labels values get you can get other labels also
    //......
    //....
    //NSLog(@"Seelected=%@",Mycell.txtLabel.text);
    UILabel *lblValue = (UILabel *)[Mycell viewWithTag:_textLabel];
    
    UILabel *lblValue1=(UILabel *)[Mycell viewWithTag:_detailTextLabel];
    
    NSLog(@"Your Label value:%@",lblValue.text);
   // NSLog(@"Your Label Value:%d",lblValue1.text);
}
//=======================================================

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete object from database
        [context deleteObject:[self.devices objectAtIndex:indexPath.row]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
            return;
        }
        
        // Remove device from table view
        [self.devices removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"UpdateSegue"]) {
        NSManagedObject *selectedDevice = [self.devices objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
        DeviceDetailViewController *destViewController = segue.destinationViewController;
        destViewController.device = selectedDevice;
    }
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
