//
//  DropDownMenu.h
//  DropDownMenuTest
//
//  Created by zw on 15/8/4.
//  Copyright (c) 2015年 zw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownSubMenu.h"

static const int MENU_INDEX_NONE = 0;
static const int MENU_INDEX_LEFT = 1;
static const int MENU_INDEX_RIGHT = 2;

#pragma mark - delegate
@protocol DropDownMenuDelegate <NSObject>

@required

-(NSInteger)numberOfRow:(NSInteger)menuIndex;
-(NSInteger)numberOfSubRow:(NSInteger)menuIndex withRow:(NSInteger)row;
-(NSString *)cellTitleForMenu:(NSInteger)menuIndex withRow:(NSInteger)row;
- (NSString *)cellTitleForMenu:(NSInteger)menuIndex withRow:(NSInteger)row withSubRow:(NSInteger)subRow;

- (void)didSelectMenu:(NSInteger)menuIndex withRow:(NSInteger)row withSubRow:(NSInteger)subRow;
@end

@interface DropDownMenu : UIView <DropDownSubMenuDelegate>

@property (nonatomic, assign) id<DropDownMenuDelegate> delegate;
@property (nonatomic,strong) NSString *address;

-(instancetype)initWithOrigin:(CGPoint)origin;
-(void)reloadData;

@end
