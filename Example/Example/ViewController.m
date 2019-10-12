//
//  ViewController.m
//  Example
//
//  Created by 刘鹏i on 2019/10/12.
//  Copyright © 2019 Liupeng. All rights reserved.
//

#import "ViewController.h"
#import "PickerViewController.h"

@interface ViewController ()
@property (nonatomic, strong) NSArray *arrValue;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)clickedButton:(id)sender {
    PickerViewController *vc = [[PickerViewController alloc] init];
    vc.type = PickerViewType_OrderTime;
    vc.values = _arrValue;
    __weak typeof(self) weakSelf = self;
    vc.selectBlock = ^(NSArray<NSString *> * _Nonnull values) {
        weakSelf.arrValue = values;
        NSLog(@"==%@", values);
    };
    
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:vc animated:NO completion:nil];
}

@end
