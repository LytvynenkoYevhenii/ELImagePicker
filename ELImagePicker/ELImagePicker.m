//
//  ELImagePicker.m
//  ITTSellerPro
//
//  Created by Lytvynenko Yevhenii on 15.11.16.
//  Copyright © 2016 itteam.io. All rights reserved.
//

#import "ELImagePicker.h"
#import <UIKit/UIKit.h>
static NSString* const kELImagePicker = @"ELImagePicker";
@interface ELImagePicker()
@property (nonatomic, strong) UIViewController *presentingViewController;
@end

@implementation ELImagePicker

#pragma mark - Initialization

-(id) initWithPresentingController:(UIViewController *)controller
{
    self = [super init];
    if (self) {
        self.presentingViewController = controller;
    }
    return self;
}

#pragma mark - Show picker

-(void)showPickerWithDataBlock:(ResultDataBlock)block
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:kELImagePicker bundle:nil];//это лучше заменить на константы
    ELLibCollectionViewController *libController = (ELLibCollectionViewController *)[storyBoard instantiateViewControllerWithIdentifier:@"ELLibCollectionViewController"]; // тут тоже по примеру сделаешь
    libController.singleSelection = YES;
    libController.resultBlock = block;
    [self.presentingViewController presentViewController:libController animated:YES completion:nil];
}


@end
