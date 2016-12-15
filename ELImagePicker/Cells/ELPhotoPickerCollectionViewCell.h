//
//  ELPhotoPickerCollectionViewCell.h
//  ITTSellerPro
//
//  Created by Lytvynenko Yevhenii on 15.11.16.
//  Copyright © 2016 itteam.io. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ELPhotoPickerCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UIImageView *checkerImageView;

//Edit image view presenting
- (void)showCheckerAnimated:(BOOL)animated;
- (void)hideCheckerAnimated:(BOOL)animated;

@end
