//
//  XWImagePickerSheet.m
//  XWPublishDemo
//
//  Created by 邱学伟 on 16/4/15.
//  Copyright © 2016年 邱学伟. All rights reserved.
//

#import "XWImagePickerSheet.h"

@interface XWImagePickerSheet ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation XWImagePickerSheet
-(instancetype)init{
    self = [super init];
    if (self) {
        if (!_arrSelected) {
            self.arrSelected = [NSMutableArray array];
        }
    }
    return self;
}
//显示选择照片提示Sheet
-(void)showImgPickerActionSheetInView:(UIViewController *)controller{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"选择照片" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *actionCamera = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"拍照"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (!imaPic) {
            imaPic = [[UIImagePickerController alloc] init];
        }
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imaPic.sourceType = UIImagePickerControllerSourceTypeCamera;
            imaPic.delegate = self;
            [viewController presentViewController:imaPic animated:NO completion:nil];
        }

    }];
    UIAlertAction *actionAlbum = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"相册"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self loadImgDataAndShowAllGroup];
    }];
    [alertController addAction:actionCancel];
    [alertController addAction:actionCamera];
    [alertController addAction:actionAlbum];
    viewController = controller;
    [viewController presentViewController:alertController animated:YES completion:nil];

}
#pragma mark - 加载照片数据
- (void)loadImgDataAndShowAllGroup{
    if (!_arrSelected) {
        self.arrSelected = [NSMutableArray array];
    }
    [[MImaLibTool shareMImaLibTool] getAllGroupWithArrObj:^(NSArray *arrObj) {
        if (arrObj && arrObj.count > 0) {
            self.arrGroup = arrObj;
            if ( self.arrGroup.count > 0) {
                MShowAllGroup *svc = [[MShowAllGroup alloc] initWithArrGroup:self.arrGroup arrSelected:self.arrSelected];
                svc.delegate = self;
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:svc];
                if (_arrSelected) {
                    svc.arrSeleted = _arrSelected;
                    svc.mvc.arrSelected = _arrSelected;
                }
                svc.maxCout = _maxCount;
                [viewController presentViewController:nav animated:YES completion:nil];
            }
        }
    }];
}
#pragma mark - 拍照获得数据
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *theImage = nil;
    // 判断，图片是否允许修改
    if ([picker allowsEditing]){
        //获取用户编辑之后的图像
        theImage = [info objectForKey:UIImagePickerControllerEditedImage];
    } else {
        // 照片的元数据参数
        theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    if (theImage) {
        //保存图片到相册中
        MImaLibTool *imgLibTool = [MImaLibTool shareMImaLibTool];
        [imgLibTool.lib writeImageToSavedPhotosAlbum:[theImage CGImage] orientation:(ALAssetOrientation)[theImage imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
            if (error) {
            } else {
                
                //获取图片路径
                [imgLibTool.lib assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                    if (asset) {
                        
                        [_arrSelected addObject:asset];
                        [self finishSelectImg];
                        [picker dismissViewControllerAnimated:NO completion:nil];
                    }
                } failureBlock:^(NSError *error) {
                    
                }];
            }
        }];
    }
}
//#pragma mark - 完成选择后返回的图片Array(ALAsset*)
//- (void)finishSelectImg{
//    //正方形缩略图
//    NSMutableArray *thumbnailImgArr = [NSMutableArray array];
//    for (ALAsset *set in _arrSelected) {
//        CGImageRef cgImg = [set thumbnail];
//        UIImage* image = [UIImage imageWithCGImage: cgImg];
//        [thumbnailImgArr addObject:image];
//    }
//    if (self.delegate && [self.delegate respondsToSelector:@selector(getSelectImageWithALAssetArray:thumbnailImageArray:)]) {        
//        [self.delegate getSelectImageWithALAssetArray:_arrSelected thumbnailImageArray:thumbnailImgArr];
//    }
//}


#pragma mark - ALAsset ?
/*
 获得的ALAsset对象就是相片对象：其中有相片的缩略图，全屏图，高清图，url等属性。
 
 ALAsset *result = [assets objectAtIndex:index];
 
 获取url：
 
 String类型：
 
 NSString *url = [[[result
 
 defaultRepresentation]url]description];
 
 URL类型：
 
 NSURL *url = [[result defaultRepresentation]url];
 
 获取缩略图：
 
 CGImageRef  ref = [result thumbnail];
 
 UIImage *img = [[UIImage alloc]initWithCGImage:ref];
 
 获取全屏相片：
 
 CGImageRef ref = [[result  defaultRepresentation]fullScreenImage];
 
 UIImage *img = [[UIImage alloc]initWithCGImage:ref];
 
 获取高清相片：
 
 CGImageRef ref = [[result  defaultRepresentation]fullResolutionImage];
 
 UIImage *img = [[UIImage alloc]initWithCGImage:ref];
 
 
 */


#pragma mark - 完成选择后返回的图片Array(ALAsset*)
- (void)finishSelectImg{
    //正方形缩略图
    NSMutableArray *thumbnailImgArr = [NSMutableArray array];
    
    for (ALAsset *set in _arrSelected) {
        //        ..之间的上传的是原图 经过压缩
        //        ..
        UIImage *img = [UIImage imageWithCGImage:set.defaultRepresentation.fullResolutionImage
                                           scale:set.defaultRepresentation.scale
                                     orientation:(UIImageOrientation)set.defaultRepresentation.orientation];
        //        NSData *imageData = UIImageJPEGRepresentation(img, 0.5);
        //        [_bigImgDataArray addObject:imageData];
        
        //压缩
        NSStringFromCGSize(img.size);
        CGSize imageSize ;
        //        NSData *data ;
        //        获取图片文件大小 多少KB
        NSData * imageData = UIImageJPEGRepresentation(img,1);
        //         length = [imageData length]/1024;
        if ([imageData length]/1000 > 2500 ) {
            imageSize.height = img.size.height/4 ;
            imageSize.width = img.size.width/4 ;
            //            data = UIImageJPEGRepresentation(img,0.5);
        }else if (2500 > [imageData length]/1000 || [imageData length]/1000 > 1500 ) {
            imageSize.height = img.size.height/2 ;
            imageSize.width = img.size.width/2 ;
            //            data = UIImageJPEGRepresentation(img,0.5);
        }
        //        else if (1500 > [imageData length]/1000 || [imageData length]/1000 > 1000 ) {
        //            imageSize.height = img.size.height/2 ;
        //            imageSize.width = img.size.width/2 ;
        ////            data = UIImageJPEGRepresentation(img,0.5);
        //        }
        //        else if (1000 > [imageData length]/1000 && [imageData length]/1000 > 500 ) {
        //            imageSize.height = img.size.height/2 ;
        //            imageSize.width = img.size.width/2 ;
        //
        //        }
        else {
            imageSize.height = img.size.height ;
            imageSize.width = img.size.width ;
            //            data = UIImageJPEGRepresentation(img,0.5);
        }
        //        UIImage  *image = [UIImage imageWithData:data];
        UIImage *newImage = [self imageWithImage:img scaledToSize:imageSize];
        //        ..
        
        
        
        //        下面两句代码只是显示正方形缩略图
        //        CGImageRef cgImg = [set thumbnail];
        //        UIImage* image = [UIImage imageWithCGImage: cgImg];
        [thumbnailImgArr addObject:newImage];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(getSelectImageWithALAssetArray:thumbnailImageArray:)]) {
        [self.delegate getSelectImageWithALAssetArray:_arrSelected thumbnailImageArray:thumbnailImgArr];
    }
}

#pragma mark - 完成选择后－对图片尺寸进行压缩--
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
