//
//  ViewController.m
//  www
//
//  Created by ios1 on 15/8/26.
//  Copyright (c) 2015年 ios1. All rights reserved.
//
#define KsystemVersion [[[UIDevice alloc]systemVersion]floatValue]
#import "ViewController.h"

@interface ViewController ()<UIPickerViewDataSource,UIPickerViewDelegate,UIActionSheetDelegate>

@property (nonatomic,strong) NSMutableDictionary *cityDic;
@property (nonatomic,strong) NSArray *provinceArr;
@property (nonatomic,strong) NSArray *cityArray;
@property (nonatomic,strong) NSMutableArray *cityArr;
@property (nonatomic,strong) UIPickerView *cityPickV;
@property (nonatomic,strong) UIActionSheet *actionSheet;
@property (nonatomic,strong) UIAlertController *alertController;
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) NSString *msg;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self readData];
    [self addPickView];
    _label = [[UILabel alloc] initWithFrame:CGRectMake(10, 64, self.view.frame.size.width-20, 40)];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.text = @"这里显示选择的地区";
    [self.view addSubview:_label];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake((self.view.frame.size.width-110)/2, 110, 120, 50);
    [button setTitle:@"点击选择城市" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

#pragma mark 添加pickView视图
-(void)addPickView
{
    _cityPickV = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 16, 100)];
    _cityPickV.dataSource = self;
    _cityPickV.delegate = self;
    
    _cityArray = [_cityArr objectAtIndex:0];
    
    //  底部弹出提示
    if(KsystemVersion < 8.0){//    8.0以下直接采用UIActionSheet
        _actionSheet = [[UIActionSheet alloc]initWithTitle:@"\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil];
        _actionSheet.delegate = self;
        _actionSheet.userInteractionEnabled = YES;
        _actionSheet.backgroundColor = [UIColor clearColor];
        [_actionSheet addSubview:_cityPickV];
    }
    else{// 8.0以后必须使用UIAlertController，否则数据无法显示
        _alertController = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        //        _alertController
        _cityPickV.frame = CGRectMake(0, 0, self.view.frame.size.width - 16, 100);
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [_alertController dismissViewControllerAnimated:YES completion:nil];
            
            
        }];
        [_alertController addAction:ok];
        [_alertController.view addSubview:_cityPickV];
    }
    
}

#pragma mark 读取plist文件
-(void)readData
{
    //读取plist
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"cityData" ofType:@"plist"];
    NSString *keyPath = [[NSBundle mainBundle] pathForResource:@"Province" ofType:@"plist"];
    _provinceArr = [NSArray arrayWithContentsOfFile:keyPath];
    _cityDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    _cityArr = [NSMutableArray array];
    
    for (NSString *str in _provinceArr) {
        NSArray *arr = [_cityDic objectForKey:str];
        [_cityArr addObject:arr];
    }
    NSLog(@"%@%@",_provinceArr,_cityArr);
}


#pragma mark PickViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return  _provinceArr.count;
    }
    else
        return _cityArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSLog(@"%ld",row);
    if (component == 0) {
        
        return _provinceArr[row];
    }else
    {
        return  _cityArray[row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        NSInteger seletedProvinceIndex = [pickerView selectedRowInComponent:0];
        _cityArray = [_cityArr objectAtIndex:seletedProvinceIndex];
        [pickerView reloadComponent:1];
        _msg = [NSString stringWithFormat:@"%@",_provinceArr[seletedProvinceIndex]];
        _label.text = _msg;
    }
    else
    {
        NSInteger seletedProvinceIndex = [pickerView selectedRowInComponent:1];
        NSString *str = [NSString stringWithFormat:@"%@",_cityArray[seletedProvinceIndex]];
        NSString *city = [NSString stringWithFormat:@"%@ %@",_msg,str];
        _label.text = city;
    }
}

#pragma mark 按钮点击事件
-(void)clickBtn
{
    if (KsystemVersion < 8.0) {
        [_actionSheet showInView:self.view];
    }
    else{
        [self presentViewController:_alertController animated:YES completion:nil];
    }
}


@end
