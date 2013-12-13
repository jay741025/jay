//
//  CVCell.m
//  CollectionViewExample
//
//  Created by Tim on 9/5/12.
//  Copyright (c) 2012 Charismatic Megafauna Ltd. All rights reserved.
//

#import "CVCell.h"

@implementation CVCell

@synthesize name = _name ,cellImage=_cellImage;

- (id) initWithTitle:(NSString *) t initWithImage:(UIImage *) s
{
    self = [super init];
    if(self){
        _name.text = t;
        _cellImage.image = s;
        // self.coordinate = c /* !This is readonly ! */
    }
    return self;
}
@end
