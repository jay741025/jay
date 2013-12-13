#import "SLViewLogin.h"

#import "SLAppDelegate.h"

@interface SLViewLogin () <FBLoginViewDelegate>
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorLogin;

- (IBAction)joinFacebook:(id)sender;


- (void)updateView;
@end

@implementation SLViewLogin
@synthesize activityIndicatorLogin;

- (void) actIndicatorBegin {
    [activityIndicatorLogin startAnimating];
}

-(void) actIndicatorEnd {
    [activityIndicatorLogin stopAnimating];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    activityIndicatorLogin = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [activityIndicatorLogin setCenter:CGPointMake(12, 12)];
    [activityIndicatorLogin setHidesWhenStopped:YES];
    [activityIndicatorLogin setActivityIndicatorViewStyle: UIActivityIndicatorViewStyleWhite];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // Do any additional setup after loading the view, typically from a nib.
    FBLoginView *loginview = [[FBLoginView alloc] init];
    
    loginview.frame = CGRectOffset(loginview.frame, 25, 100);
#ifdef __IPHONE_7_0
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        loginview.frame = CGRectOffset(loginview.frame, 25, 100);
    }
#endif
#endif
#endif
    loginview.delegate = self;
    
    [self.view addSubview:loginview];
    [loginview sizeToFit];
    [loginview setHidden:NO];
        
    [self updateView];
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
    
}
- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
    [loginView setHidden:YES];
    [activityIndicatorLogin startAnimating];
}
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    NSLog(@"backLogin");
    [loginView setHidden:YES];
    [self performSegueWithIdentifier:@"backLogin" sender:nil];
}
// FBSample logic
// main helper method to update the UI to reflect the current state of the session.
- (IBAction)joinFacebook:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.facebook.com"]];
}

- (void)updateView {
    // get the app delegate, so that we can reference the session property
    SLAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
        if (appDelegate.session.isOpen) {
        // valid account UI is shown whenever the session is open
            NSLog(@"backLogin");
            [self performSegueWithIdentifier:@"backLogin" sender:nil];
        } else {
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
