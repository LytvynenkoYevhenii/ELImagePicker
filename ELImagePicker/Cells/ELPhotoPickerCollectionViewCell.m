//
//  ELPhotoPickerCollectionViewCell.m
//  ITTSellerPro
//
//  Created by Lytvynenko Yevhenii on 15.11.16.
//  Copyright © 2016 itteam.io. All rights reserved.
//

#import "ELPhotoPickerCollectionViewCell.h"

@implementation ELPhotoPickerCollectionViewCell

#pragma mark - Show / hide checker view

- (void)showCheckerAnimated:(BOOL)animated
{
    if (animated) {
        self.checkerImageView.alpha = 0.1f;
        self.checkerImageView.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
        self.checkerImageView.hidden = NO;
        [UIView animateWithDuration:0.3f animations:^{
            self.checkerImageView.transform = CGAffineTransformIdentity;
            self.checkerImageView.alpha = 1.f;
        }];
    } else {
        self.checkerImageView.hidden = NO;
    }
}

- (void)hideCheckerAnimated:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:0.3f animations:^{
            self.checkerImageView.alpha = 0.1f;
            self.checkerImageView.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
        } completion:^(BOOL finished) {
            self.checkerImageView.hidden = YES;
            self.checkerImageView.transform = CGAffineTransformIdentity;
            self.checkerImageView.alpha = 1.f;
        }];
    } else {
        self.checkerImageView.hidden = YES;
    }
}


@end
