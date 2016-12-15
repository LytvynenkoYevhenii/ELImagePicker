//
//  ELPhotoPreviewViewController.h
//  ITTSellerPro
//
//  Created by Lytvynenko Yevhenii on 15.11.16.
//  Copyright © 2016 itteam.io. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ELPhotoPreviewViewControllerDelegate;

@interface ELPhotoPreviewViewController : UIViewController

//Delegate
@property(weak, nonatomic) id <ELPhotoPreviewViewControllerDelegate> delegate;

//Data source
@property (strong, nonatomic)NSArray <UIImage *>*sourceArray;
@property (nonatomic) NSInteger pageIndex;

//Views
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

//Actions
- (IBAction)actionCancel:(UIButton *)sender;
- (IBAction)actionDone:(UIButton *)sender;
- (IBAction)actionCrop:(UIButton *)sender;

@end

@protocol ELPhotoPreviewViewControllerDelegate <NSObject>

- (void)photoPreviewViewController:(ELPhotoPreviewViewController *)controller finishWithImages:(NSArray <UIImage *>*)images;

@end
