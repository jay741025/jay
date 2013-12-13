#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <CoreLocation/CoreLocation.h>


@interface SLViewController : UIViewController <CLLocationManagerDelegate>
-(BOOL) uploadUserInfo;
-(void)actIndicatorBegin;
-(void)actIndicatorEnd;
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation;
@end



