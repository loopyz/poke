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
  
  //add name label?
  UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(85, 70/2 - 15, 400, 30)];
  name.text = [NSString stringWithFormat:@"%@ %@", [tempPerson first_name], [tempPerson last_name]];
  name.font = [UIFont fontWithName:@"Avenir-Light" size:24.0];
  name.textColor = [UIColor colorWithRed:140/255.0f green:140/255.0f blue:140/255.0f alpha:1.0f];
  [cell addSubview:name];
  
  return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  //TODO: MAKE IT SEND A POKE
  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  NSString *player = cell.textLabel.text;
  // sends the person a poke. (for now, the table has all fb friends on the app(even ones that you added to your in-app list of friends that you play with)).
  FBGraphObject<FBGraphUser> *tempPerson = self.friendsInFB[indexPath.row];
  PFQuery *userQuery = [PFUser query];
  [userQuery whereKey:@"fbId" equalTo:tempPerson[@"id"]];
  [userQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
    if (object && !error) {
      PFUser *toUser = (PFUser *) object;
      PFUser *fromUser = [PFUser currentUser];
      NSMutableArray *toPokes = toUser[@"pokes"];
      if (!toPokes) {
        toPokes = [[NSMutableArray alloc] init];
      }
      NSMutableDictionary *dict = [NSMutableDictionary dictionary];
      [dict setObject:[tempPerson first_name] forKey:@"first_name"];
      [dict setObject:[tempPerson last_name] forKey:@"last_name"];
      
//      [toPokes addObject:fromUser];
      [toUser setObject:toPokes forKey:@"pokes"];
    }
  }];
  NSLog(@"accepted player %@", player);

}
@end

