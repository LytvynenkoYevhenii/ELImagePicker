//
//  ELImagePicker.h
//  ITTSellerPro
//
//  Created by Lytvynenko Yevhenii on 15.11.16.
//  Copyright © 2016 itteam.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ELLibCollectionViewController.h"

@interface ELImagePicker : NSObject

-(id) initWithPresentingController:(UIViewController *)controller;
- (void) showPickerWithDataBlock:(ResultDataBlock)block;

@end
