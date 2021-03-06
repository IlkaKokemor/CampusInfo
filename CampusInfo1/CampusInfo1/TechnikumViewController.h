//
//  TechnikumViewController.h
//  CampusInfo1
//
//  Created by Ilka Kokemor on 19.08.13.
//
//

#import <UIKit/UIKit.h>
#import "ColorSelection.h"

@interface TechnikumViewController : UIViewController
{
    
    IBOutlet UINavigationBar    *_titleNavigationBar;
    IBOutlet UINavigationItem   *_titleNavigationItem;
    IBOutlet UILabel            *_titleNavigationLabel;

    IBOutlet UINavigationBar    *_descriptionNavigationBar;
    IBOutlet UINavigationItem   *_descriptionNavigationItem;
    IBOutlet UILabel            *_descriptionLabel;
    
    IBOutlet UIWebView          *_technikumWebView;

    NSString                    *_description;
    NSString                    *_fileName;
    NSString                    *_fileFormat;
    
    ColorSelection              *_zhawColor;
}


@property (nonatomic, retain) IBOutlet UINavigationBar                  *_titleNavigationBar;
@property (nonatomic, retain) IBOutlet UINavigationItem                 *_titleNavigationItem;
@property (nonatomic, retain) IBOutlet UILabel                          *_titleNavigationLabel;

@property (nonatomic, retain) IBOutlet UINavigationBar                  *_descriptionNavigationBar;
@property (nonatomic, retain) IBOutlet UINavigationItem                 *_descriptionNavigationItem;
@property (nonatomic, retain) IBOutlet UILabel                          *_descriptionLabel;

@property (nonatomic, retain) IBOutlet UIWebView                        *_technikumWebView;

@property (nonatomic, retain) NSString                                  *_description;
@property (nonatomic, retain) NSString                                  *_fileName;
@property (nonatomic, retain) NSString                                  *_fileFormat;

@property (nonatomic, retain) ColorSelection                            *_zhawColor;

@end
