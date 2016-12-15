//
//  ViewController.m
//  ElImagePickerExample
//
//  Created by Lytvynenko Yevhenii on 15.12.16.
//  Copyright © 2016 Lytvynenko Yevhenii. All rights reserved.
//

#import "ViewController.h"
#import "ELImagePicker.h"
#import "ELCollectionViewCell.h"

@interface ViewController ()

@property (strong, nonatomic) NSArray *imagesArray;

@end

@implementation ViewController

static NSString * cellNibName = @"ELCollectionViewCell";
static NSString * cellIdentifier = @"Cell";


#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Register nib
    UINib *cellNib = [UINib nibWithNibName:cellNibName bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:cellIdentifier];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)actionSetNewImageSet:(UIButton *)sender
{
    ELImagePicker *imagePicker = [[ELImagePicker alloc]initWithPresentingController:self];
    [imagePicker showPickerWithDataBlock:^(NSArray *dataArray) {
        if ([dataArray count]) {
            self.imagesArray = dataArray;
            [self.collectionView reloadData];
        }
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.imagesArray count];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ELCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.imageView.image = [self.imagesArray objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - <>

@end
