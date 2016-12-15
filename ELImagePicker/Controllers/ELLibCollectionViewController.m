//
//  LibCollectionViewController.m
//  ITTSellerPro
//
//  Created by Lytvynenko Yevhenii on 15.11.16.
//  Copyright © 2016 itteam.io. All rights reserved.
//

#import "ELLibCollectionViewController.h"
#import "ELPhotoPickerCollectionViewCell.h"
#import "ELPhotoPreviewViewController.h"

#import <Photos/Photos.h>

@interface ELLibCollectionViewController ()<ELPhotoPreviewViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray <NSIndexPath *>*selectedIndexPaths;
@property (nonatomic)CGSize cellSize;
@property (strong, nonatomic)PHFetchResult *result;

@end

@implementation ELLibCollectionViewController

static NSString * const reuseIdentifier                     = @"Cell";
static NSString * const cellNibName                         = @"ELPhotoPickerCollectionViewCell";
static NSString * const previewViewControllerStoryboardID   = @"ELPhotoPreviewViewController";

static CGFloat      const spaceBetweenItems = 10.f;
static NSInteger    const cellsInRow        = 5;
static CGFloat      const sectionInset      = 10.f;

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    //Cell size init
    self.cellSize = CGSizeZero;
    
    //Arrays init
    self.selectedIndexPaths = [NSMutableArray array];
        
    //Register NIB for cell
    UINib *cellNib = [UINib nibWithNibName:cellNibName bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:reuseIdentifier];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    PHCachingImageManager *manager = (PHCachingImageManager *)[PHCachingImageManager defaultManager];
    
    [manager startCachingImagesForAssets:(NSArray <PHAsset *>*)[self result]
                              targetSize:self.cellSize
                             contentMode:PHImageContentModeAspectFit
                                 options:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.selectedIndexPaths removeAllObjects];
    PHCachingImageManager *manager = (PHCachingImageManager *)[PHCachingImageManager defaultManager];
    
    [manager stopCachingImagesForAllAssets];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Accessor

- (CGSize)cellSize
{
    if (CGSizeEqualToSize(_cellSize, CGSizeZero)) {
        //Cell size
        CGFloat widthInPortrait =
        MIN(CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
        
        CGFloat cellSide =
        (widthInPortrait - spaceBetweenItems * (cellsInRow - 1) - sectionInset * 2) / cellsInRow;
        
        _cellSize = CGSizeMake(cellSide, cellSide);
    }
    return _cellSize;
}

- (PHFetchResult *)result
{
    if (!_result) {
        _result = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:nil];
    }
    return _result;
}

#pragma mark - Actions

- (IBAction)actionCancel:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionChangeSelectionMode:(UIButton *)sender
{
    self.singleSelection = !self.singleSelection;
    
    NSString *title = nil;
    
    if (self.isSingleSelection) {
        title = NSLocalizedString(@"Group selection", nil);
        self.doneButton.hidden = YES;
        [self.selectedIndexPaths removeAllObjects];
        
    } else {
        title = NSLocalizedString(@"Single selection", nil);
        self.doneButton.hidden = NO;
    }
    
    [sender setTitle:title forState:UIControlStateNormal];
    
    [self.collectionView reloadData];
}

- (IBAction)actionDone:(UIButton *)sender
{
    [self actionOpenPreviewControllerForCellsAtIndexPaths:self.selectedIndexPaths];
}

- (void) actionOpenPreviewControllerForCellsAtIndexPaths:(NSArray <NSIndexPath *>*)indexPaths
{
    NSMutableArray *assetsTempArray = [NSMutableArray array];
    
    for (NSIndexPath *indexPath in self.selectedIndexPaths) {
        PHAsset *asset = [self.result objectAtIndex:indexPath.row];
        [assetsTempArray addObject:asset];
    }
    
    NSArray *images = [self getHighQualityPhotosFromAssets:assetsTempArray];
    
    ELPhotoPreviewViewController * previewViewController =
    [self.storyboard instantiateViewControllerWithIdentifier:previewViewControllerStoryboardID];
    
    previewViewController.sourceArray = images;
    previewViewController.pageIndex = 0;
    previewViewController.delegate = self;
    
    [self presentViewController:previewViewController animated:YES completion:nil];
}

#pragma mark - Private methods

- (NSArray <UIImage *>*) getHighQualityPhotosFromAssets:(NSArray<PHAsset *>*)assets
{
    PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc] init];
    requestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
    requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    requestOptions.synchronous = YES;
    
    PHImageManager *manager = [PHImageManager defaultManager];
    
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:[assets count]];
    
    // assets contains PHAsset objects.
    
    __block UIImage *img;
    for (PHAsset *asset in assets) {
        [manager requestImageForAsset:asset
                           targetSize:PHImageManagerMaximumSize
                          contentMode:PHImageContentModeDefault
                              options:requestOptions
                        resultHandler:^void(UIImage *image, NSDictionary *info) {
                            img = image;
                            [images addObject:img];
                        }];
    }
    return [NSArray arrayWithArray:images];
}

- (void)configureCell:(ELPhotoPickerCollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    PHCachingImageManager *manager = (PHCachingImageManager *)[PHCachingImageManager defaultManager];
    
    PHAsset *currentAsset = [self.result objectAtIndex:indexPath.row];
    
    [manager requestImageForAsset:currentAsset targetSize:self.cellSize
                      contentMode:PHImageContentModeAspectFit
                          options:nil
                    resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                        cell.mainImageView.image = result;
                    }];
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.result count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ELPhotoPickerCollectionViewCell *cell =
    (ELPhotoPickerCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

#pragma mark - <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.selectedIndexPaths containsObject:indexPath]) {
        [(ELPhotoPickerCollectionViewCell *)cell showCheckerAnimated:NO];
        ((ELPhotoPickerCollectionViewCell *)cell).mainImageView.alpha = 0.6f;
    } else {
        [(ELPhotoPickerCollectionViewCell *)cell hideCheckerAnimated:NO];
        ((ELPhotoPickerCollectionViewCell *)cell).mainImageView.alpha = 1.f;
    }
}

//Selection config

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
    if (self.isSingleSelection) {
        [self.selectedIndexPaths addObject:indexPath];
        [self actionOpenPreviewControllerForCellsAtIndexPaths:self.selectedIndexPaths];
        return;
    }
    
    if ([self.selectedIndexPaths containsObject:indexPath]) {
        [self.selectedIndexPaths removeObject:indexPath];

    } else {
        [self.selectedIndexPaths addObject:indexPath];
    }
    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    
    //Change done button state depend on selected items count
    
    self.doneButton.enabled = [self.selectedIndexPaths count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cellSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(2 * sectionInset, sectionInset, 2 * sectionInset, sectionInset); // top, left, bottom, right
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return spaceBetweenItems;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return spaceBetweenItems;
}

#pragma mark - <ELPhotoPreviewViewControllerDelegate>

- (void)photoPreviewViewController:(ELPhotoPreviewViewController *)controller finishWithImages:(NSArray <UIImage *>*)images
{
    self.resultBlock(images);
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)photoPreviewViewControllerDidCancel:(ELPhotoPreviewViewController *)controller
{
    [self.collectionView reloadData];
}

@end
