#import "mapAnnotation.h"
@implementation mapAnnotation

@synthesize title = _title, coordinate = _coordinate,subtitle =_subtitle;

- (id) initWithTitle:(NSString *) t initWithsub:(NSString *) s coordinate:(CLLocationCoordinate2D) c{
self = [super init];
if(self){
    _title = t;
    _coordinate = c;
    _subtitle =s;
    // self.coordinate = c /* !This is readonly ! */
}
return self;
}
@end