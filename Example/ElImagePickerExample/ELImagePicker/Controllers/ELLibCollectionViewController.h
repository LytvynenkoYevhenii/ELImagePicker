//
//  LibCollectionViewController.h
//  ITTSellerPro
//
//  Created by Lytvynenko Yevhenii on 15.11.16.
//  Copyright © 2016 itteam.io. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ResultDataBlock)(NSArray *dataArray);

@interface ELLibCollectionViewController : UIViewController

//Completion block returns array with images
@property (copy, nonatomic)ResultDataBlock resultBlock;

//IBOutlets
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

//Switch params
@property (nonatomic, getter=isSingleSelection) BOOL singleSelection;

//Actions
- (IBAction)actionCancel:(UIButton *)sender;
- (IBAction)actionChangeSelectionMode:(UIButton *)sender;
- (IBAction)actionDone:(UIButton *)sender;

@end
