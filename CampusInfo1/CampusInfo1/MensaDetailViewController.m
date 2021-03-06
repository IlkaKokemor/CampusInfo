//
//  MensaDetailViewController.m
//  CampusInfo1
//
//  Created by Ilka Kokemor on 22.07.13.
//
//

#import "MensaDetailViewController.h"

#import "SideDishDto.h"
#import "DishDto.h"
#import "MenuPlanDto.h"
#import "CalendarWeekDto.h"
#import "MenuDto.h"
#import "MenuPlanArrayDto.h"
#import "ColorSelection.h"
#import "UIConstantStrings.h"

@implementation MensaDetailViewController

@synthesize _actualGastronomy;
@synthesize _actualCalendarWeek;
@synthesize _actualDate;
@synthesize _actualMenu;
@synthesize _menuPlans;

@synthesize _dateButton;
@synthesize _dayNavigationItem;
@synthesize _dateNavigationBar;

@synthesize _dateFormatter;

@synthesize _chooseDateVC;
@synthesize _detailTable;
@synthesize _detailTableCell;

@synthesize _leftSwipe;
@synthesize _rightSwipe;

@synthesize _waitForChangeActivityIndicator;

@synthesize _gastronomyLabel;
@synthesize _titleNavigationBar;
@synthesize _titleNavigationItem;
@synthesize _titleNavigationLabel;

@synthesize _zhawColor;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // general initializer
    _zhawColor          = [[ColorSelection alloc]init];
    _dateFormatter      = [[DateFormation alloc] init];
    self._menuPlans     = [[MenuPlanArrayDto alloc] init:nil];
    self._actualMenu    = [[MenuDto alloc] init:nil withDishes:nil withOfferedOn:nil withVersion:nil];
    self._actualCalendarWeek = 0;
    
    // title
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:LeftArrowSymbol style:UIBarButtonItemStylePlain target:self action:@selector(backToMensaOverview:)];
    [backButtonItem setTintColor:_zhawColor._zhawOriginalBlue];
    [_titleNavigationItem setLeftBarButtonItem :backButtonItem animated :true];
    
    [_titleNavigationLabel setTextColor:_zhawColor._zhawWhite];
    [_titleNavigationLabel setTextAlignment:UITextAlignmentCenter];
    _titleNavigationLabel.text = MensaVCTitle;
    _titleNavigationItem.title = @"";
    
    [_titleNavigationBar setTintColor:_zhawColor._zhawDarkerBlue];
    
    _gastronomyLabel.text = [NSString stringWithFormat:@"%@",_actualGastronomy._name];
    [_gastronomyLabel setTextColor:_zhawColor._zhawWhite];
    [_gastronomyLabel setTextAlignment:UITextAlignmentCenter];
    
    //----- Navigation Bar ----
    // set current day
    [self setTitleToActualDate];

    // set day navigator
    UIBarButtonItem *_rightButton = [[UIBarButtonItem alloc] initWithTitle:RightArrowSymbol
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(dayAfter:)];
    UIBarButtonItem *_leftButton = [[UIBarButtonItem alloc] initWithTitle:LeftArrowSymbol
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(dayBefore:)];
    [_rightButton setTintColor:_zhawColor._zhawOriginalBlue];
    [_leftButton  setTintColor:_zhawColor._zhawOriginalBlue];
    [_dayNavigationItem setLeftBarButtonItem :_leftButton animated :true];
    [_dayNavigationItem setRightBarButtonItem:_rightButton animated:true];
    
    [_dateButton useAlertStyle];
    [_dateNavigationBar setTintColor:_zhawColor._zhawDarkerBlue];
    
    
    // ------ CHOOSE DATE FREELY ----
    if (_chooseDateVC == nil)
    {
		_chooseDateVC = [[ChooseDateViewController alloc] init];
	}
    _chooseDateVC._chooseDateViewDelegate = self;
    _chooseDateVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    
    // set table controller
    if (_detailTable == nil) {
		_detailTable = [[UITableView alloc] init];
	}
    _detailTable.separatorColor = _zhawColor._zhawLightGrey;
    _detailTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    [_detailTable reloadData];
    

    _rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dayBefore:)];
    [_rightSwipe setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [[self view] addGestureRecognizer:_rightSwipe];
    
    _leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dayAfter:)];
    [_leftSwipe setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [[self view] addGestureRecognizer:_leftSwipe];
    
    // activity indicator
    _waitForChangeActivityIndicator.hidesWhenStopped = YES;
    _waitForChangeActivityIndicator.hidden = YES;
    [_waitForChangeActivityIndicator setColor:_zhawColor._zhawOriginalBlue];
    [self.view bringSubviewToFront:_waitForChangeActivityIndicator];
}

- (void) threadWaitForChangeActivityIndicator:(id)data
{
    _waitForChangeActivityIndicator.hidden = NO;
    [_waitForChangeActivityIndicator startAnimating];
    //NSLog(@"start animating again");
}

-(void)startLoading
{
    [NSThread detachNewThreadSelector:@selector(threadWaitForChangeActivityIndicator:) toTarget:self withObject:nil];
}


- (void)setActualDate:(NSDate *)newDate
{
    //int _actualTrials = 0;
    self._actualDate      = newDate;
    [self setDateInNavigatorWithActualDate:_actualDate];
    
    NSCalendar *_calendar = [NSCalendar currentCalendar];
    int         _newWeekNumber = [[_calendar components: NSWeekOfYearCalendarUnit fromDate:newDate] weekOfYear];

    _actualCalendarWeek = _newWeekNumber;
        
    NSDateComponents *components = [_calendar components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:_actualDate];
    int _newYear = [components year];
    
    
    
    [_menuPlans getData:_newWeekNumber
                   withYear:_newYear
             withActualDate:_actualDate
               withGastroId:_actualGastronomy._gastroId
    ];
    
    self._actualMenu = [_menuPlans getActualMenu:_actualDate withGastroId:_actualGastronomy._gastroId];
    [_detailTable reloadData];
    
    [_waitForChangeActivityIndicator stopAnimating];
    _waitForChangeActivityIndicator.hidden = YES;
}


- (void) dayBefore:(id)sender
{
    int daysToAdd = -1;
    
    // set up date components
    NSDateComponents *_components = [[NSDateComponents alloc] init];
    [_components setDay:daysToAdd];
    
    NSCalendar *_gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate     *_newDate   = [_gregorian dateByAddingComponents:_components toDate:self._actualDate options:0];
    
    [self startLoading];
    [self setActualDate:_newDate];
}


- (void) dayAfter:(id)sender
{
    NSDate *_newDate = [self._actualDate dateByAddingTimeInterval:(1*24*60*60)];
   [self startLoading];
   [self setActualDate:_newDate];
}

- (void) setTitleToActualDate
{
    NSDateFormatter* df_local = [[NSDateFormatter alloc] init];
    [df_local setTimeZone:[NSTimeZone timeZoneWithName:@"CEST"]];
    [df_local setDateFormat:@"yyyy.MM.dd G 'at' HH:mm:ss zzz"];
        
    //----- Navigation Bar ----
    // set current day
    if (self._actualDate == nil)
    {
        self._actualDate = [NSDate date];
        //self._actualDate    = [[_dateFormatter _dayFormatter] dateFromString:@"17.12.2012"];
    }
    
    [self setDateInNavigatorWithActualDate:self._actualDate];
    
    //NSLog(@"set actual Date: %@", [[self dayFormatter] stringFromDate:self._actualDate]);
}


- (void) setDateInNavigatorWithActualDate:(NSDate *)showDate
{
    NSString *_dateString = [NSString stringWithFormat:@"%@, %@"
                             ,[[_dateFormatter _weekDayFormatter] stringFromDate:showDate]
                             ,[[_dateFormatter _dayFormatter]     stringFromDate:showDate]];
    
    [_dateButton setTitle:_dateString forState:UIControlStateNormal];
    _dayNavigationItem.title = @"";
    
    //self.navigationItem.titleView = _dateLabel;
    
    self._actualMenu = [_menuPlans getActualMenu:showDate withGastroId:_actualGastronomy._gastroId];
    [_detailTable reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tryConnectionAgain:(id)sender
{
    [self startLoading];
    [self setActualDate:_actualDate];
}

- (void)backToMensaOverview:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)moveToChooseDateView:(id)sender
{
    _chooseDateVC._actualDate = self._actualDate;
    [self presentModalViewController:_chooseDateVC animated:YES];
}

- (void)viewDidUnload
{
    _dayNavigationItem = nil;
    _chooseDateVC = nil;
    _detailTable = nil;
    _detailTableCell = nil;
    _gastronomyLabel = nil;
    _rightSwipe = nil;
    _leftSwipe = nil;
    _waitForChangeActivityIndicator = nil;
    _titleNavigationBar = nil;
    _titleNavigationItem = nil;
    _titleNavigationLabel = nil;
    _dateButton = nil;
    _dateNavigationBar = nil;
    [super viewDidUnload];
}


- (void)viewWillAppear:(BOOL)animated
{
    //NSLog(@"viewWillAppear");
    [super viewWillAppear:animated];
    [self startLoading];

}

-(void)viewDidAppear:(BOOL)animated
{
    [self setActualDate:_actualDate];
    _gastronomyLabel.text = [NSString stringWithFormat:@"%@",_actualGastronomy._name];
}


// table and table cell handling

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //return 3;
    //NSLog(@"number of sections in table view: %i", [_actualMenu._dishes count]);
    if ([_actualMenu._dishes  lastObject] == nil)
    {
        return 1;
    }
    else
    {
        return [_actualMenu._dishes count];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 137;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    //NSLog(@"start cellForRowAtIndexPath");
    NSUInteger        _cellSelection = indexPath.section;
    static NSString *_cellIdentifier  = @"MensaDetailTableCell";
    UITableViewCell *_cell            = [tableView dequeueReusableCellWithIdentifier:_cellIdentifier];
        
    if (_cell == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"MensaDetailTableCell" owner:self options:nil];
        _cell = _detailTableCell;
        self._detailTableCell = nil;
    }
    
    //NSLog(@"cellForRowAtIndexPath callStack %@",[NSThread callStackSymbols]);
    
    
    UILabel         *_labelTitle            = (UILabel *) [_cell viewWithTag:1];
    UILabel         *_labelMaincourse       = (UILabel *) [_cell viewWithTag:2];
    UILabel         *_labelSidedishes       = (UILabel *) [_cell viewWithTag:3];
    UILabel         *_labelPriceInternal    = (UILabel *) [_cell viewWithTag:4];
    UILabel         *_labelPricePartner     = (UILabel *) [_cell viewWithTag:5];
    UILabel         *_labelPriceExternal    = (UILabel *) [_cell viewWithTag:6];
    
    UILabel         *_labelWriteInternalPrice   = (UILabel *) [_cell viewWithTag:7];
    UILabel         *_labelWritePartnerPrice    = (UILabel *) [_cell viewWithTag:8];
    UILabel         *_labelWriteExternalPrice   = (UILabel *) [_cell viewWithTag:9];
    
    [_labelTitle            setTextColor:_zhawColor._zhawFontGrey];
    [_labelMaincourse       setTextColor:_zhawColor._zhawFontGrey];
    [_labelSidedishes       setTextColor:_zhawColor._zhawFontGrey];
    [_labelPriceInternal    setTextColor:_zhawColor._zhawFontGrey];
    [_labelPricePartner     setTextColor:_zhawColor._zhawFontGrey];
    [_labelPriceExternal    setTextColor:_zhawColor._zhawFontGrey];
    
    [_labelWriteInternalPrice   setTextColor:_zhawColor._zhawFontGrey];
    [_labelWritePartnerPrice    setTextColor:_zhawColor._zhawFontGrey];
    [_labelWriteExternalPrice   setTextColor:_zhawColor._zhawFontGrey];
    
    if ([_actualMenu._dishes  lastObject] == nil
    || [_actualMenu._dishes count] <= _cellSelection)
    {
        //NSLog(@"no dishes found with _cellSelection: %i", _cellSelection);

        if (_cellSelection > 0)
        {
            _labelTitle.text = @"";
        }
        else
        {
            _labelTitle.text            = @"keine Informationen über das Menü";
        }
        
        _labelMaincourse.text           = @"";
        _labelSidedishes.text           = @"";
        _labelPriceInternal.text        = @"";
        _labelPriceExternal.text        = @"";
        _labelPricePartner.text         = @"";
        _labelWriteInternalPrice.text   = @"";
        _labelWritePartnerPrice.text    = @"";
        _labelWriteExternalPrice.text   = @"";
    }
    else
    {
        
        SideDishDto     *_oneSideDish;
        int             sideDishI;
        NSString        *_sideDishString;
        DishDto         *_oneDish = [_actualMenu._dishes objectAtIndex:_cellSelection];
        
        _labelTitle.text = _oneDish._label;
        _labelMaincourse.text = _oneDish._name;
        
        //NSLog(@"show dishes: %i with _cellSelection: %i one dish name %@", [_actualMenu._dishes count], _cellSelection, _oneDish._name);
        
        if ([_oneDish._sideDishes lastObject] != nil)
        {
            for (sideDishI=0; sideDishI < [_oneDish._sideDishes count]; sideDishI++)
            {
                _oneSideDish = [_oneDish._sideDishes objectAtIndex:sideDishI];
                if (sideDishI == 0)
                {
                    _sideDishString = _oneSideDish._name;
                }
                else
                {
                    _sideDishString = [NSString stringWithFormat:@"%@, %@",_sideDishString, _oneSideDish._name];
                }
            }
        }
        _labelSidedishes.text       = _sideDishString;
        _labelPriceExternal.text    = [NSString stringWithFormat:@"%.2f CHF",_oneDish._externalPrice];
        _labelPriceInternal.text    = [NSString stringWithFormat:@"%.2f CHF",_oneDish._internalPrice];
        _labelPricePartner.text     = [NSString stringWithFormat:@"%.2f CHF",_oneDish._priceForPartners];
        _labelWriteInternalPrice.text = @"interner Preis";
        _labelWritePartnerPrice.text  = @"Partner";
        _labelWriteExternalPrice.text = @"externer Preis";

    }
    
    return _cell;
}


@end
