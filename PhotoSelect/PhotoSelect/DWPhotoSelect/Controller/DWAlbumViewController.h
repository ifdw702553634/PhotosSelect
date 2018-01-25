//
//  DWAlbumViewController.h
//  PhotoSelect
//
//  Created by mude on 2018/1/25.
//  Copyright © 2018年 mude. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface DWAlbumViewController : UIViewController

@property NSArray<PHAsset *>  *currentPhotoArr;

@property NSInteger maximumImg;//可以上传的照片最大张数
@property NSInteger allowSelect;//用于记录可以选择的照片数量

@end
