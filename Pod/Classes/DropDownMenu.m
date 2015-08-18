//
//  DropDownMenu.m
//  DropDownMenuTest
//
//  Created by zw on 15/8/4.
//  Copyright (c) 2015年 zw. All rights reserved.
//

#import "DropDownMenu.h"

@interface DropDownMenu ()

@property (nonatomic, strong) DropDownSubMenu *leftMenu;
@property (nonatomic, strong) DropDownSubMenu *rightMenu;
@property (nonatomic, assign) NSInteger curShowMenuIndex;

@property (nonatomic, strong) UIView *backGroundView;

@end

@implementation DropDownMenu

-(instancetype)initWithOrigin:(CGPoint)origin{
    if (self = [super init]) {
        self.frame = CGRectMake(origin.x, origin.y, MainWidth, 40);
        //左侧菜单
        _leftMenu = [[DropDownSubMenu alloc] initWithOrigin:origin];
        [_leftMenu setIsShowAddress:YES];
        [self addSubview:_leftMenu];
        
        //右侧菜单
        _rightMenu = [[DropDownSubMenu alloc] initWithOrigin:CGPointMake(origin.x+DropDown_MENU_WIDTH, origin.y)];
        [_rightMenu setIsShowAddress:NO];
        [self addSubview:_rightMenu];
        
        //添加弹出时的灰色背景
        _backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, DeviceHeight)];
        _backGroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        _backGroundView.opaque = NO;
        
        //添加手势
        [self addGesture];
        
        _curShowMenuIndex = MENU_INDEX_NONE;
    }
    return self;
}

-(void)setDelegate:(id<DropDownMenuDelegate>)delegate{
    _delegate = delegate;
    _leftMenu.delegate = self;
    _rightMenu.delegate = self;
    
}

-(void)setAddress:(NSString *)address{
    _address = address;
    [_leftMenu setAddress:_address];
}

-(void)reloadData{
    _leftMenu.firstTitleContent = @"地区";
    _rightMenu.firstTitleContent = @"科室";
    
    [_leftMenu reloadData];
    [_rightMenu reloadData];
}

- (void)addGesture
{
    // 菜单添加手势
    UIGestureRecognizer *leftMenuGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftMenuTapped:)];
    [_leftMenu addGestureRecognizer:leftMenuGesture];
    
    UIGestureRecognizer *rightMenuGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightMenuTapped:)];
    [_rightMenu addGestureRecognizer:rightMenuGesture];
    
    // 灰色背景加手势
    UIGestureRecognizer *backgroundGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)];
    [_backGroundView addGestureRecognizer:backgroundGesture];
}

- (void)leftMenuTapped:(UITapGestureRecognizer *)paramSender
{
    if (_leftMenu.show) {
        _curShowMenuIndex = MENU_INDEX_NONE;
        [self showBackGroundView:NO complete:nil];
    } else {
        _curShowMenuIndex = MENU_INDEX_LEFT;
        [self showBackGroundView:YES complete:nil];
    }
    
    [_leftMenu menuTapped:paramSender];
    
    if (_rightMenu.show) {
        [_rightMenu menuTapped:paramSender];
    }
}

- (void)rightMenuTapped:(UITapGestureRecognizer *)paramSender
{
    if (_rightMenu.show) {
        _curShowMenuIndex = MENU_INDEX_NONE;
        [self showBackGroundView:NO complete:nil];
    } else {
        _curShowMenuIndex = MENU_INDEX_RIGHT;
        [self showBackGroundView:YES complete:nil];
    }
    
    if (_leftMenu.show) {
        [_leftMenu menuTapped:paramSender];
    }
    [_rightMenu menuTapped:paramSender];
}

- (void)backgroundTapped:(UITapGestureRecognizer *)paramSender
{
    __weak typeof(self) weakSelf = self;
    
    [self showBackGroundView:NO complete:^{
        if (weakSelf.leftMenu.show) {
            [weakSelf.leftMenu backGroundTapped:paramSender];
        }
        
        if (weakSelf.rightMenu.show) {
            [weakSelf.rightMenu backGroundTapped:paramSender];
        }
    }];
}

- (void)showBackGroundView:(BOOL)willShow complete:(void(^)())complete
{
    if (willShow) {
        [self.superview addSubview:_backGroundView];
        [self.superview addSubview:self];
        
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.backGroundView.backgroundColor = UIColorFromRGB(0x000000);
            weakSelf.backGroundView.alpha = 0.7;
        }];
    } else {
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.backGroundView.backgroundColor = UIColorFromRGB(0x000000);
            weakSelf.backGroundView.alpha = 0;
        } completion:^(BOOL finished) {
            [weakSelf.backGroundView removeFromSuperview];
        }];
    }
    
    if (complete) {
        complete();
    }
}

-(NSInteger)numberOfRow{
    if (_delegate && [_delegate respondsToSelector:@selector(numberOfRow:)]) {
        return [_delegate numberOfRow:_curShowMenuIndex];
    }
    
    return 0;
}

-(NSInteger)numberOfSubRow:(NSInteger)row{
    if (_delegate && [_delegate respondsToSelector:@selector(numberOfSubRow:withRow:)]) {
        return [_delegate numberOfSubRow:_curShowMenuIndex withRow:row];
    }
    return 0;
}

-(NSString *)cellTitleForRow:(NSInteger)row{
    if (_delegate && [_delegate respondsToSelector:@selector(cellTitleForMenu:withRow:)]) {
        return [_delegate cellTitleForMenu:_curShowMenuIndex withRow:row];
    }
    return @"";
}

-(NSString *)cellTitleForRow:(NSInteger)row withSubRow:(NSInteger)subRow{
    if (_delegate && [_delegate respondsToSelector:@selector(cellTitleForMenu:withRow:withSubRow:)]) {
        return [_delegate cellTitleForMenu:_curShowMenuIndex withRow:row withSubRow:subRow];
    }
    return @"";
}

- (void)didSelectMenuWithRow:(NSInteger)row withSubRow:(NSInteger)subRow
{
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectMenu:withRow:withSubRow:)]) {
        [_delegate didSelectMenu:_curShowMenuIndex withRow:row withSubRow:subRow];
    }
    
    [self backgroundTapped:nil];
}

@end
