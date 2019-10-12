# PickerViewController

滚轮视图控制器  
  
方便更换数据源  


```object-c
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
```
