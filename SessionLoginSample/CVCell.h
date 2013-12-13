//
//  CVCell.h
//  CollectionViewExample
//
//  Created by Tim on 9/5/12.
//  Copyright (c) 2012 Charismatic Megafauna Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CVCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *cellImage;

@property (strong, nonatomic) IBOutlet UILabel *name;

- (id) initWithTitle:(NSString *) t initWithImage:(UIImage *) s ;
@end
