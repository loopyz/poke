//
//  PokesViewController.m
//  Poke
//
//  Created by Lucy Guo on 6/19/14.
//  Copyright (c) 2014 Poke. All rights reserved.
//

#import "PokesViewController.h"
#import <Parse/Parse.h>
@interface PokesViewController ()
{
  NSMutableArray *_pokes;
}
@end

@implementation PokesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      PFUser *user = [PFUser currentUser];
      _pokes = user[@"pokes"];
    }
    return self;
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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [_pokes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *cellIdentifier = @"pokeItem";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
  }
  
  NSDictionary *dict = [_pokes objectAtIndex:indexPath.row];
  for(NSString *key in [dict allKeys]) {
    NSLog(@"%@",[dict objectForKey:key]);
  }
  
  
  return cell;
}

#pragma mark - UITableViewDelegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
}

@end
