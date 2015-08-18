//
//  DropDownSubMenu.m
//  DropDownMenuTest
//
//  Created by zw on 15/8/4.
//  Copyright (c) 2015年 zw. All rights reserved.
//

#import "DropDownSubMenu.h"

@interface DropDownSubMenu ()

//??? assigh、strong等关键词的区别加深记忆  ???
@property (nonatomic,assign) CGPoint origin;
@property (nonatomic,strong) UITableView *leftTableView;
@property (nonatomic,strong) UIView *leftFootView;
@property (nonatomic,strong) UIView *addressView;
@property (nonatomic,strong) UIView *addressViewBottomLine;
@property (nonatomic,strong) UILabel *addressLabel;

@property (nonatomic,strong) UITableView *rightTableView;
@property (nonatomic,strong) UIView *rightFootView;
@property (nonatomic,strong) UIView *dropView;

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *indicator;

@property (nonatomic,assign) NSInteger curSelectLeftIndex;
@property (nonatomic, assign) int isFirstLoad;

@end

@implementation DropDownSubMenu

-(instancetype)initWithOrigin:(CGPoint)origin{
    self = [self initWithFrame:CGRectMake(origin.x, 0, DropDown_MENU_WIDTH, DropDown_MENU_HEIGHT)];
    if (self) {
        _origin = origin;
        _show = NO;
        [self setBackgroundColor:UIColorFromRGB(0xf0f4f7)];
        [self setSubView:origin];
    }
    return self;
}

-(void)setSubView:(CGPoint)origin{
    [self setMenu];
    // 下拉显示的视图
    _dropView = [[UIView alloc] initWithFrame:CGRectMake(0, origin.y + DropDown_MENU_HEIGHT, DropDown_DropView_WIDTH,0)];
    _dropView.clipsToBounds = YES;
    
    // 下拉视图 左边的的tableView
    _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, DropDown_TABLEVIEW_WIDTH, DropDown_DropView_HEIGHT-44) style:UITableViewStylePlain];
    _leftTableView.rowHeight = DropDown_TABLEVIEW_ROW_HEIGHT;
    _leftTableView.dataSource = self;
    _leftTableView.delegate = self;
    [_leftTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_leftTableView setBackgroundColor:UIColorFromRGB(0xf0f4f7)];
    
    _leftFootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DropDown_TABLEVIEW_WIDTH, 10)];
    [_leftFootView setBackgroundColor:UIColorFromRGB(0xf0f4f7)];
    UIView *divideLineInLeftFootView = [[UIView alloc] initWithFrame:CGRectMake(DropDown_TABLEVIEW_WIDTH-0.5, 0, 0.5, _leftFootView.frame.size.height)];
    divideLineInLeftFootView.tag = 10000;
    [divideLineInLeftFootView setBackgroundColor:DropDown_Divide_Line_Color];
    [_leftFootView addSubview:divideLineInLeftFootView];
    
    [_leftTableView setTableFooterView:_leftFootView];
    [_dropView addSubview:_leftTableView];
    
    _addressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, 44)];
    [_addressView setBackgroundColor:[UIColor whiteColor]];
    
    _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, DeviceWidth-30, 44)];
    [_addressLabel setFont:[UIFont systemFontOfSize:DropDown_TEXT_FONT]];
    [_addressView addSubview:_addressLabel];
    [_dropView addSubview:_addressView];
    
    _addressViewBottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, DeviceWidth, 0.5)];
    [_addressViewBottomLine setBackgroundColor:DropDown_Divide_Line_Color];
    [_addressView addSubview:_addressViewBottomLine];
    
    // 下拉视图 右边的tableView
    _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.leftTableView.frame.size.width, 44, DropDown_DropView_WIDTH - self.leftTableView.frame.size.width, DropDown_DropView_HEIGHT) style:UITableViewStylePlain];
    _rightTableView.rowHeight = DropDown_TABLEVIEW_ROW_HEIGHT;
    _rightTableView.dataSource = self;
    _rightTableView.delegate = self;
    [_rightTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.dropView addSubview:_rightTableView];
}

-(void)setMenu{
    //初始化menu的title，向下的图标
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, DropDown_MENU_WIDTH-20, DropDown_MENU_HEIGHT)];
    [_titleLabel setFont:[UIFont systemFontOfSize:DropDown_TEXT_FONT]];
    [self addSubview:_titleLabel];
    
    _indicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"downImage"]];
    _indicator.frame = CGRectMake(_titleLabel.frame.origin.x+_titleLabel.bounds.size.width/2+6, DropDown_MENU_HEIGHT/2 - 2, 10, 5);
    [self addSubview:_indicator];
    
    //添加菜单下的一条灰色线
    UIView *bottomShadow = [[UIView alloc] initWithFrame:CGRectMake(0, DropDown_MENU_HEIGHT-0.5, MainWidth, 0.5)];
    bottomShadow.backgroundColor = UIColorFromRGB(0xc3d1dc);
    [self addSubview:bottomShadow];
}

- (void)setIsShowAddress:(BOOL)isShowAddress
{
    if (isShowAddress) {
        _addressView.hidden = NO;
        _addressView.frame = CGRectMake(0, 0, DeviceWidth, 44);
        _leftTableView.frame = CGRectMake(0, 44, DropDown_TABLEVIEW_WIDTH, DropDown_DropView_HEIGHT-44);
        _rightTableView.frame = CGRectMake(self.leftTableView.frame.size.width, 44, DropDown_DropView_WIDTH - self.leftTableView.frame.size.width, DropDown_DropView_HEIGHT);
    } else {
        _addressView.hidden = YES;
        _leftTableView.frame = CGRectMake(0, 0, DropDown_TABLEVIEW_WIDTH, DropDown_DropView_HEIGHT);
        _rightTableView.frame = CGRectMake(self.leftTableView.frame.size.width, 0, DropDown_DropView_WIDTH - self.leftTableView.frame.size.width, DropDown_DropView_HEIGHT);
    }
}


- (void)setAddress:(NSString *)address
{
    NSString *addressStr = [NSString stringWithFormat:@"当前定位:     %@", address];
    [_addressLabel setText:addressStr];
}


#pragma mark - set delegate
- (void)reloadData
{
    [_titleLabel setText:_firstTitleContent];
    
    [self setTitleContent];
    _indicator.frame = CGRectMake(_titleLabel.frame.origin.x + _titleLabel.frame.size.width + 6, _indicator.frame.origin.y, 10, 5);
    
    [self.leftTableView reloadData];
    
    // 首次初始化，选中"全部"
    _isFirstLoad = YES;
    _curSelectLeftIndex = 0;
    
    NSInteger selectedIndex = 0;
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
    [self.leftTableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    [self.rightTableView reloadData];
    
    if (_isShowAddress) {
        _leftFootView.frame = CGRectMake(0, 0, DropDown_TABLEVIEW_WIDTH, DropDown_DropView_HEIGHT- 44 - [_delegate numberOfRow]*44);
    } else {
        _leftFootView.frame = CGRectMake(0, 0, DropDown_TABLEVIEW_WIDTH, DropDown_DropView_HEIGHT - [_delegate numberOfRow]*44);
    }
    
    UIView *divideLineInLeftFootView = (UIView *)[_leftFootView viewWithTag:10000];
    divideLineInLeftFootView.frame = CGRectMake(divideLineInLeftFootView.frame.origin.x, divideLineInLeftFootView.frame.origin.y, 0.5, _leftFootView.frame.size.height);
    [_leftTableView setTableFooterView:_leftFootView];
}

#pragma mark - gesture handle

- (void)menuTapped:(UITapGestureRecognizer *)paramSender {
    __weak typeof(self) weakSelf = self;
    
    if (_show) {
        [self animate:NO complecte:^{
            weakSelf.show = NO;
        }];
    } else {
        [self animate:YES complecte:^{
            weakSelf.show = YES;
        }];
    }
}

- (void)backGroundTapped:(UITapGestureRecognizer *)paramSender
{
    __weak typeof(self) weakSelf = self;
    
    [self animate:NO complecte:^{
        weakSelf.show = NO;
    }];
}

#pragma mark - animation method
- (void)animateIndicator:(BOOL)willShow complete:(void(^)())complete
{
    if (_show) {
        [UIView beginAnimations:@"clockwiseAnimation"context:NULL];
        [UIView setAnimationDuration:0.2];
        _indicator.transform = CGAffineTransformIdentity;
        [UIView commitAnimations];
    } else {
        [UIView beginAnimations:@"counterclockwiseAnimation" context:NULL];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationDelegate:self];
        _indicator.transform = CGAffineTransformMakeRotation((180.0f * M_PI) / 180.0f);
        [UIView commitAnimations];
    }
    
    complete();
}

- (void)animateDropView:(BOOL)willShow complete:(void(^)())complete
{
    if (willShow) {
        _dropView.frame = CGRectMake(0, self.origin.y + DropDown_MENU_HEIGHT, DropDown_DropView_WIDTH,0);
        
        [self.superview.superview addSubview:_dropView];
        
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.dropView.frame = CGRectMake(0, self.origin.y + DropDown_MENU_HEIGHT, DropDown_DropView_WIDTH,DropDown_DropView_HEIGHT);
        }];
    } else {
        __weak typeof(self) weakSelf = self;
        
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.dropView.frame = CGRectMake(0, self.origin.y + DropDown_MENU_HEIGHT, DropDown_DropView_WIDTH,0);
        } completion:^(BOOL finished) {
            [weakSelf.dropView removeFromSuperview];
        }];
    }
    if (complete) {
        complete();
    }
}

- (void)setTitleContent
{
    CGSize size = [self calculateTitleSizeWithString:_titleLabel.text];
    if (size.width > DropDown_MENU_WIDTH - 30) {
        size.width = DropDown_MENU_WIDTH - 30;
    }
    _titleLabel.frame = CGRectMake((DropDown_MENU_WIDTH-size.width)/2, 0, size.width, DropDown_MENU_HEIGHT);
}

- (void)animate:(BOOL)willShow complecte:(void(^)())complete
{
    __weak typeof(self) weakSelf = self;
    
    [self animateIndicator:willShow complete:^{
        [weakSelf setTitleContent];
        [weakSelf animateDropView:willShow complete:nil];
    }];
    
    complete();
}

#pragma other tool
- (CGSize)calculateTitleSizeWithString:(NSString *)string
{
    CGFloat fontSize = DropDown_TEXT_FONT;
    NSDictionary *dic = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    CGSize size = [string boundingRectWithSize:CGSizeMake(280, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return size;
}

#pragma mark - table delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _leftTableView) {
        if (_delegate && [_delegate respondsToSelector:@selector(numberOfRow)])
        {
            return [_delegate numberOfRow];
        }
    } else {
        if (_delegate && [_delegate respondsToSelector:@selector(numberOfSubRow:)])
        {
            return [_delegate numberOfSubRow:_curSelectLeftIndex];
        }
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"DropDownMenuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        UIView *selectBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DropDown_TABLEVIEW_WIDTH+1, DropDown_TABLEVIEW_ROW_HEIGHT)];
        [selectBgView setBackgroundColor:[UIColor whiteColor]];
        
        UIView *selectBgTopLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DropDown_TABLEVIEW_WIDTH, 0.5)];
        [selectBgTopLine setBackgroundColor:DropDown_Divide_Line_Color];
        [selectBgView addSubview:selectBgTopLine];
        
        UIView *selectBgBottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, DropDown_TABLEVIEW_ROW_HEIGHT+0.25, DropDown_TABLEVIEW_WIDTH, 0.5)];
        [selectBgBottomLine setBackgroundColor:DropDown_Divide_Line_Color];
        selectBgBottomLine.tag = 112;
        [selectBgView addSubview:selectBgBottomLine];
        cell.selectedBackgroundView = selectBgView;
        
        cell.backgroundColor = UIColorFromRGB(0xf0f4f7);
        cell.textLabel.font = [UIFont systemFontOfSize:DropDown_TEXT_FONT];
        
        UIView *divideLine = [[UIView alloc] initWithFrame:CGRectMake(DropDown_TABLEVIEW_WIDTH-0.5, 0, 0.5, cell.frame.size.height)];
        [divideLine setBackgroundColor:DropDown_Divide_Line_Color];
        divideLine.tag = 111;
        [cell addSubview:divideLine];
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, DropDown_TABLEVIEW_ROW_HEIGHT-0.5, DropDown_TABLEVIEW_WIDTH, 0.5)];
        [bottomLine setBackgroundColor:DropDown_Divide_Line_Color];
        bottomLine.tag = 112;
        [cell addSubview:bottomLine];
        [cell.textLabel setFont:[UIFont systemFontOfSize:DropDown_TEXT_FONT]];
        
        if (tableView == _leftTableView) {
            cell.textLabel.highlightedTextColor = [UIColor colorWithRed:36/255.0 green:192/255.0 blue:160/255.0 alpha:1];
        } else {
            [cell setSelectedBackgroundView:nil];
            [cell setSelectedBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]]];
            [cell setBackgroundColor:[UIColor whiteColor]];
            
            UIView *divideLine = [cell viewWithTag:111];
            if (divideLine) {
                [divideLine removeFromSuperview];
            }
            
            UIView *bottomLine = [cell viewWithTag:112];
            if (bottomLine) {
                [bottomLine removeFromSuperview];
            }
            
            cell.textLabel.highlightedTextColor = [UIColor whiteColor];
            
        }
    }
    
    if (tableView == _leftTableView)
    {
        cell.textLabel.text = [self cellTitleForRow:indexPath.row];
    }
    else
    {
        cell.textLabel.text = [self cellTitleForRow:_curSelectLeftIndex withSubRow:indexPath.row];
    }
    
    return cell;
}

#pragma mark - tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 如果是选择的左边的tableView，记录下左侧选的内容，刷新右侧列表
    if (tableView == self.leftTableView) {
        _curSelectLeftIndex = indexPath.row;
        [_rightTableView reloadData];
    }
    
    // 如果是选择的右边的tableView，点击具体选项后返回
    if (tableView == self.rightTableView) {
        if (self.delegate || [self.delegate respondsToSelector:@selector(didSelectMenuWithRow:withSubRow:)])
        {
            [_titleLabel setText:[self cellTitleForRow:_curSelectLeftIndex withSubRow:indexPath.row]];
            
            __weak typeof(self) weakSelf = self;
            
            [self animate:NO complecte:^{
                weakSelf.show = NO;
            }];
            
            _indicator.frame = CGRectMake(_titleLabel.frame.origin.x + _titleLabel.frame.size.width + 6, _indicator.frame.origin.y, 10, 5);
            
            [self.delegate didSelectMenuWithRow:_curSelectLeftIndex withSubRow:indexPath.row];
        }
    }
}

- (NSString *)cellTitleForRow:(NSInteger)row
{
    if (_delegate && [_delegate respondsToSelector:@selector(cellTitleForRow:)])
    {
        return [_delegate cellTitleForRow:row];
    }
    return @"";
}

- (NSString *)cellTitleForRow:(NSInteger)row withSubRow:(NSInteger)subRow
{
    if (_delegate && [_delegate respondsToSelector:@selector(cellTitleForRow:withSubRow:)])
    {
        return [_delegate cellTitleForRow:row withSubRow:subRow];
    }
    return @"";
}





@end
