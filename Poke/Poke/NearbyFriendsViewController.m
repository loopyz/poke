//
//  NearbyFriendsViewController.m
//  Poke
//
//  Created by Lucy Guo on 6/19/14.
//  Copyright (c) 2014 Poke. All rights reserved.
//

#import "NearbyFriendsViewController.h"
#import <Parse/Parse.h>

@interface NearbyFriendsViewController ()

@end

@implementation NearbyFriendsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
      [self getFriendsInFB];
    }
    return self;
}

//finds friends in your contacts list
- (void)getFriendsInFB
{
  FBRequest *request = [FBRequest requestForMyFriends];
  [request startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary *result, NSError *error) {
    if (!error) {
      NSArray *data = [result objectForKey:@"data"];
      self.friendsInFB = data;
      
      [self.tableView reloadData];
    }
  }];
  
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
  // Return the number of sections.
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
  // Return the number of rows in the section.
  return [self.friendsInFB count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 70;
}


//for each cell in table
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *MyIdentifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
  }
  FBGraphObject<FBGraphUser> *tempPerson = self.friendsInFB[indexPath.row];
  cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [tempPerson first_name], [tempPerson last_name]];
  cell.textLabel.frame = CGRectMake(75, 70/2, 400, 20);
  //cell.backgroundColor = [UIColor clearColor];
  cell.backgroundColor = self.bgColor;
  
  // add profile pic
  FBProfilePictureView *fbProfilePic = [[FBProfilePictureView alloc] init];
  
  fbProfilePic.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"profile.png"]];
  fbProfilePic.frame = CGRectMake(17, 7, 53, 53);
  
  //makes it into circle
  float width = fbProfilePic.bounds.size.width;
  fbProfilePic.layer.cornerRadius = width/2;
  fbProfilePic.profileID = tempPerson.objectID;
  NSLog(@"%@", fbProfilePic.profileID);
  [cell addSubview:fbProfilePic];
  
  return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  //TODO: MAKE IT SEND A POKE
  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  NSString *player = cell.textLabel.text;
  if (cell.accessoryType == UITableViewCellAccessoryNone) {
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    // sends the person a request. (for now, the table has all fb friends on the app(even ones that you added to your in-app list of friends that you play with)).
    FBGraphObject<FBGraphUser> *tempPerson = self.friendsInFB[indexPath.row];
    PFQuery *userQuery = [PFUser query];
    [userQuery whereKey:@"fbId" equalTo:tempPerson[@"id"]];
    [userQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
      if (object && !error) {
        PFUser *otherUser = (PFUser *) object;
        PFUser *thisUser = [PFUser currentUser];
        NSMutableArray *otherRequests = otherUser[@"requests"];
        if (!otherRequests) {
          otherRequests = [[NSMutableArray alloc] init];
        }
        [otherRequests addObject:thisUser];
        
        NSMutableArray *thisRequested = [thisUser objectForKey:@"requested"];
        if (!thisRequested) {
          thisRequested = [[NSMutableArray alloc] init];
        }
        [thisRequested addObject:otherUser];
        
        [otherUser setObject:otherRequests forKey:@"requests"];
        [thisUser setObject:thisRequested forKey:@"requested"];
        
        //[otherUser saveInBackground];
        //[thisUser saveInBackground];
      }
    }];
    NSLog(@"accepted player %@", player);
  } else {
    // deselected
    cell.accessoryType = UITableViewCellAccessoryNone;
    
  }
}
@end

