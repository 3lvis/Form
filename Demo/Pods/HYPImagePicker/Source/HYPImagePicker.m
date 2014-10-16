//
//  HYPImagePicker.m
//
//  Created by Hyper AS. on 8/17/14.
//  Copyright (c) 2014 Hyper AS. All rights reserved.
//

#import "HYPImagePicker.h"

@interface HYPImagePicker () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, copy) NSString *caption;

@end

@implementation HYPImagePicker

- (instancetype)initForViewController:(UIViewController *)viewController usingCaption:(NSString *)caption
{
    self = [super init];
    if (!self) return nil;

    _viewController = viewController;
    _caption = caption;

    return self;
}

#pragma mark - Camera

- (void)invokeCamera
{
    if (!self.viewController) return;

    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:self.caption
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Take photo", @"Choose Existing Photo", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;

    [actionSheet showInView:self.viewController.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self takePhoto];
            break;
        case 1:
            [self chooseFromLibrary];
            break;
    }
}

- (void)takePhoto
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];

    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    imagePickerController.delegate = self;

    [self.viewController presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)chooseFromLibrary
{
	UIImagePickerController *imagePickerController= [[UIImagePickerController alloc] init];
	imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    imagePickerController.delegate = self;

    [self.viewController presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];

    if (image && [self.delegate respondsToSelector:@selector(imagePicker:didPickedImage:)]) {
        [self.delegate imagePicker:self didPickedImage:image];
    }

    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
