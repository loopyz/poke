//
//  NearbyFriendsViewController.h
//  Poke
//
//  Created by Lucy Guo on 6/19/14.
//  Copyright (c) 2014 Poke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NearbyFriendsViewController : UITableViewController

@property (strong, nonatomic, readwrite) NSMutableArray *friendsInFB;
@property (strong, nonatomic, readwrite) NSMutableArray *profilePicIds;
@property (strong, nonatomic) UIColor *bgColor;

@end
