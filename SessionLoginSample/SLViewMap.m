#import "SLViewMap.h"


@interface SLViewMap ()

@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) NSMutableArray *mapAnnotations;

@end


#pragma mark -

@implementation SLViewMap
{
    CLLocationManager *locationManager;
    
}
@synthesize detailViewController = _detailViewController;
- (void)viewWillAppear:(BOOL)animated
{
    // restore the nav bar to translucent
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    [super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}
- (void)viewDidAppear:(BOOL)animated
{
    // initialize the GPS
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    self.mapView.delegate = self;
    
    
    self.mapAnnotations = [[NSMutableArray alloc] init];
    
    NSURL *url = [[NSURL alloc]
                  initWithString:@"http://www.fofolove.me/jay/api.php?s=getUserInfo"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:nil error:nil];
    
    XMLParser *parser = [[XMLParser alloc] initWithData:data];
    result = [[NSArray alloc] initWithArray:parser.result];
    parser = nil;
    int i= 0;
    for(NSArray *value in result){
        // annotation
        CLLocationCoordinate2D mylocation;
        NSString *s = [value valueForKey:@"lat"];
        NSScanner *scanner = [NSScanner scannerWithString:s];
        double d;
        BOOL success = [scanner scanDouble:&d];
        mylocation.latitude = d;
        s = [value valueForKey:@"lon"];
        scanner = [NSScanner scannerWithString:s];
        success = [scanner scanDouble:&d];
        mylocation.longitude = d;
        mapAnnotation *annotation = [[mapAnnotation alloc]
                                     initWithTitle:[NSString stringWithFormat:@"%@",[value valueForKey:@"name"]]
                                    initWithsub:[NSString stringWithFormat:@"%@",[value valueForKey:@"uid"]]
                                     coordinate:mylocation];
        
        [self.mapAnnotations insertObject:annotation atIndex:i];
        i++;
    }
    
    
    
    [self.mapView removeAnnotations:self.mapView.annotations];  // remove any annotations that exist
    [self.mapView addAnnotations:self.mapAnnotations];
    [super viewDidAppear:animated];
}
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = newLocation.coordinate.latitude;
    newRegion.center.longitude = newLocation.coordinate.longitude;
    newRegion.span.latitudeDelta = 0.112872;
    newRegion.span.longitudeDelta = 0.109863;
    [self.mapView setRegion:newRegion animated:YES];
       // stop updating
    [locationManager stopUpdatingLocation];
}

#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}
#endif


#pragma mark - MKMapViewDelegate

// user tapped the disclosure button in the callout
//
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"mapToDetail"]) {
        // 取得目的頁面
        DetailViewController *detail = segue.destinationViewController;
        detail.uid = userId;
    }

}
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    // here we illustrate how to detect which annotation type was clicked on for its callout
    //id <MKAnnotation> annotation = [view annotation];
    userId =view.restorationIdentifier;
    [self performSegueWithIdentifier:@"mapToDetail" sender:nil];
    // [self.navigationController pushViewController:self.detailViewController animated:YES];
   
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
   
    // in case it's the user location, we already have an annotation, so just return nil
    
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }
    
    NSString *uid = [annotation subtitle ] ;
    MKPinAnnotationView *pinView =
    (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:uid];
    if (pinView == nil)
    {
        // if an existing pin view was not available, create one
        MKPinAnnotationView *customPinView = [[MKPinAnnotationView alloc]
                                              initWithAnnotation:annotation reuseIdentifier:uid];
        customPinView.pinColor = MKPinAnnotationColorGreen;
        customPinView.animatesDrop = YES;
        customPinView.canShowCallout = YES;
        customPinView.restorationIdentifier =uid ;
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
        customPinView.rightCalloutAccessoryView = rightButton;
        
        NSURL * imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=small",uid]];
        
        NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImageView *sfIconView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:imageData]];
        customPinView.leftCalloutAccessoryView = sfIconView;
        return customPinView;
    }
    else
    {
        pinView.annotation = annotation;
    }
    return pinView;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
}
@end
