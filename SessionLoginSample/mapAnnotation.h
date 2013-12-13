#import <MapKit/MapKit.h>

@interface mapAnnotation : NSObject<MKAnnotation>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, readonly) CLLocationCoordinate2D cordinate;
@property (nonatomic, readonly, copy) NSString *subtitle;
- (id) initWithTitle:(NSString *) t initWithsub:(NSString *) s coordinate:(CLLocationCoordinate2D) c;


@end