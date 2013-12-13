/*
 * Copyright 2010-present Facebook.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "SLViewController.h"

#import "SLAppDelegate.h"

@interface SLViewController () <FBLoginViewDelegate>
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
- (void)updateView;
@end

@implementation SLViewController{
    CLLocationManager *locationManager;
    NSMutableDictionary *postArray ;
    BOOL loginStatus ;
    NSTimer *timer;
    UIAlertView *alertView;
}
@synthesize activityIndicator;

- (void) actIndicatorBegin {
    [activityIndicator startAnimating];
}

-(void) actIndicatorEnd {
    [activityIndicator stopAnimating];
}
- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    loginStatus = NO;
    postArray = [NSMutableDictionary dictionary] ;
    // Do any additional setup after loading the view, typically from a nib.
    FBLoginView *loginview = [[FBLoginView alloc] init];
    
    loginview.frame = CGRectOffset(loginview.frame, 5, 5);
#ifdef __IPHONE_7_0
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        loginview.frame = CGRectOffset(loginview.frame, 5, 25);
    }
#endif
#endif
#endif
    loginview.delegate = self;
    
    [self.view addSubview:loginview];
    [loginview sizeToFit];
    [loginview setHidden:YES];
    
    
    SLAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    if (!appDelegate.session.isOpen) {
        // create a fresh session object
        appDelegate.session = [[FBSession alloc] init];

        // if we don't have a cached token, a call to open here would cause UX for login to
        // occur; we don't want that to happen unless the user clicks the login button, and so
        // we check here to make sure we have a token before calling open
        if (appDelegate.session.state == FBSessionStateCreatedTokenLoaded) {
            // even though we had a cached token, we need to login to make the session usable
            [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                             FBSessionState status,
                                                             NSError *error) {
                // we recurse here, in order to update buttons and labels
                [self updateView];
            }];
        }
    }
    // initialize the GPS
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [activityIndicator setCenter:CGPointMake(12, 12)];
    [activityIndicator setHidesWhenStopped:YES];
    [activityIndicator setActivityIndicatorViewStyle: UIActivityIndicatorViewStyleWhite];
    [activityIndicator startAnimating];
    [NSThread detachNewThreadSelector: @selector(actIndicatorBegin) toTarget:self withObject:nil];
    
    
    timer =[NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(alert) userInfo:nil repeats:YES];
    [self updateView];
    
}

- (void) alert {
    
    NSLog(@"alert");
    alertView =[[UIAlertView alloc] initWithTitle:@"Warning" message:@"伺服器忙線中..." delegate:self cancelButtonTitle:@"重試" otherButtonTitles:nil, nil];
    [alertView show];
    [self updateView];
    
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    
   
    [locationManager startUpdatingLocation];
    NSString *uid =  [NSString stringWithFormat:@"%@",user.id];
    [postArray setObject: uid forKey:@"uid" ];
    NSString *name =  [NSString stringWithFormat:@"%@",user.name];
    [postArray setObject: name forKey:@"name" ];
 
    
}
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
   
    NSString *latitude =  [NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
    [postArray setObject: latitude forKey:@"latitude" ];
    NSString *longitude =  [NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
    [postArray setObject: longitude forKey:@"longitude" ];
   
    if([self uploadUserInfo]==YES && loginStatus == NO)
    {
        [timer invalidate];
        loginStatus =YES ;
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(login:) userInfo:nil repeats:YES];

    }
    // stop updating
    [locationManager stopUpdatingLocation];
}
// FBSample logic
// main helper method to update the UI to reflect the current state of the session.
- (void)updateView {
    // get the app delegate, so that we can reference the session property
    SLAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
        if (appDelegate.session.isOpen) {
        // valid account UI is shown whenever the session is open
      
        } else {
        // login-needed account UI is shown whenever the session is closed
            
            [timer invalidate];
            [appDelegate.session closeAndClearTokenInformation];
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(toLogin:) userInfo:nil repeats:YES];

            
        }
}
- (void) login:(NSTimer *) logintimer {
    [logintimer invalidate];
    [activityIndicator stopAnimating];
    NSLog(@"login");
    [self performSegueWithIdentifier:@"login" sender:nil];
}
- (void) toLogin:(NSTimer *) toLogintimer {
    [toLogintimer invalidate];
    [activityIndicator stopAnimating];
    NSLog(@"toLogin");
    [self performSegueWithIdentifier:@"toLogin" sender:nil];
}

// 上傳手機圖片到 server
-(BOOL) uploadUserInfo{
    
    if(loginStatus == YES)
    {
        return YES ;
    }
    
    NSString *str =  [NSString stringWithFormat:@"uid=%@&name=%@&lat=%@&lon=%@"
                      ,[postArray objectForKey:@"uid"]
                      ,[postArray objectForKey:@"name" ]
                      ,[postArray objectForKey:@"latitude" ]
                      ,[postArray objectForKey:@"longitude" ]] ;
    
	// 使用 POST 上傳到伺服器上
    
    NSString *url =@"http://www.fofolove.me/jay/api.php?s=uploadUserInfo";
 
    NSData *userdata = [str dataUsingEncoding:NSUTF8StringEncoding];
    //NSData *userdata = [NSKeyedArchiver archivedDataWithRootObject:user];
    //NSLog(@"回傳的 userdata：%@",userdata);
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:url]];
	[request setHTTPMethod:@"POST"];
	
    // Set content-type
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    // Set Request Body
    [request setHTTPBody: userdata];
    // Now send a request and get Response
    NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil];
    // Log Response
    NSString *response = [[NSString alloc]initWithData:returnData encoding:NSUTF8StringEncoding];
    
    
	if([response compare:@"YES"]==NSOrderedSame)
		return YES;
	else
		return NO;
}
// FBSample logic
// handler for button click, logs sessions in or out
- (IBAction)buttonClickHandler:(id)sender {
    // get the app delegate so that we can access the session property
    SLAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];

    // this button's job is to flip-flop the session from open to closed
    if (appDelegate.session.isOpen) {
        // if a user logs out explicitly, we delete any cached token information, and next
        // time they run the applicaiton they will be presented with log in UX again; most
        // users will simply close the app or switch away, without logging out; this will
        // cause the implicit cached-token login to occur on next launch of the application
        [appDelegate.session closeAndClearTokenInformation];

    } else {
        if (appDelegate.session.state != FBSessionStateCreated) {
            // Create a new, logged out session.
            appDelegate.session = [[FBSession alloc] init];
        }

        // if the session isn't open, let's open it now and present the login UX to the user
        [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                         FBSessionState status,
                                                         NSError *error) {
            // and here we make sure to update our UX according to the new session state
            [self updateView];
        }];
    }
}

#pragma mark Template generated code

- (void)viewDidUnload
{
    //self.buttonLoginLogout = nil;
    //self.textNoteOrLink = nil;

    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark -

@end
