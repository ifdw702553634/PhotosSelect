//
//  DWPhotoSelectViewController.h
//  PhotoSelect
//
//  Created by mude on 2018/1/25.
//  Copyright © 2018年 mude. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DWPhotoSelectViewController : UIViewController

@property NSString *navTitle;

@property NSInteger allowSelect;//用于记录可以选择的照片数量

@property NSMutableArray<PHAsset *> *photoArr;
@property NSMutableArray<PHAsset *> *selectArr;

@end
