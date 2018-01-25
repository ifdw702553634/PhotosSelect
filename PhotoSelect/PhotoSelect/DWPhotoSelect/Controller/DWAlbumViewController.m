//
//  DWAlbumViewController.m
//  PhotoSelect
//
//  Created by mude on 2018/1/25.
//  Copyright © 2018年 mude. All rights reserved.
//

#import "DWAlbumViewController.h"
#import "AlbumTableViewCell.h"
#import "DWPhotoSelectViewController.h"

static NSString *kAlbumTableViewCell = @"kAlbumTableViewCell";

@interface DWAlbumViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *dataArr;
}
@property (strong, nonatomic) UITableView *albumTableView;

@end

@implementation DWAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelClick)];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.hidesBackButton =YES;
    self.title = @"相册";
    
    [self prepareView];
    [self loadData];
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                //主线程刷新tableView
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self loadData];
                });
            }
        }];
    }
    //相册权限1
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted ||
        status == PHAuthorizationStatusDenied) {
        //无权限 引导去开启
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"该操作需要访问您的照片" preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                }];
            }
        }]];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
}
-(void)cancelClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)prepareView{
    _albumTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    _albumTableView.delegate = self;
    _albumTableView.dataSource = self;
    _albumTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_albumTableView];
}
-(void)loadData{
    
    dataArr = [[NSMutableArray alloc] init];
    // 列出所有相册智能相册
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    [smartAlbums enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection, NSUInteger idx, BOOL *stop) {
        NSArray *arr = [self getAssetsInAssetCollection:collection ascending:YES];
        if(arr.count != 0){
            __block UIImage *img = nil;
            [self enumerateAssetsWithCompletionBlock:^(UIImage *image) {
                img = image;
                NSDictionary *dic = @{@"albumTitle":(collection.localizedTitle == nil)?@"":collection.localizedTitle,@"photoCount":@(arr.count),@"firstPhoto":(img == nil)?[UIImage imageNamed:@"placeholder"]:img,@"photoArr":arr};
                [dataArr addObject:dic];
            } inAssetCollection:collection original:YES];
        }
    }];
    // 列出所有用户创建的相册
    PHFetchResult *userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    [userAlbums enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *arr = [self getAssetsInAssetCollection:collection ascending:YES];
        if(arr.count != 0){
            __block UIImage *img = nil;
            [self enumerateAssetsWithCompletionBlock:^(UIImage *image) {
                img = image;
                NSDictionary *dic = @{@"albumTitle":(collection.localizedTitle == nil)?@"":collection.localizedTitle,@"photoCount":@(arr.count),@"firstPhoto":(img == nil)?[UIImage imageNamed:@"placeholder"]:img,@"photoArr":arr};
                [dataArr addObject:dic];
            } inAssetCollection:collection original:YES];
        }
    }];
    DBG(@"%@",dataArr);
    [self.albumTableView reloadData];
}

#pragma mark - 获取指定相册内的所有图片
- (NSArray<PHAsset *> *)getAssetsInAssetCollection:(PHAssetCollection *)assetCollection ascending:(BOOL)ascending
{
    NSMutableArray<PHAsset *> *arr = [NSMutableArray array];
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[PHAsset class]]) {
            [arr addObject:obj];//这个obj即PHAsset对象
        }
    }];
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;
    PHCachingImageManager *cachingImage = [[PHCachingImageManager alloc] init];
    [cachingImage startCachingImagesForAssets:arr
                                   targetSize:PHImageManagerMaximumSize
                                  contentMode:PHImageContentModeDefault
                                      options:options];
    return arr;
}

- (void)enumerateAssetsWithCompletionBlock:(void (^)(UIImage *image))completionBlock inAssetCollection:(PHAssetCollection *)assetCollection original:(BOOL)original
{
    __block UIImage *image;
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;
    // 获得某个相簿中的所有PHAsset对象
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    PHAsset *asset = assets[0];
    // 是否要原图
    CGSize size = CGSizeMake(180, 180);
    // 从asset中获得图片
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];
        //设置BOOL判断，确认返回高清照片
        if (downloadFinined) {
            if (result != nil) {
                image = result;
                completionBlock(image);
            }else{
                image = [UIImage imageNamed:@"placeholder"];
                completionBlock(image);
            }
        }
    }];
}

#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return 100;
    }else{
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AlbumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kAlbumTableViewCell];
    if (cell == nil) {
        //单元格样式设置为UITableViewCellStyleDefault
        cell = [[AlbumTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kAlbumTableViewCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.firstPhoto.image = dataArr[indexPath.row][@"firstPhoto"];
    cell.albumName.text = dataArr[indexPath.row][@"albumTitle"];
    cell.albumNum.text = [NSString stringWithFormat:@"%@",dataArr[indexPath.row][@"photoCount"]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DWPhotoSelectViewController *vc = [[DWPhotoSelectViewController alloc] init];
    vc.navTitle = dataArr[indexPath.row][@"albumTitle"];
    vc.photoArr = [dataArr[indexPath.row][@"photoArr"] mutableCopy];
    vc.selectArr = [_currentPhotoArr mutableCopy];
    vc.allowSelect = _allowSelect;
    [self.navigationController pushViewController:vc animated:YES];
}

//设置cell分割线做对齐
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
@end

