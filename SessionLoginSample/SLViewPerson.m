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

#import "SLViewPerson.h"
#import "SLAppDelegate.h"

@interface SLViewPerson () <UICollectionViewDelegate ,UICollectionViewDataSource >
{
    
}

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation SLViewPerson

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    NSURL *url = [[NSURL alloc]
                  initWithString:@"http://www.fofolove.me/jay/api.php?s=getUserInfo"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:nil error:nil];
    
    XMLParser *parser = [[XMLParser alloc] initWithData:data];
    result = [[NSArray alloc] initWithArray:parser.result];
    parser = nil;
    
    // Initialize recipe image array
    [self.view addSubview:self.collectionView];
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    NSLog(@"SLViewPerson");
}

#pragma mark Template generated code

- (void)viewDidUnload
{
    [super viewDidUnload];
}

// Implement the required data source methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return result.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSURL * imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=normal",[[result objectAtIndex:indexPath.row] objectForKey:@"uid"]]];
    NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
    recipeImageView.image = [UIImage imageWithData:imageData];
    cell.name.text=[[result objectAtIndex:indexPath.row] objectForKey:@"name"] ;
    return cell;
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
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    userId =[[result objectAtIndex:indexPath.row] objectForKey:@"uid"];
    [self performSegueWithIdentifier:@"personToDetail" sender:nil];
    
}
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"personToDetail"]) {
        // 取得目的頁面
        DetailViewController *detail = segue.destinationViewController;
        detail.uid = userId;
    }
    
}
#pragma mark -


@end
