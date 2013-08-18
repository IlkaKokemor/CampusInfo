//
//  NewsViewController.m
//  CampusInfo1
//
//  Created by Ilka Kokemor on 14.08.13.
//
//

#import "NewsViewController.h"

@interface NewsViewController ()

@end

@implementation NewsViewController
@synthesize _newsChannel;

@synthesize _titleLabel;
@synthesize _descriptionTitleLabel;

@synthesize _newsTable;
@synthesize _newsTableCell;

@synthesize _dateFormatter;

@synthesize _blueColor;

@synthesize _newsDetailVC;

@synthesize _actualTrials;
@synthesize _noConnectionButton;
@synthesize _noConnectionLabel;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad
{
    //NSLog(@"news view controller: viewDidLoad");
    [super viewDidLoad];

    _newsChannel   = [[NewsChannelDto alloc]init];
    _blueColor = [UIColor colorWithRed:1.0/255.0 green:100.0/255.0 blue:167.0/255.0 alpha:1.0];
    
    [_titleLabel setBackgroundColor:_blueColor];
    [_titleLabel setTextColor:[UIColor whiteColor]];
    
    [_descriptionTitleLabel setBackgroundColor:_blueColor];
    [_descriptionTitleLabel setTextColor:[UIColor whiteColor]];
    
    _dateFormatter = [[DateFormation alloc] init];
    
    _descriptionTitleLabel.text = [NSString stringWithFormat:@"   School of Engineering"];
    _titleLabel.text            = [NSString stringWithFormat:@"   News"];

    // ----- DETAIL PAGE -----
    if (_newsDetailVC == nil)
    {
		_newsDetailVC = [[NewsDetailViewController alloc] init];
	}
    _newsDetailVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    //[_newsChannel getData];
    [_newsTable reloadData];
    
    self._actualTrials = 1;
    
    _noConnectionButton.hidden = YES;
    _noConnectionLabel.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) sortNewsItems
{

    //int someArrayI;
    //for (someArrayI = 0; someArrayI < [_newsChannel._newsItemArray count]; someArrayI++)
    //{
    //    NewsItemDto *_oneItem = [_newsChannel._newsItemArray objectAtIndex:someArrayI];
        //NSLog(@"before sorting _oneItem date %@ and title %@", [NSString stringWithFormat:@"%@"
        //                                                       ,[[_dateFormatter _dayFormatter] stringFromDate:_oneItem._pubDate]], _oneItem._title);
    //}
    
       
       [_newsChannel._newsItemArray sortUsingComparator:^NSComparisonResult(NewsItemDto *a, NewsItemDto *b)
        {
            
            //int timestamp1 = [a._pubDate timeIntervalSince1970];
            //int timestamp2 = [b._pubDate timeIntervalSince1970];
            
            NSString *_compareInEnglishDateFormat1 = [NSString stringWithFormat:@"%.0f", [a._pubDate timeIntervalSince1970]];
            NSString *_compareInEnglishDateFormat2 = [NSString stringWithFormat:@"%.0f", [b._pubDate timeIntervalSince1970]];
            
            //NSString *_compareInEnglishDateFormat1 = [[_dateFormatter _dayFormatter] stringFromDate:a._pubDate];
            //NSString *_compareInEnglishDateFormat2 = [[_dateFormatter _dayFormatter] stringFromDate:b._pubDate];
            
            return [_compareInEnglishDateFormat1 compare:_compareInEnglishDateFormat2];
        }
        ];
       
       
       
    //for (someArrayI = 0; someArrayI < [_newsChannel._newsItemArray count]; someArrayI++)
    //{
    //    NewsItemDto *_oneItem = [_newsChannel._newsItemArray objectAtIndex:someArrayI];
        
        //NSLog(@"after sorting _oneItem date %@ and title %@", [NSString stringWithFormat:@"%@"
        //                                         ,[[_dateFormatter _dayFormatter] stringFromDate:_oneItem._pubDate]], _oneItem._title);
    //}
}


- (IBAction)tryConnectionAgain:(id)sender
{
    [_newsChannel getData];
    [_newsTable reloadData];
}

- (IBAction)moveBackToMenuOverview:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
    //self.tabBarController.selectedIndex = 0;
}

- (void)viewDidUnload {
    _titleLabel = nil;
    _newsTable = nil;
    _newsTableCell = nil;
    _descriptionTitleLabel = nil;
    _newsDetailVC = nil;
    _noConnectionButton = nil;
    _noConnectionLabel = nil;
    [super viewDidUnload];
}


- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    
    //NSLog(@"news view controller: viewWillAppear: %i", [_newsChannel._newsItemArray count]);
    

        if (_actualTrials < 20)
        {
            _actualTrials++;
            [_newsChannel getData];
            [_newsTable reloadData];
            if ( [_newsChannel._newsItemArray count] == 0)
            {
                self._noConnectionButton.hidden = NO;
                self._noConnectionLabel.hidden = NO;
            }
        }
}

-(void) showNewsDetails:(id)sender event:(id)event
{
    NSSet       *_touches              = [event    allTouches];
    UITouch     *_touch                = [_touches anyObject ];
    CGPoint      _currentTouchPosition = [_touch locationInView:self._newsTable];
    NSIndexPath *_indexPath            = [self._newsTable indexPathForRowAtPoint: _currentTouchPosition];
    NSUInteger        _cellSelection = _indexPath.section;
    
    if ([_newsChannel._newsItemArray count] >= _cellSelection)
	{
        NewsItemDto *_newsItem = [_newsChannel._newsItemArray objectAtIndex:_cellSelection];
        
        _newsDetailVC._newsItem = _newsItem;

        [self presentModalViewController:_newsDetailVC animated:YES];
    }
}


//---------- Handling of table for suggestions -----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([_newsChannel._newsItemArray count] > 0)
	{
        self._noConnectionButton.hidden = YES;
        self._noConnectionLabel.hidden = YES;
        //NSLog(@"news item array count: %i", [_newsChannel._newsItemArray count]);
        

        
        
		return [_newsChannel._newsItemArray count];
	}
	return 1;
}



// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
     
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"news view controller: cellForRowAtIndexPath");
    //if ([_newsChannel._newsItemArray count] == 0)
	//{
            // VERY IMPORTANT, OTHERWISE, NO NEW DATA
           // [self viewWillAppear:YES];
    //}
    
    NSUInteger        _cellSelection = indexPath.section;
    NSString         *_cellIdentifier;
    UITableViewCell  *_cell = nil;
    
    
    _cellIdentifier  = @"NewsTableCell";
    _cell            = [tableView dequeueReusableCellWithIdentifier:_cellIdentifier];
    
    if (_cell == nil)
    {
         [[NSBundle mainBundle] loadNibNamed:@"NewsTableCell" owner:self options:nil];
         _cell = _newsTableCell;
         self._newsTableCell = nil;
    }
    
    UILabel *_oneTitleLabel     = (UILabel *) [_cell viewWithTag:1];
    UILabel *_dateLabel         = (UILabel *) [_cell viewWithTag:2];
    UILabel *_descriptionLabel  = (UILabel *) [_cell viewWithTag:3];
    UIButton *_detailButton     = (UIButton *)[_cell viewWithTag:4];
    _detailButton.hidden        = YES;
    
    
    if([_newsChannel._newsItemArray count] > 0)
    {
        NSLog(@"item array count: %i >= _cellSelection: %i", [_newsChannel._newsItemArray count], _cellSelection);

        if ([_newsChannel._newsItemArray count] >= _cellSelection)
        {
            NewsItemDto *_newsItem = [_newsChannel._newsItemArray objectAtIndex:_cellSelection];
            
            //NSLog(@"_newsItem._title: %@ - _cellSelection: %i", _newsItem._title, _cellSelection);
            
            _oneTitleLabel.text     = _newsItem._title;
            _dateLabel.text         = [NSString stringWithFormat:@"%@"
                                       ,[[_dateFormatter _dayFormatter] stringFromDate:_newsItem._pubDate]];
            _descriptionLabel.text  = _newsItem._description;
    
            [_oneTitleLabel setTextColor:_blueColor];
            [_dateLabel     setTextColor:[UIColor lightGrayColor]];
        
            [_detailButton addTarget:self action:@selector(showNewsDetails  :event:) forControlEvents:UIControlEventTouchUpInside];
            _detailButton.hidden    = NO;
        }
    }
    return _cell;
}

// set cell hight
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 126;
}

// Override to support row selection in the table view.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	//_acronymTextField.text = [_suggestions objectAtIndex:indexPath.row];
    //_acronymAutocompleteTableView.hidden = YES;
}



@end
