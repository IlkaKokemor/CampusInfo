//
//  ChooseDateViewController.m
//  CampusInfo1
//
//  Created by Ilka Kokemor on 13.05.13.
//
//

#import "ChooseDateViewController.h"

@interface ChooseDateViewController ()

@end

@implementation ChooseDateViewController

@synthesize _datePicker;
@synthesize _chooseDateNavigationItem;
@synthesize _chooseDateViewDelegate;
@synthesize _navigatorTitle;
@synthesize _todayButton;
@synthesize _actualDate;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void) backToTimeTableOverview:(id)sender
{
    if([self._chooseDateViewDelegate respondsToSelector:@selector(setActualDate:)])
    {
        [self._chooseDateViewDelegate setActualDate:_datePicker.date];
        [self dismissModalViewControllerAnimated:YES];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage         *_leftButtonImage = [UIImage imageNamed:@"arrowLeft_small.png"];
    UIBarButtonItem *_leftButton      = [[UIBarButtonItem alloc] initWithImage: _leftButtonImage
                                                                         style:UIBarButtonItemStylePlain
                                                                        target:self
                                                                        action:@selector(backToTimeTableOverview:)];
    
    [_chooseDateNavigationItem setLeftBarButtonItem :_leftButton animated :true];
    
    [self.view bringSubviewToFront:_navigatorTitle];
    [_navigatorTitle setTextColor:[UIColor whiteColor]];
    _navigatorTitle.text = @"Wähle ein Datum";
    _chooseDateNavigationItem.title = @"";
    
    [_todayButton useAlertStyle];
    
    if (_actualDate == nil)
    {
        [_datePicker setDate:[NSDate date]];

    }
    else
    {
        [_datePicker setDate:_actualDate];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    _datePicker = nil;
    _chooseDateNavigationItem = nil;
    _navigatorTitle = nil;
    _todayButton = nil;
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [_datePicker setDate:_actualDate];    
}

- (IBAction)setPickerToToday:(id)sender
{
    [_datePicker setDate:[NSDate date]];

}


@end
