//
//  PublicTransportViewController.m
//  CampusInfo1
//
//  Created by Ilka Kokemor on 14.08.13.
//
//

#import "PublicTransportViewController.h"

@interface PublicTransportViewController ()
@end

@implementation PublicTransportViewController

@synthesize _publicTransportNavigationBar;
@synthesize _publicTransportNavigationItem;
@synthesize _publicTransportNavigationLabel;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}


- (void) moveBackToMenuOverview:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
    self.tabBarController.selectedIndex = 0;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIColor *_backgroundColor = [UIColor colorWithRed:1.0/255.0 green:100.0/255.0 blue:167.0/255.0 alpha:1.0];
    

    UIButton *backButton = [UIButton buttonWithType:101];
    UIView *backButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, backButton.frame.size.width, backButton.frame.size.height)];
    
    [backButton addTarget:self action:@selector(moveBackToMenuOverview:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:@"zurück" forState:UIControlStateNormal];
    [backButtonView addSubview:backButton];
    
    // set buttonview as custom view for bar button item
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButtonView];
    [_publicTransportNavigationItem setLeftBarButtonItem :backButtonItem animated :true];
    
    [_publicTransportNavigationLabel setTextColor:[UIColor whiteColor]];
    _publicTransportNavigationLabel.text = @"ÖV-Fahrplan";
    _publicTransportNavigationItem.title = @"";
    
    CGRect imageRect = CGRectMake(0, 0, _publicTransportNavigationBar.frame.size.width, _publicTransportNavigationBar.frame.size.height);
    UIGraphicsBeginImageContext(imageRect.size);
    [_backgroundColor set];
    UIRectFill(imageRect);
    UIImage *aImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [_publicTransportNavigationBar setBackgroundImage:aImage forBarMetrics:UIBarMetricsDefault];
    
    [_publicTransportNavigationLabel setBackgroundColor:_backgroundColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload
{
    _publicTransportNavigationBar = nil;
    _publicTransportNavigationItem = nil;
    _publicTransportNavigationLabel = nil;
    [super viewDidUnload];
}
@end
