//
//  DetailViewController.h
//  RSSReader
//
//  Created by Eric Lin on 11/10/11.
//  Copyright (c) 2011年 EraSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMLParser.h"
@interface DetailViewController : UIViewController
{
@private
    NSArray *result;
}
@property (nonatomic,retain) NSString *uid;

@end
