//
//  ELPhotoPreviewViewController.m
//  ITTSellerPro
//
//  Created by Lytvynenko Yevhenii on 15.11.16.
//  Copyright © 2016 itteam.io. All rights reserved.
//

#import "ELPhotoPreviewViewController.h"
#import "PECropViewController.h"

@interface ELPhotoPreviewViewController ()<PECropViewControllerDelegate>

@property (nonatomic, getter=isFirstLoad) BOOL firstLoad;
@property (strong, nonatomic) NSMutableArray *imageViews;

@end

@implementation ELPhotoPreviewViewController

#pragma mark - Life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Arrays init
    self.imageViews = [NSMutableArray array];
    
    //First load
    self.firstLoad = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.isFirstLoad) {
        [self setImages:self.sourceArray ontoScrollView:self.scrollView];
        self.firstLoad = NO;
    }
}

#pragma mark - Actions

- (IBAction)actionCancel:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionDone:(UIButton *)sender
{
    [self.delegate photoPreviewViewController:self finishWithImages:self.sourceArray];
}

- (IBAction)actionCrop:(UIButton *)sender
{
    PECropViewController *cropper = [[PECropViewController alloc] init];
    cropper.delegate = self;
    cropper.rotationEnabled = NO;
    cropper.image = [self currentImage];
    cropper.keepingCropAspectRatio = YES;
    cropper.toolbarHidden = YES;
    
    UIImage *image = [self currentImage];
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGFloat length = MIN(width, height);
    cropper.imageCropRect = CGRectMake((width - length) / 2,
                                       (height - length) / 2,
                                       length,
                                       length);
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:cropper];
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - Private methods

- (void)setImages:(NSArray <UIImage *>*)images ontoScrollView:(UIScrollView *)scrollView
{
    CGFloat x = 0;
    
    for (UIImage *image in self.sourceArray) {
        
        CGRect imageViewFrame =
        CGRectMake(x, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.scrollView.frame));
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:imageViewFrame];
        
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = image;
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
        
        [scrollView addSubview:imageView];
        [self.imageViews addObject:imageView];
        
        x = x + CGRectGetWidth(self.view.frame);
        
        scrollView.contentSize = CGSizeMake(x, CGRectGetHeight(self.scrollView.frame));
    }
    scrollView.contentOffset =
    CGPointMake(self.pageIndex * CGRectGetWidth(scrollView.frame), scrollView.contentOffset.y);
}

- (void)reverseContentSizeAndOffsetForScrollView:(UIScrollView *)scrollView
{
    CGFloat mainViewHeight = CGRectGetHeight(self.view.frame);
    
    CGFloat height = CGRectGetHeight(scrollView.frame);
    CGFloat width  = CGRectGetWidth(scrollView.frame);
    
    NSInteger currentPageIndex = scrollView.contentOffset.x / width;
    
    CGFloat diffHeight = mainViewHeight - height;
    
    scrollView.contentSize = CGSizeMake(mainViewHeight * [self.sourceArray count], width - diffHeight);
    scrollView.contentOffset = CGPointMake(currentPageIndex *mainViewHeight, 0);
}


- (UIImage *)currentImage
{
    CGFloat width  = CGRectGetWidth(self.scrollView.frame);
    
    NSInteger currentPageIndex = self.scrollView.contentOffset.x / width;
    
    return [self.sourceArray objectAtIndex:currentPageIndex];
}

#pragma mark <PECropViewControllerDelegate>

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage
{
    NSInteger index = [self.sourceArray indexOfObject: [self currentImage]];

    UIImageView *currentImageView = [self.imageViews objectAtIndex:index];
    
    currentImageView.image = croppedImage;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.sourceArray];
    
    [tempArray replaceObjectAtIndex:index withObject:croppedImage];
    
    self.sourceArray = tempArray;
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Rotation

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [self reverseContentSizeAndOffsetForScrollView:self.scrollView];
    [self.scrollView setNeedsDisplay];
}

@end
