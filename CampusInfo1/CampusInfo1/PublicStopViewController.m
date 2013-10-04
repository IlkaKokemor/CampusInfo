/*
 PublicStopViewController.m
 ZHAW Engineering CampusInfo
 */

/*!
 * @header PublicStopViewController.m
 * @author Ilka Kokemor
 * @copyright 2013 ZHAW
 * @discussion
 * <ul>
 * <li> Responsibilities:
 *   <ul>
 *      <li> Control of PublicStopViewController.xib, where stations can be searched using autocomplete functionality. </li>
 *      <li> While typing stations, tables shows suggestions for autocomplete. </li>
 *  </ul>
 * </li>
 *
 * <li> Receiving data:
 *   <ul>
 *      <li> Receives delegate from PublicTransportViewController and passes it back, if back button is clicked. </li>
 *   </ul>
 * </li>
 *
 * <li> Sending data:
 *   <ul>
 *      <li> It passes the found station back to PublicTransportViewController. </li>
 *   </ul>
 * </li>
 *
 * </ul>
 */

#import "PublicStopViewController.h"
#import "ColorSelection.h"
#import "StationDto.h"
#import "UIConstantStrings.h"

@interface PublicStopViewController ()

@end

@implementation PublicStopViewController

@synthesize _stationArray;
@synthesize _actualStationType;
@synthesize _actualStationName;

@synthesize _titleNavigationBar;
@synthesize _titleNavigationItem;
@synthesize _titleNavigationLabel;

@synthesize _publicStopTableView;

@synthesize _publicStopTextField;
@synthesize _publicStopTextFieldString;

@synthesize _dbCachingForAutocomplete;
@synthesize _autocomplete;
@synthesize _suggestions;

@synthesize _zhawColors;

/*!
 * @function initWithNibName
 * Initializiation of class.
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

/*!
 @function moveBackToPublicTransport
 When back button is triggered, delegate is returned to PublicTransportViewController.
 @param sender
 */
- (void)moveBackToPublicTransport:(id)sender
{    
    _actualStationName = _publicStopTextField.text;
    [self dismissModalViewControllerAnimated:YES];
}

/*!
 @function publicStopTextFieldChanged
 Triggered, when the text in _publicStopTextField is changed by the user. Then the table for suggestions needs to be updated accordingly.
 @param sender
 */
- (IBAction)publicStopTextFieldChanged:(id)sender
{
    _suggestions = [[NSMutableArray alloc] initWithArray:[_autocomplete GetSuggestions:((UITextField*)sender).text]];
    _publicStopTextFieldString = ((UITextField*)sender).text;
    _publicStopTableView.hidden = NO;
    [_publicStopTableView reloadData];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

/*!
 * @function viewDidLoad
 * The function is included, since class inherits from UIViewController.
 * Is called first time, the view is started for initialization.
 * Is only called once, after initialization, never again.
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // general initialization
    _zhawColors = [[ColorSelection alloc]init];
    
    // handling of autocompletion while using station db
    _dbCachingForAutocomplete = [[DBCachingForAutocomplete alloc]init];
    
    NSMutableArray *_stationDBArray = [_dbCachingForAutocomplete getDBStations];
    //NSLog(@"count db station array: %i", [_stationDBArray count]);
    _autocomplete = [[Autocomplete alloc] initWithArray:_stationDBArray];

    
    // title
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:LeftArrowSymbol style:UIBarButtonItemStylePlain target:self action:@selector(moveBackToPublicTransport:)];
    
    [backButtonItem setTintColor:_zhawColors._zhawOriginalBlue];
    [_titleNavigationItem setLeftBarButtonItem :backButtonItem animated :true];
    
    [_titleNavigationLabel setTextColor:[UIColor whiteColor]];
    _titleNavigationLabel.text = PublicTransportVCTitle;
    _titleNavigationItem.title = @"";
    
    [_titleNavigationLabel setTextAlignment:UITextAlignmentCenter];
    
    [_titleNavigationBar setTintColor:_zhawColors._zhawDarkerBlue];
    
    self._stationArray = [[StationArrayDto alloc] init:nil];
    
    _actualStationName = @"";
    
    self._publicStopTextField.delegate = self;
 	_publicStopTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    [_publicStopTextField setTextColor:_zhawColors._zhawFontGrey];
}

/*!
 * @function didReceiveMemoryWarning
 * The function is included per default.
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*!
 * @function viewWillAppear
 * The function is included, since class inherits from UIViewController.
 * It is called every time the view is called again.
 */
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _actualStationName = @"";
    _publicStopTableView.hidden = YES;

}

/*!
 @function viewDidUnload
 * The function is included, since class inherits from UIViewController.
 * It is called while the view is unloaded.
 */
- (void)viewDidUnload
{
    _titleNavigationBar = nil;
    _titleNavigationItem = nil;
    _titleNavigationLabel = nil;
    _publicStopTableView = nil;
    _publicStopTextField = nil;
    [super viewDidUnload];
}


// ------- MANAGE TABLE CELLS ----
/*!
 * @function numberOfSectionsInTableView
 * The function defines the number of sections in table.
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

/*!
 * @function numberOfRowsInSection
 * The function defines the number of rows in table.
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_suggestions count];
}

/*!
 * @function didSelectRowAtIndexPath
 * The function supports row selection.
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _publicStopTextField.text = [_suggestions objectAtIndex:indexPath.row];
    _publicStopTableView.hidden = YES;
    _actualStationName = _publicStopTextField.text;
    [self dismissModalViewControllerAnimated:YES];
}

/*!
 * @function cellForRowAtIndexPath
 * The function is for customizing the table view cells.
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
	{
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [_suggestions objectAtIndex:indexPath.row];
    [cell.textLabel setTextColor:_zhawColors._zhawFontGrey];
    return cell;
}



@end
