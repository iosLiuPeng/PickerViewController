//
//  PickerViewController.m
//  NetCar
//
//  Created by 刘鹏i on 2019/10/11.
//  Copyright © 2019 Agrhino. All rights reserved.
//

#import "PickerViewController.h"

@interface PickerViewController ()
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) IBOutlet UIView *viewBottom;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;
@property (strong, nonatomic) IBOutlet UIButton *btnOk;

@property (nonatomic, strong) NSMutableArray<NSArray *> *arrDataSource;///< 数据源
@property (nonatomic, strong) NSMutableArray<NSNumber *> *arrSelectIndex;///< 选择的序号
@property (nonatomic, strong) NSDateComponents *todayComp;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lytContentY;
@end

static NSInteger maxYears = 100;

@implementation PickerViewController
#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
        
    [self viewConfig];
    
    [self dataConfig];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self show];
}

#pragma mark - Subjoin
- (void)viewConfig
{
    _lytContentY.active = NO;
}

- (void)dataConfig
{
    _arrDataSource = [[NSMutableArray alloc] init];
    _arrSelectIndex = [[NSMutableArray alloc] init];
    _todayComp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
    
    // 初始化数据源
    switch (_type) {
        case PickerViewType_OrderTime: {
            NSMutableArray *muarr = [[NSMutableArray alloc] init];
            [muarr addObject:@"全部"];
            
            for (NSInteger i = _todayComp.year; i >= 2019 ; i--) {
                [muarr addObject:[NSString stringWithFormat:@"%ld", (long)i]];
            }
            [_arrDataSource addObject:[muarr copy]];
            
            NSArray *arrMonth = @[@"12", @"11", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2", @"1"];
            [_arrDataSource addObject:arrMonth];
        }
            break;
        case PickerViewType_Age: {
            NSMutableArray *muarr = [NSMutableArray arrayWithCapacity:maxYears];
            for (NSInteger i = maxYears; i > 0; i--) {
                [muarr addObject:[NSString stringWithFormat:@"%ld", (long)i]];
            }
            [_arrDataSource addObject:[muarr copy]];
        }
            break;
        default:
            break;
    }
    
    // 初始位置
    for (NSInteger i = 0; i < _arrDataSource.count; i++) {
        NSArray *arrTitle = _arrDataSource[i];
        
        NSInteger index = NSNotFound;
        if (_values.count > i) {
            NSString *value = _values[i];
            index = [arrTitle indexOfObject:value];
        }
        
        if (index == NSNotFound) {
            switch (_type) {
                case PickerViewType_OrderTime: {
                    index = 0;
                }
                    break;
                case PickerViewType_Age: {
                    index = 75;
                }
                    break;
                default:
                    break;
            }
        }
        
        [_arrSelectIndex addObject:@(index)];
    }
    
    for (NSInteger i = 0; i < _arrSelectIndex.count; i++) {
        NSInteger index = [_arrSelectIndex[i] integerValue];
        [_pickerView selectRow:index inComponent:i animated:NO];
    }
}

#pragma mark - Private
//获取当前月有多少天
- (NSInteger)daysOfMonth:(NSInteger)month year:(NSInteger)year
{
    NSInteger days = 0;
    
    if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12){
        days = 31;
    } else if (month == 4 || month == 6 || month == 9 || month == 11 ){
        days = 30;
    } else {
        // 2月
        if (year % 400 == 0){
            days = 29;
        } else if (year % 100 == 0){
            days = 28;
        } else if (year % 4 == 1 || year % 4 == 2 || year % 4 == 3){
            days = 28;
        }   else {
            days = 29;
        }
    }
    return days;
}

#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return pickerView.bounds.size.width / _arrDataSource.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return pickerView.bounds.size.height * 0.2;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{
    NSArray *arrTitle = _arrDataSource[component];
    NSString *title = arrTitle[row];
    
    // 选中字体颜色
    NSInteger selectIndex = [_arrSelectIndex[component] integerValue];
    UIColor *color = selectIndex == row? [UIColor colorWithRed:26/255.0 green:123/255.0 blue:255/255.0 alpha:1]: [UIColor blackColor];
    
    UILabel *label = nil;
    if (view != nil) {
        label = (UILabel *)view;
    } else {
        label = [[UILabel alloc] init];
        label.adjustsFontSizeToFitWidth = YES;
        [label setTextAlignment:NSTextAlignmentCenter];
    }
    
    label.text = title;
    label.font = [UIFont systemFontOfSize:pickerView.bounds.size.width / 248.0 * 20];
    label.textColor = color;
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [_arrSelectIndex replaceObjectAtIndex:component withObject:@(row)];
    [pickerView reloadAllComponents];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return _arrDataSource.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (_type == PickerViewType_OrderTime && component == 1 && [_arrSelectIndex.firstObject integerValue] == 0) {
        return 0;
    }
    
    NSArray *arrTitle = _arrDataSource[component];
    return arrTitle.count;
}

#pragma mark - Animation
- (void)show
{
    _lytContentY.active = YES;
    [self.view setNeedsLayout];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)hide:(void(^)(void))complete
{
    _lytContentY.active = NO;
    [self.view setNeedsLayout];
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        [weakSelf.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        complete();
    }];
}

#pragma mark - Action
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [touches.anyObject locationInView:self.view];
    CGPoint pt = [self.view convertPoint:point toView:_viewBottom];
    if ([_viewBottom pointInside:pt withEvent:event] == NO) {
        [self cancel:nil];
    }
}

#pragma mark - Action
- (IBAction)cancel:(id)sender {
    __weak typeof(self) weakSelf = self;
    
    [self hide:^{
        [weakSelf.presentingViewController dismissViewControllerAnimated:NO completion:nil];
    }];
}

- (IBAction)confirm:(id)sender {
    NSMutableArray *arrValue = [[NSMutableArray alloc] init];
    
    if (_type == PickerViewType_OrderTime && [_arrSelectIndex.firstObject integerValue] == 0) {
        // 选择全部
        arrValue = nil;
    } else {
        // 其他普通选择
        for (NSInteger i = 0; i < _arrDataSource.count; i++) {
            NSArray *arrTitle = _arrDataSource[i];
            NSInteger selectIndex = [_arrSelectIndex[i] integerValue];
            NSString *value = arrTitle[selectIndex];
            [arrValue addObject:value];
        }
    }
    
    __weak typeof(self) weakSelf = self;
    [self hide:^{
        [weakSelf.presentingViewController dismissViewControllerAnimated:NO completion:^{
            if (weakSelf.selectBlock) {
                weakSelf.selectBlock(arrValue);
            }
        }];
    }];
}

@end

