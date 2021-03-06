//
//  EventsViewController.h
//  CampusInfo1
//
//  Created by Ilka Kokemor on 14.08.13.
//
//

#import <UIKit/UIKit.h>
#import "NewsChannelDto.h"
#import "DateFormation.h"
#import "ColorSelection.h"
#import "GradientButton.h"

@interface EventsViewController : UIViewController
{
    NewsChannelDto                      *_newsChannel;

    IBOutlet UITableView                *_eventsTable;
    IBOutlet UITableViewCell            *_eventsTableCell;
    
    DateFormation                       *_dateFormatter;
    
    int                                 _actualTrials;
    IBOutlet UILabel                    *_noConnectionLabel;
    IBOutlet GradientButton             *_noConnectionButton;

    IBOutlet UINavigationBar            *_titleNavigationBar;
    IBOutlet UINavigationItem           *_titleNavigationItem;
    IBOutlet UILabel                    *_titleNavigationLabel;
    
    ColorSelection                      *_zhawColor;
    
    IBOutlet UIActivityIndicatorView    *_waitForLoadingActivityIndicator;
}

@property (nonatomic, retain) NewsChannelDto                        *_newsChannel;

@property (nonatomic, retain) DateFormation                         *_dateFormatter;
@property (nonatomic, retain) ColorSelection                        *_zhawColor;

@property (nonatomic, retain) IBOutlet UINavigationBar              *_titleNavigationBar;
@property (nonatomic, retain) IBOutlet UINavigationItem             *_titleNavigationItem;
@property (nonatomic, retain) IBOutlet UILabel                      *_titleNavigationLabel;

@property (nonatomic, retain) IBOutlet UITableView                  *_eventsTable;
@property (nonatomic, retain) IBOutlet UITableViewCell              *_eventsTableCell;

@property (nonatomic, assign) int                                   _actualTrials;
@property (nonatomic, retain) IBOutlet GradientButton               *_noConnectionButton;
@property (nonatomic, retain) IBOutlet UILabel                      *_noConnectionLabel;

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView      *_waitForLoadingActivityIndicator;


- (IBAction)tryConnectionAgain:(id)sender;

@end
