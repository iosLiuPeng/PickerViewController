//
//  PickerViewController.h
//  NetCar
//
//  Created by 刘鹏i on 2019/10/11.
//  Copyright © 2019 Agrhino. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PickerViewType) {
    PickerViewType_OrderTime,
    PickerViewType_Age,
};

NS_ASSUME_NONNULL_BEGIN

@interface PickerViewController : UIViewController
@property (nonatomic, assign) PickerViewType type;

/* 传入的 */
@property (nonatomic, copy) NSArray<NSString *> *values;
// 回调
@property (nonatomic, copy) void(^selectBlock)(NSArray<NSString *> *values);
@end

NS_ASSUME_NONNULL_END
