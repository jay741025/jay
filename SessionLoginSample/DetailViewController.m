//
//  DetailViewController.m
//  RSSReader
//
//  Created by Eric Lin on 11/10/11.
//  Copyright (c) 2011年 EraSoft. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *picture;
@property (strong, nonatomic) IBOutlet UILabel *name;

@end

@implementation DetailViewController


@synthesize uid;


#pragma mark - Managing the detail item



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}
- (void)viewDidAppear:(BOOL)animated
{
    NSURL *url = [[NSURL alloc]
                  initWithString:[NSString stringWithFormat:@"http://www.fofolove.me/jay/api.php?s=userInfo&uid=%@",uid]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:nil error:nil];
    
    XMLParser *parser = [[XMLParser alloc] initWithData:data];
    result = [[NSArray alloc] initWithArray:parser.result];
    
    NSURL * imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",uid]];
   
    NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
    self.picture.image = [UIImage imageWithData:imageData];
    self.name.text =[[result objectAtIndex:0] objectForKey:@"name"];
    [super viewDidAppear:animated];
}
- (void)viewDidUnload
{
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


#pragma mark - Split view


@end
