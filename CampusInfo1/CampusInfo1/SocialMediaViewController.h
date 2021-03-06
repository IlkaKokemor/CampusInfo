//
//  SocialMediaViewController.h
//  CampusInfo1
//
//  Created by Ilka Kokemor on 26.08.13.
//
//

#import <UIKit/UIKit.h>
#import "ColorSelection.h"

@interface SocialMediaViewController : UIViewController<UITableViewDelegate>
{

    IBOutlet UINavigationBar        *_titleNavigationBar;
    IBOutlet UINavigationItem       *_titleNavigationItem;
    IBOutlet UILabel                *_titleNavigationLabel;
    
    IBOutlet UITableViewCell        *_socialMediaTableCell;
    
    ColorSelection                  *_zhawColor;
}

@property (nonatomic, retain) IBOutlet UINavigationBar              *_titleNavigationBar;
@property (nonatomic, retain) IBOutlet UINavigationItem             *_titleNavigationItem;
@property (nonatomic, retain) IBOutlet UILabel                      *_titleNavigationLabel;
@property (nonatomic, retain) IBOutlet UITableViewCell              *_socialMediaTableCell;

@property (nonatomic, retain) ColorSelection                        *_zhawColor;

@end
