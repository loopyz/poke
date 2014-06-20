//
//  HomeViewController.m
//  Poke
//
//  Created by Lucy Guo on 6/19/14.
//  Copyright (c) 2014 Poke. All rights reserved.
//

#import "HomeViewController.h"
#import "NearbyFriendsViewController.h"
#import "PokesViewController.h"

#define SCREEN_WIDTH ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height)
#define SCREEN_HEIGHT ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)


@interface HomeViewController ()

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
      self.bgColor = [UIColor colorWithRed:251/255.0f green:251/255.0f blue:251/255.0f alpha:1.0f];
      
      // Custom initialization
      [self changeBG];
      [self initNavBar];
      
      //tab bars
      
      
      //SecondViewController
      NearbyFriendsViewController *svc=[[NearbyFriendsViewController alloc]initWithNibName:nil bundle:nil];
      svc.title=@"";
      svc.tabBarItem.image=[UIImage imageNamed:@"contacts.png"];
      
      //ThirdViewController
      PokesViewController *tvc=[[PokesViewController alloc]initWithNibName:nil bundle:nil];
      tvc.title=@"";
      tvc.tabBarItem.image=[UIImage imageNamed:@"facebooktab.png"];
      
      self.viewControllers=[NSArray arrayWithObjects:svc, tvc, nil];
    }
    return self;
}

- (void)initNavBar
{
  //set back button color
  [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor,nil] forState:UIControlStateNormal];
  //set back button arrow color
  [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
  
}

- (void)assignTabColors
{
  switch (self.selectedIndex) {
    case 0: {
      UIColor * color = [UIColor colorWithRed:41/255.0f green:178/255.0f blue:177/255.0f alpha:1.0f];
      self.view.tintColor = color;
      break;
    }
      
    default:
      break;
  }
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
  [self assignTabColors];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self assignTabColors];
}

- (void)changeBG
{
  self.view.backgroundColor = self.bgColor;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
