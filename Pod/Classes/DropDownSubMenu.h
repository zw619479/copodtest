//
//  DropDownSubMenu.h
//  DropDownMenuTest
//
//  Created by zw on 15/8/4.
//  Copyright (c) 2015年 zw. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define NavigationBarHeight 44
#define DeviceHeight [UIScreen mainScreen].bounds.size.height
#define DeviceWidth [UIScreen mainScreen].bounds.size.width

#define MainHeight ([UIScreen mainScreen].bounds.size.width - 20)
#define MainWidth [UIScreen mainScreen].bounds.size.width
#define DropDown_MENU_HEIGHT 40
#define DropDown_MENU_WIDTH MainWidth/2

#define DropDown_DropView_HEIGHT MainHeight-DropDown_MENU_HEIGHT-NavigationBarHeight-80
#define DropDown_DropView_WIDTH MainWidth

#define DropDown_TABLEVIEW_WIDTH 130
#define DropDown_TABLEVIEW_ROW_HEIGHT 44

#define DropDown_TEXT_FONT 15.0
#define DropDown_Divide_Line_Color UIColorFromRGB(0xe1e1e1)



@protocol DropDownSubMenuDelegate <NSObject>

@required
- (NSInteger)numberOfRow;
-(NSInteger)numberOfSubRow:(NSInteger)row;

-(NSString *)cellTitleForRow:(NSInteger)row;
-(NSString *)cellTitleForRow:(NSInteger)row withSubRow:(NSInteger)subRow;
-(void)didSelectMenuWithRow:(NSInteger)row withSubRow:(NSInteger)subRow;

@end

@interface DropDownSubMenu : UIView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, weak) id <DropDownSubMenuDelegate> delegate;

@property (assign,nonatomic) BOOL isShowAddress;
@property (strong,nonatomic) NSString *address;
@property (strong,nonatomic) NSString *firstTitleContent;

//设置当前dropdown是否显示
@property (nonatomic, assign) BOOL show;

-(instancetype)initWithOrigin:(CGPoint)origin;

//手势处理
- (void)menuTapped:(UITapGestureRecognizer *)paramSender;
- (void)backGroundTapped:(UITapGestureRecognizer *)paramSender;

//加载tableview
-(void)reloadData;


@end
