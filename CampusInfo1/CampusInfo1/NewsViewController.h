//
//  NewsViewController.h
//  CampusInfo1
//
//  Created by Ilka Kokemor on 14.08.13.
//
//

#import <UIKit/UIKit.h>
#import <NewsChannelDto.h>
#import <NewsDetailViewController.h>
#import <DateFormation.h>

@class NewsDetailViewController;


@interface NewsViewController : UIViewController<UITableViewDelegate>
{
    NewsChannelDto                      *_newsChannel;

    IBOutlet UILabel                    *_titleLabel;
    IBOutlet UILabel                    *_descriptionTitleLabel;
    
    IBOutlet UITableView                *_newsTable;
    IBOutlet UITableViewCell            *_newsTableCell;
    
    DateFormation                       *_dateFormatter;
    
    UIColor                             *_blueColor;
    IBOutlet NewsDetailViewController   *_newsDetailVC;
    
    int                                 _actualTrials;
    IBOutlet UIButton                   *_noConnectionButton;
    IBOutlet UILabel                    *_noConnectionLabel;
    
}

@property (strong, nonatomic) NewsChannelDto                        *_newsChannel;
@property (nonatomic, retain) IBOutlet UILabel                      *_titleLabel;
@property (nonatomic, retain) IBOutlet UILabel                      *_descriptionTitleLabel;

@property (nonatomic, retain) IBOutlet UITableView                  *_newsTable;
@property (nonatomic, retain) IBOutlet UITableViewCell              *_newsTableCell;

@property (nonatomic, retain) DateFormation                         *_dateFormatter;

@property (nonatomic, retain) UIColor                               *_blueColor;

@property (nonatomic, retain) IBOutlet NewsDetailViewController     *_newsDetailVC;

@property (nonatomic, assign) int                                   _actualTrials;
@property (nonatomic, retain) IBOutlet UIButton                     *_noConnectionButton;
@property (nonatomic, retain) IBOutlet UILabel                      *_noConnectionLabel;

- (IBAction)tryConnectionAgain:(id)sender;
- (IBAction)moveBackToMenuOverview:(id)sender;

@end