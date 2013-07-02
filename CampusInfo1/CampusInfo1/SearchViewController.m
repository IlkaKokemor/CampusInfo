//
//  SearchViewController.m
//  CampusInfo1
//
//  Created by Ilka Kokemor on 3/26/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SearchViewController.h"
#import "TimeTableAsyncRequest.h"
#import "DBCachingForAutocomplete.h"

@implementation SearchViewController

@synthesize _chooseSearchType;
@synthesize _searchTextField;
@synthesize _searchTypeArray;
@synthesize _searchType;
@synthesize _searchButton;
@synthesize _acronymAutocompleteTableView;
@synthesize _suggestions;
@synthesize _autocomplete;
@synthesize _classArray, _courseArray, _lecturerArray, _roomArray, _studentArray;
@synthesize _lecturerDictionary;

@synthesize _asyncTimeTableRequest;
@synthesize _dataFromUrl;

@synthesize _errorMessage;

@synthesize _connectionTrials;

@synthesize _dbCachingForAutocomplete;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];    
    self._searchTypeArray = [[NSArray alloc] initWithObjects:
                         @"Kurs", @"Dozent", @"Student",
                         @"Raum", @"Klasse", nil];
    _searchType = @"Dozent";
    
    // set picker view
    //self._chooseSearchType.frame = CGRectMake(20.0, 134.0, 140.0, 162.0);
    [_chooseSearchType selectRow:1 inComponent:0 animated:NO];
    
    self._searchTextField.delegate = self;
    [_searchButton useAlertStyle];
    
    //_courseArray = [NSMutableArray arrayWithObjects:@"t.PHSAV2-G", @"e",nil];
    //_lecturerArray = [NSMutableArray arrayWithObjects:@"huhp", @"rege",nil];
    //_studentArray = [NSMutableArray arrayWithObjects:@"huhp", @"rege",nil];
    //_roomArray     = [NSMutableArray arrayWithObjects:@"TH 567", @"TH 561", @"TP 406", @"TB 610", @"TH 331", nil];
    //_classArray    = [NSMutableArray arrayWithObjects:@"T_AV12b.BA",nil];
    
    _lecturerArray = [[NSMutableArray alloc] init];
    
    _autocomplete = [[Autocomplete alloc] initWithArray:_lecturerArray];
	_searchTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    _connectionTrials = 1;
    _lecturerDictionary = nil;
    
    _dbCachingForAutocomplete = [[DBCachingForAutocomplete alloc]init];
}


-(void) setAutocompleteCandidates
{
    if ([_searchType isEqualToString:@"Kurs"])
    {
        _autocomplete._candidates = _courseArray;
    }
    if ([_searchType isEqualToString:@"Dozent"])
    {
        _autocomplete._candidates = _lecturerArray;
    }
    if ([_searchType isEqualToString:@"Student"])
    {
        _autocomplete._candidates = _studentArray;
    }
    if ([_searchType isEqualToString:@"Raum"])
    {
        _autocomplete._candidates = _roomArray;
    }
    if ([_searchType isEqualToString:@"Klasse"])
    {
        _autocomplete._candidates = _classArray;
    }
}


//-------------------------------
// asynchronous request
//-------------------------------

-(void) dataDownloadDidFinish:(NSData*) data {
    
    self._dataFromUrl = data;
    
    // NSLog(@"dataDownloadDidFinish 1 %@",[NSThread callStackSymbols]);
    
    if (self._dataFromUrl != nil)
    {
        //NSString *_receivedString = [[NSString alloc] initWithData:self._dataFromUrl encoding:NSASCIIStringEncoding];
        //_receivedString = [_receivedString substringToIndex:100];
        //NSLog(@"dataDownloadDidFinish FOR SEARCHVIEWCONTROLLER %@", _receivedString);
        
        NSError *_error;
        
        if (_lecturerDictionary == nil)
        {
            _lecturerDictionary = [NSJSONSerialization
                               JSONObjectWithData:_dataFromUrl
                               options:kNilOptions
                               error:&_error];
        
            for (id lecturerKey in _lecturerDictionary)
            {
                //NSLog(@"lecturerKey:%@",lecturerKey);
                
                NSArray *_lecturerArray1 = [_lecturerDictionary objectForKey:lecturerKey];
                NSDictionary *_lecturerDictionary1;
                NSString *_lecturerName;
                NSString *_lecturerShortName;
                
                [_lecturerArray removeAllObjects];
                
                //NSLog(@"how many lecturers: %i",[_lecturerArray1 count]);
                
                int i;
                for (i = 0; i < [_lecturerArray1 count]; i++)
                {
                    _lecturerDictionary1 = [_lecturerArray1 objectAtIndex:i];
                    
                    for (id lecturerKey in _lecturerDictionary1)
                    {
                        if ([lecturerKey isEqualToString:@"name"])
                        {
                            _lecturerName = [_lecturerDictionary1 objectForKey:lecturerKey];
                            //NSLog(@"lecturer name: %@", _lecturerName);
                        }
                        
                        if ([lecturerKey isEqualToString:@"shortName"])
                        {
                            _lecturerShortName = [_lecturerDictionary1 objectForKey:lecturerKey];
                            //NSLog(@"lecturer shortName: %@", _lecturerShortName);
                            [_lecturerArray addObject:_lecturerShortName];
                        }
                    }
                }
                
                [_dbCachingForAutocomplete storeLecturers:_lecturerArray];
                [self setAutocompleteCandidates];
            }
        }
    }
}


-(void)threadDone:(NSNotification*)arg
{
    //NSLog(@"Thread exiting");
}

-(void) downloadData
{
    NSURL *_url;
    
        _url = [NSURL URLWithString:
                @"https://srv-lab-t-874.zhaw.ch/v1/schedules/lecturers/"];
    [_asyncTimeTableRequest downloadData:_url];
    
}


- (NSDictionary *) getDictionaryFromUrl
{
    
    _asyncTimeTableRequest = [[TimeTableAsyncRequest alloc] init];
    _asyncTimeTableRequest._timeTableAsynchRequestDelegate = self;
    [self performSelectorInBackground:@selector(downloadData) withObject:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(threadDone:)
                                                 name:NSThreadWillExitNotification
                                               object:nil];
    
    NSError      *_error = nil;
    NSDictionary *_scheduleDictionary;
    
    if (_dataFromUrl == nil)
    {        
        return nil;
    }
    else
    {
        //NSLog(@"getDictionaryFromUrl got some data putting it now into dictionary");
        _scheduleDictionary = [NSJSONSerialization
                               JSONObjectWithData:_dataFromUrl
                               options:kNilOptions
                               error:&_error];
        
    }
    return _scheduleDictionary;
}


-(void) getData
{
    if (self._courseArray == nil)
    {

        self._lecturerDictionary = nil;
        
        self._lecturerDictionary = [self getDictionaryFromUrl];
            
        if (self._lecturerDictionary == nil)
        {
            NSLog(@"no connection");
        }
        else
        {
            NSLog(@"IF connection established");
        }
    }
}





// IMPORTANT, OTHERWISE DATA WILL NOT BE UPDATED, WHEN APP IS STARTED FIRST TIME
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getData];
    
    if (self._lecturerDictionary == nil)
    {
        [_lecturerArray removeAllObjects];

        NSLog(@"no connection so get data from database");
        _lecturerArray = [_dbCachingForAutocomplete getLecturers];
        
        [self setAutocompleteCandidates];
        [self.view addSubview:_acronymAutocompleteTableView];
        [_acronymAutocompleteTableView reloadData];
    }
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)viewDidUnload
{
    _searchTextField = nil;
    _chooseSearchType = nil;
    _searchButton = nil;
    _acronymAutocompleteTableView = nil;
    [super viewDidUnload];
}



// methods for Picker for types
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
  // course, room, class, teacher, student
    return 1;
}

- (NSInteger)pickerView: (UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    // course, room, class, teacher, student
    return [_searchTypeArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self._searchTypeArray objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    _searchType = [_searchTypeArray objectAtIndex:row];
    
    [self setAutocompleteCandidates];
}


// handling the search button
- (IBAction)_startSearch:(id)sender
{
    if (_searchTextField.text == nil || [_searchTextField.text length] == 0)
    {
        UIAlertView *_acronymAlertView = [[UIAlertView alloc]
                                          initWithTitle:@"Suche"
                                          message:@"Bitte ein Kürzel eingeben."
                                          delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
        
        [_acronymAlertView show];
    }
    else
    {
        // trim space in front of and after the string
        NSString *_stringWithoutSpaces = [_searchTextField.text stringByTrimmingCharactersInSet:
                                          [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchType" object:_searchType];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchText" object:_stringWithoutSpaces];
    
        self.tabBarController.selectedIndex = 0;
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (IBAction)searchTextFieldChanged:(id)sender
{
    _suggestions = [[NSMutableArray alloc] initWithArray:[_autocomplete GetSuggestions:((UITextField*)sender).text]];
	
	[self.view addSubview:_acronymAutocompleteTableView];
	[_acronymAutocompleteTableView reloadData];
    
}


//---------- Handling of table for suggestions -----

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (_suggestions)
	{
		return [_suggestions count];
	}
	return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
	{
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
	
    UIFont *_cellFont = [ UIFont boldSystemFontOfSize: 12.0 ];
    cell.textLabel.font  = _cellFont;
    
	// Configure the cell.
	cell.textLabel.text = [_suggestions objectAtIndex:indexPath.row];
    
    return cell;
}

// set cell hight
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 20;
}

// Override to support row selection in the table view.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	_searchTextField.text = [_suggestions objectAtIndex:indexPath.row];
	[_acronymAutocompleteTableView removeFromSuperview];
}


@end
