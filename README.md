# ELImagePicker
Custom image picker with using Photo framework and PECropper

For correctly using you must implement in your view controller:

#import "ELImagePicker.h"

    ELImagePicker *imagePicker = [[ELImagePicker alloc]initWithPresentingController:self];
    [imagePicker showPickerWithDataBlock:^(NSArray *dataArray) {
        if ([dataArray count]) {
           //Data array contains fetched images
        }
    }];

