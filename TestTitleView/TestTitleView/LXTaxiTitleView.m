//
//  LXTaxiTitleView.m
//  LXYC
//
//  Created by 王中尧 on 2017/8/12.
//  Copyright © 2017年 lexingtianxia. All rights reserved.
//

#import "LXTaxiTitleView.h"

// 随机色
#define RANDOMCOLOR [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1]
// 16进制颜色
#define HEXCOLOR(hex, a) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:a]

@interface LXTaxiTitleView () <UIScrollViewDelegate>

/** 标题宽度 数组 */
@property (nonatomic, strong) NSMutableArray *titlesWidthArrM;
/** titleView 总长度 */
@property (nonatomic, assign) CGFloat titleViewWidth;
/** 标题间距 */
@property (nonatomic, assign) CGFloat titleMargin;
/** scrollView */
@property (nonatomic, weak) UIScrollView *titleScroll;
/** 字体 */
@property (nonatomic, strong) UIFont *titleFont;
/** 菜单按钮 */
@property (nonatomic, weak) UIButton *menuButton;
/** selectedTitleButton */
@property (nonatomic, strong) UIButton *selectedTitleButton;

@end

@implementation LXTaxiTitleView

// 默认标题间距
static CGFloat const margin = 20;

- (NSMutableArray *)titlesWidthArrM {
    if (!_titlesWidthArrM) {
        _titlesWidthArrM = [NSMutableArray array];
    }
    return _titlesWidthArrM;
}

/** 
 *  初始化一个 titleView
 *
 *  titlesArr   标题数组
 *  titleFont   标题字号
 */
+ (instancetype)setupTaxiTitleViewWithFrame:(CGRect)frame titlesArr:(NSArray *)titlesArr titleFont:(UIFont *)titleFont {
    
    LXTaxiTitleView *titleView = [[LXTaxiTitleView alloc] initWithFrame:frame titlesArr:titlesArr titleFont:titleFont];
    return titleView;
}

- (instancetype)initWithFrame:(CGRect)frame titlesArr:(NSArray *)titlesArr titleFont:(UIFont *)titleFont {
    if (self = [super initWithFrame:frame]) {
        // 计算所有标题宽度 以及 titleView 总宽度
        [self setupTitleWidth:titlesArr titleFont:titleFont];
    }

    return [self setupUIWithTitlesArr:titlesArr];
}

/** 设置 UI */
- (instancetype)setupUIWithTitlesArr:(NSArray *)titlesArr {
    UIScrollView *titleScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width - self.height, self.height)];
    _titleScroll = titleScroll;
    titleScroll.scrollEnabled = YES;
    titleScroll.backgroundColor = [UIColor whiteColor];
    titleScroll.contentSize = CGSizeMake(_titleViewWidth, 0);
    titleScroll.showsVerticalScrollIndicator = NO;
    titleScroll.showsHorizontalScrollIndicator = NO;
    titleScroll.delegate = self;
    [self addSubview:titleScroll];
    
    CGFloat titleX = 0.0; // 该值表示当前 label 前面所有 labelW、margin 之和（也就是当前 label 的 x 值）
    for (int i = 0; i < self.titlesWidthArrM.count; i ++) {
        
        if (i == 0) {
            titleX = 0;
            
        } else {
            CGFloat titleWidth = [self.titlesWidthArrM[i - 1] floatValue] + margin;
            titleX = titleX + titleWidth;
        }
        
//        NSLog(@"beginTitleWidth --- %d --- %.2f", i, titleX);
        
        UIButton *titleButton = [[UIButton alloc] initWithFrame:CGRectMake(titleX, 0, [self.titlesWidthArrM[i] floatValue] + margin, titleScroll.height)];
//        NSLog(@"titleButtonWidth --- %.2f", [self.titlesWidthArrM[i] floatValue]);
        [titleButton setBackgroundColor:[UIColor whiteColor]];
        [titleButton setTitle:titlesArr[i] forState:UIControlStateNormal];
        [titleButton setTitleColor:HEXCOLOR(0xCCCCCC, 0.8) forState:UIControlStateNormal];
        [titleButton setTitleColor:HEXCOLOR(0xFF5A39, 1) forState:UIControlStateSelected];
        titleButton.titleLabel.font = _titleFont;
        titleButton.tag = i;
        [titleButton addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [titleScroll addSubview:titleButton];
        
        if (i == 0) {
            titleButton.selected = YES;
            _selectedTitleButton = titleButton;
        }
    }
    
    UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleScroll.frame), 0, self.height, self.height)];
    _menuButton = menuButton;
    [menuButton addTarget:self action:@selector(menuClick) forControlEvents:UIControlEventTouchUpInside];
    menuButton.backgroundColor = [UIColor whiteColor];
    [menuButton setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [menuButton setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateHighlighted];
    menuButton.layer.cornerRadius = 20;
    menuButton.layer.masksToBounds = YES;
    [self addSubview:menuButton];
    
    return self;
}

/** 菜单 */
- (void)menuClick {
    NSLog(@"menuClick ~");
}

/** titleButton 点击 */
- (void)titleButtonClick:(UIButton *)titleButton {
    _selectedTitleButton.selected = NO;
    titleButton.selected = YES;
    _selectedTitleButton = titleButton;
    
    // 取出 clickButton 的中心位置 x
    CGFloat clickButtonCenterX = titleButton.x + titleButton.width * 0.5;
    // 取出 clickButton 的中心位置 x 值在 scroll 中心时的偏移量
    CGFloat clickButtonCenterXContentOffsetX = fabs(titleButton.x + titleButton.width * 0.5 - _titleScroll.width * 0.5);
    
    // 居中前提
    if ((_titleScroll.contentSize.width - clickButtonCenterX >= _titleScroll.width * 0.5) && (clickButtonCenterX >= _titleScroll.width * 0.5)) {
        [_titleScroll setContentOffset:CGPointMake(clickButtonCenterXContentOffsetX, 0) animated:YES];
    } else { // 两侧 button 无法居中，直接将 scroll 拉到更为靠近的一侧
        if (clickButtonCenterX < _titleScroll.contentSize.width * 0.5) { // 定位左侧
            [_titleScroll setContentOffset:CGPointZero animated:YES];
        } else { // 定位右侧
            [_titleScroll setContentOffset:CGPointMake(_titleScroll.contentSize.width - _titleScroll.width, 0) animated:YES];
        }
    }
}

/** 计算所有标题宽度 以及 titleView 总宽度 */
- (void)setupTitleWidth:(NSArray *)titlesArr titleFont:(UIFont *)titleFont {
    // 字体
    _titleFont = titleFont;
    // 总长度
    CGFloat totalWidth = 0;
    
    // 计算所有标题的宽度
    for (NSString *title in titlesArr) {
        
        CGRect titleBounds = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:titleFont} context:nil];
        
        CGFloat width = titleBounds.size.width;
        
        [self.titlesWidthArrM addObject:@(width)];
        
        totalWidth += width;
    }
    
    if (totalWidth > MS_SCREEN_WIDTH) { // 总长度超过了屏幕宽度
        _titleMargin = margin;

    } else {
        
        CGFloat titleMargin = (MS_SCREEN_WIDTH - totalWidth) / (titlesArr.count + 1);
        _titleMargin = titleMargin < margin ? margin: titleMargin;
    }
    
    
    // titleView 整体宽度
    _titleViewWidth = totalWidth + (_titleMargin * titlesArr.count + 1);
}

#pragma mark - Scroll View Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSLog(@"scrollView.contentOffset.x --- %.2f", scrollView.contentOffset.x);
    if (scrollView.contentOffset.x >= (_titleScroll.contentSize.width - _titleScroll.width)) { // scroll 到头继续拉
        double fullContentOffsetX = scrollView.contentOffset.x - (_titleScroll.contentSize.width - _titleScroll.width);
//        NSLog(@"fullContentOffsetX --- %.2f", fullContentOffsetX); // 80px 为拉伸效果极限(极限效果：旋转持续增长、透明度80px达到最透明0.3)
        
        // 旋转角度
        CGAffineTransform rotation = CGAffineTransformMakeRotation(M_PI * 2 * fmod(fullContentOffsetX, 80) / 80);
        
        _menuButton.transform = rotation;
    }
}

/** 减速停止 */
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    _menuButton.transform = CGAffineTransformMakeRotation(0);
//}

/** 拖拽停止 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    _menuButton.transform = CGAffineTransformMakeRotation(0);
}

@end
