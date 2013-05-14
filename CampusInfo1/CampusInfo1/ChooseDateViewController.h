//
//  ChooseDateViewController.h
//  CampusInfo1
//
//  Created by Ilka Kokemor on 13.05.13.
//
//

#import <UIKit/UIKit.h>

@protocol ChooseDateViewDelegate <NSObject>

-(void) setActualDate:(NSDate *)newDate;
@end

@interface ChooseDateViewController : UIViewController
{
    IBOutlet UIDatePicker     *_datePicker;
    IBOutlet UINavigationItem *_chooseDateNavigationItem;
    id                         _chooseDateViewDelegate;
    IBOutlet UILabel          *_navigatorTitle;
}

- (IBAction)setPickerToToday:(id)sender;

@property (nonatomic, retain) IBOutlet UIDatePicker       *_datePicker;
@property (nonatomic, retain) IBOutlet UINavigationItem   *_chooseDateNavigationItem;
@property (nonatomic, retain) id<ChooseDateViewDelegate>   _chooseDateViewDelegate;
@property (nonatomic, retain) IBOutlet UILabel            *_navigatorTitle;

@end