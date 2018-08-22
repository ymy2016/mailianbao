//
//  JSDropDownMenu.m
//  JSDropDownMenu
//
//  Created by Jsfu on 15-1-12.
//  Copyright (c) 2015年 jsfu. All rights reserved.
//

#import "JSDropDownMenu.h"
#import "UIView+BSLine.h"

#define BackColor [UIColor whiteColor]
// 选中颜色加深
#define SelectColor [UIColor whiteColor]
#define TextColor [UIColor darkTextColor]

#define kTextSelectColor UIColorFromRGB(0xfb7c37)
#define kCellBgColor [UIColor whiteColor]

#define kButtomViewHeight AdaptH(45)
#define CellHeight AdaptH(45)
#define CollectionHeight AdaptH(60)

@interface NSString (Size)

- (CGSize)textSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;

@end

@implementation NSString (Size)

- (CGSize)textSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    CGSize textSize;
    if (CGSizeEqualToSize(size, CGSizeZero))
    {
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        
        textSize = [self sizeWithAttributes:attributes];
    }
    else
    {
        NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        //NSStringDrawingTruncatesLastVisibleLine如果文本内容超出指定的矩形限制，文本将被截去并在最后一个字符后加上省略号。 如果指定了NSStringDrawingUsesLineFragmentOrigin选项，则该选项被忽略 NSStringDrawingUsesFontLeading计算行高时使用行间距。（字体大小+行间距=行高）
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        CGRect rect = [self boundingRectWithSize:size
                                         options:option
                                      attributes:attributes
                                         context:nil];
        
        textSize = rect.size;
    }
    return textSize;
}

@end

@interface JSCollectionViewCell:UICollectionViewCell
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIView * selectedLine;
@property (nonatomic, strong) UIImageView * accessoryView;
@property (nonatomic, strong) UIImageView *checkImg;
@property (nonatomic, assign) BOOL mySelected;

- (void)removeAccessoryView;
- (void)updateCheckImage;

@end

@implementation JSCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        _checkImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-AdaptW(10)-AdaptW(16), (self.frame.size.height-AdaptH(12))/2, AdaptW(16), AdaptH(12))];
        _checkImg.image = [UIImage imageNamed:@"icon_check"];
        [self addSubview:_checkImg];
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(AdaptW(10), AdaptH(15), frame.size.width - AdaptW(20) - _checkImg.width - AdaptW(5), frame.size.height - AdaptH(30))];
        _textLabel.textAlignment = NSTextAlignmentLeft;
        _textLabel.textColor = TextColor;
        [self addSubview:_textLabel];
        
        _selectedLine = [[UIView alloc] initWithFrame:CGRectMake(_textLabel.left, _textLabel.bottom, frame.size.width - _textLabel.left * 2, 1)];
        _selectedLine.backgroundColor = kTextSelectColor;
        [self addSubview:_selectedLine];
        
        [self updateCheckImage];
    }
    return self;
}

-(void)setAccessoryView:(UIImageView *)accessoryView{
    
    [self removeAccessoryView];
    
    _accessoryView = accessoryView;
    
    _accessoryView.frame = CGRectMake(self.frame.size.width-10-16, (self.frame.size.height-12)/2, 16, 12);
    
    [self addSubview:_accessoryView];
}

-(void)removeAccessoryView{
    
    if(_accessoryView){
        
        [_accessoryView removeFromSuperview];
    }
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    [self updateCheckImage];
}

- (void)setMySelected:(BOOL)mySelected
{
    _mySelected = mySelected;
    
    [self updateCheckImage];
}

- (void)updateCheckImage
{
    self.checkImg.hidden = !self.selected;
    self.selectedLine.hidden = !self.selected;
    self.textLabel.textColor = self.selected ? kTextSelectColor : TextColor;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

@end


@implementation JSPBackgroundCellView

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    //画一条底部线
    
    CGContextSetRGBStrokeColor(context, 219.0/255, 224.0/255, 228.0/255, 1);//线条颜色
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, rect.size.width,0);
    CGContextMoveToPoint(context, 0, rect.size.height);
    CGContextAddLineToPoint(context, rect.size.width,rect.size.height);
    CGContextStrokePath(context);
}

@end


@interface JSTableViewCell : UITableViewCell

@property(nonatomic,readonly) UILabel *cellTextLabel;
@property(nonatomic,strong) UIImageView *cellAccessoryView;

-(void)setCellText:(NSString *)text align:(NSString*)align;

@end

@implementation JSTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _cellTextLabel = [[UILabel alloc] init];
        _cellTextLabel.textAlignment = NSTextAlignmentCenter;
        _cellTextLabel.font = [UIFont systemFontOfSize:AdaptFont(14.f)];
        [self addSubview:_cellTextLabel];
    }
    return self;
}

-(void)setCellText:(NSString *)text align:(NSString*)align{
    
    _cellTextLabel.text = text;
    // 只取宽度
    CGSize textSize = [text textSizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(MAXFLOAT, 14) lineBreakMode:NSLineBreakByWordWrapping];
//    CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(MAXFLOAT, 14)];
    
    CGFloat marginX = 20;
    
    if (![@"left" isEqualToString:align]) {
        marginX = (self.frame.size.width-textSize.width)/2;
    }
    
    _cellTextLabel.frame = CGRectMake(marginX, 0, textSize.width, self.frame.size.height);
    
    if(_cellAccessoryView){
        _cellAccessoryView.frame = CGRectMake(_cellTextLabel.frame.origin.x+_cellTextLabel.frame.size.width+ AdaptW(10) , (self.frame.size.height-AdaptH(12))/2, AdaptH(16), AdaptH(12));
    }
}

-(void)setCellAccessoryView:(UIImageView *)accessoryView{
    
    if (_cellAccessoryView) {
        [_cellAccessoryView removeFromSuperview];
    }
    
    _cellAccessoryView = accessoryView;
    
    _cellAccessoryView.frame = CGRectMake(_cellTextLabel.frame.origin.x+_cellTextLabel.frame.size.width+AdaptW(10), (self.frame.size.height-AdaptH(12))/2, AdaptH(16), AdaptH(12));
    
    [self addSubview:_cellAccessoryView];
}

@end

@implementation JSIndexPath
- (instancetype)initWithColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight  leftRow:(NSInteger)leftRow row:(NSInteger)row {
    self = [super init];
    if (self) {
        _column = column;
        _leftOrRight = leftOrRight;
        _leftRow = leftRow;
        _row = row;
    }
    return self;
}

+ (instancetype)indexPathWithCol:(NSInteger)col leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow row:(NSInteger)row {
    JSIndexPath *indexPath = [[self alloc] initWithColumn:col leftOrRight:leftOrRight leftRow:leftRow row:row];
    return indexPath;
}
@end

#pragma mark - menu implementation

@interface JSDropDownMenu ()
{
    BOOL _isChangeTitle;
    NSMutableArray *_tempSelectedArray;
}
@property (nonatomic, assign) NSInteger currentSelectedMenudIndex;
@property (nonatomic, assign) BOOL show;
@property (nonatomic, assign) NSInteger numOfMenu;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, strong) UIView *backGroundView;
@property (nonatomic, strong) UIView *bottomShadow;
@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *rightTableView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView * bottomControlView;

//data source
@property (nonatomic, copy) NSArray *array;
//layers array
@property (nonatomic, copy) NSArray *titles;
@property (nonatomic, copy) NSArray *indicators;
@property (nonatomic, copy) NSArray *bgLayers;
@property (nonatomic, assign) NSInteger leftSelectedRow;
@property (nonatomic, assign) BOOL hadSelected;
@property (nonatomic, strong) NSArray * selectedArray;
@end


@implementation JSDropDownMenu

#pragma mark - getter
- (UIColor *)indicatorColor {
    if (!_indicatorColor) {
        _indicatorColor = [UIColor blackColor];
    }
    return _indicatorColor;
}

- (UIColor *)textColor {
    if (!_textColor) {
        _textColor = [UIColor blackColor];
    }
    return _textColor;
}

- (UIColor *)separatorColor {
    if (!_separatorColor) {
        _separatorColor = [UIColor blackColor];
    }
    return _separatorColor;
}

- (NSString *)titleForRowAtIndexPath:(JSIndexPath *)indexPath {
    return [self.dataSource menu:self titleForRowAtIndexPath:indexPath];
}

- (void)reloadData
{
    [self animateLeftTableView:nil rightTableView:nil show:NO complete:^{
        [self animateCollectionView:nil show:NO complete:^{
            _show = NO;
            id VC = self.dataSource;
            self.dataSource = nil;
            self.dataSource = VC;
        }];
    }];
}

- (void)clearCollectionMenuSelectWithIndex:(NSInteger)index
{
    NSMutableArray * tempArray = [[NSMutableArray alloc] init];
    self.selectedArray = tempArray;
    [self changeCollectionTitleWithShow:NO array:self.selectedArray index:index];
}

#pragma mark - setter
- (void)setDataSource:(id<JSDropDownMenuDataSource>)dataSource {
    _dataSource = dataSource;
    
    //configure view
    if ([_dataSource respondsToSelector:@selector(numberOfColumnsInMenu:)]) {
        _numOfMenu = [_dataSource numberOfColumnsInMenu:self];
    } else {
        _numOfMenu = 1;
    }
    
    CGFloat textLayerInterval = self.frame.size.width / ( _numOfMenu * 2);
    
    CGFloat separatorLineInterval = self.frame.size.width / _numOfMenu;
    
    CGFloat bgLayerInterval = self.frame.size.width / _numOfMenu;
    
    NSMutableArray *tempTitles = [[NSMutableArray alloc] initWithCapacity:_numOfMenu];
    NSMutableArray *tempIndicators = [[NSMutableArray alloc] initWithCapacity:_numOfMenu];
    NSMutableArray *tempBgLayers = [[NSMutableArray alloc] initWithCapacity:_numOfMenu];
    
    for (int i = 0; i < _numOfMenu; i++) {
        //bgLayer
        CGPoint bgLayerPosition = CGPointMake((i+0.5)*bgLayerInterval, self.frame.size.height/2);
        CALayer *bgLayer = [self createBgLayerWithColor:BackColor andPosition:bgLayerPosition];
        [self.layer addSublayer:bgLayer];
        [tempBgLayers addObject:bgLayer];
        //title
        CGPoint titlePosition = CGPointMake( (i * 2 + 1) * textLayerInterval - AdaptW(6), self.frame.size.height / 2);
        NSString *titleString = [_dataSource menu:self titleForColumn:i];
        CATextLayer *title = [self createTextLayerWithNSString:titleString withColor:self.textColor andPosition:titlePosition];
        [self.layer addSublayer:title];
        [tempTitles addObject:title];
        //indicator
        CAShapeLayer *indicator = [self createIndicatorWithColor:self.indicatorColor andPosition:CGPointMake(titlePosition.x + title.bounds.size.width / 2 + AdaptW(8), self.frame.size.height / 2)];
        [self.layer addSublayer:indicator];
        [tempIndicators addObject:indicator];
        
        //separator
         if (i != _numOfMenu - 1) {
             CGPoint separatorPosition = CGPointMake((i + 1) * separatorLineInterval, self.frame.size.height/2);
             CAShapeLayer *separator = [self createSeparatorLineWithColor:self.separatorColor andPosition:separatorPosition];
             [self.layer addSublayer:separator];
         }
    }
    
    _bottomShadow.backgroundColor = self.separatorColor;
    
    _titles = [tempTitles copy];
    _indicators = [tempIndicators copy];
    _bgLayers = [tempBgLayers copy];
}

#pragma mark - init method
- (instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self = [self initWithFrame:CGRectMake(origin.x, origin.y, screenSize.width, height)];
    if (self) {
        _origin = origin;
        _currentSelectedMenudIndex = -1;
        _show = NO;
        
        _hadSelected = NO;
        _selectedArray = [NSMutableArray array];
        
        _textSelectedColor = kTextSelectColor;
        _isCollectionMultiselect = NO;
        
        //tableView init
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(origin.x, self.frame.origin.y + self.frame.size.height, 0, 0) style:UITableViewStyleGrouped];
        _leftTableView.rowHeight = CellHeight;
        _leftTableView.separatorColor = [UIColor colorWithRed:220.f/255.0f green:220.f/255.0f blue:220.f/255.0f alpha:1.0];
        _leftTableView.dataSource = self;
        _leftTableView.delegate = self;
        _leftTableView.estimatedRowHeight = 0;
        _leftTableView.estimatedSectionHeaderHeight = 0;
        _leftTableView.estimatedSectionFooterHeight = 0;
        
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.frame.size.width, self.frame.origin.y + self.frame.size.height, 0, 0) style:UITableViewStyleGrouped];
        _rightTableView.rowHeight = CellHeight;
        _rightTableView.separatorColor = [UIColor colorWithRed:220.f/255.0f green:220.f/255.0f blue:220.f/255.0f alpha:1.0];
        _rightTableView.dataSource = self;
        _rightTableView.delegate = self;
        _rightTableView.estimatedRowHeight = 0;
        _rightTableView.estimatedSectionHeaderHeight = 0;
        _rightTableView.estimatedSectionFooterHeight = 0;
        
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, 0) collectionViewLayout:flowLayout];
        
        [_collectionView registerClass:[JSCollectionViewCell class] forCellWithReuseIdentifier:@"CollectionCell"];
        _collectionView.backgroundColor = BackColor;
        _collectionView.allowsMultipleSelection = YES;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        self.autoresizesSubviews = NO;
        _leftTableView.autoresizesSubviews = NO;
        _rightTableView.autoresizesSubviews = NO;
        _collectionView.autoresizesSubviews = NO;
        
        //self tapped
        self.backgroundColor = [UIColor whiteColor];
        UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuTapped:)];
        [self addGestureRecognizer:tapGesture];
        
        //background init and tapped
        _backGroundView = [[UIView alloc] initWithFrame:CGRectMake(origin.x, origin.y, screenSize.width, screenSize.height)];
        _backGroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        _backGroundView.opaque = NO;
        UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)];
        [_backGroundView addGestureRecognizer:gesture];
        
        //add bottom shadow
        _bottomShadow = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-0.5, screenSize.width, 0.5)];
        [self addSubview:_bottomShadow];
        
        _bottomControlView = [[UIView alloc] initWithFrame:(CGRect){origin.x, self.frame.size.height + self.frame.origin.y, screenSize.width, kButtomViewHeight}];
        _bottomControlView.backgroundColor = [UIColor whiteColor];
        [_bottomControlView addTopLineWithLeftPading:0 andRightPading:0];
        
        UIButton * leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftbutton.frame = CGRectMake(_bottomControlView.left, 0, _bottomControlView.width/2, kButtomViewHeight);
        [leftbutton setTitle:@"重置" forState:UIControlStateNormal];
        leftbutton.titleLabel.font = [UIFont systemFontOfSize:AdaptFont(15.f)];
        [leftbutton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [leftbutton addTarget:self action:@selector(leftButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomControlView addSubview:leftbutton];
        
        [leftbutton addRightLineWithTopPaidng:0 andBottomPading:0];
        
        UIButton * rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightbutton.frame = CGRectMake(leftbutton.width, 0, _bottomControlView.width/2, kButtomViewHeight);
        rightbutton.backgroundColor = UIColorFromRGB(0xfb7c37);
        [rightbutton setTitle:@"确定" forState:UIControlStateNormal];
        rightbutton.titleLabel.font = [UIFont systemFontOfSize:AdaptFont(15.f)];
        [rightbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [rightbutton addTarget:self action:@selector(rightButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomControlView addSubview:rightbutton];
    }
    return self;
}

- (void)rightButtonHandle:(UIButton *)button
{
    self.selectedArray = _tempSelectedArray;
    
    [self changeCollectionTitleWithShow:NO array:_tempSelectedArray index:_currentSelectedMenudIndex];
    
//    NSLog(@"重置临时:%@",_tempSelectedArray);
//    NSLog(@"重置保存:%@",self.selectedArray);
    
    CATextLayer *title = (CATextLayer *)_titles[_currentSelectedMenudIndex];
    
    if ([_delegate respondsToSelector:@selector(menu:didSelectCollectionViewWithArray:title:)]) {
        [_delegate menu:self didSelectCollectionViewWithArray:self.selectedArray title:title.string];
        
        [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView collectionView:_collectionView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
            _show = NO;
        }];
    }
}

- (void)leftButtonHandle:(UIButton *)button
{
    NSUInteger column = [self.dataSource menu:self numberOfRowsInColumn:self.currentSelectedMenudIndex leftOrRight:-1 leftRow:-1];
    for (int i = 0; i < column; i++) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
    }
    [_tempSelectedArray removeAllObjects];
    [self changeCollectionTitleWithShow:YES array:_tempSelectedArray index:_currentSelectedMenudIndex];
    [self.collectionView reloadData];
}

- (void)changeCollectionTitleWithShow:(BOOL)show array:(NSArray *)array index:(NSInteger)index
{
    CATextLayer *title = (CATextLayer *)_titles[index];
    if (0 == [array count])
    {
        title.string = @"全部";
    }
    else
    {
        NSMutableString * string = [[NSMutableString alloc] init];
        for (int i = 0; i < [array count]; i++) {
            if (i == [array count] - 1 || i == 0)
            {
                [string appendString:array[i]];
            }
            else {
                [string appendString:[NSString stringWithFormat:@",%@",array[i]]];
            }
        }
        title.string = string;
    }
    
    [self animateTitle:title show:show complete:^{
        
    }];
    
    CAShapeLayer *indicator = (CAShapeLayer *)_indicators[index];
    indicator.position = CGPointMake(title.position.x + title.frame.size.width / 2 + AdaptW(8), indicator.position.y);
}

#pragma mark - init support
- (CALayer *)createBgLayerWithColor:(UIColor *)color andPosition:(CGPoint)position {
    CALayer *layer = [CALayer layer];
    
    layer.position = position;
    layer.bounds = CGRectMake(0, 0, self.frame.size.width/self.numOfMenu, self.frame.size.height-1);
    layer.backgroundColor = color.CGColor;
    
    return layer;
}

- (CAShapeLayer *)createIndicatorWithColor:(UIColor *)color andPosition:(CGPoint)point {
    CAShapeLayer *layer = [CAShapeLayer new];
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(8, 0)];
    [path addLineToPoint:CGPointMake(4, 5)];
    [path closePath];
    
    layer.path = path.CGPath;
    layer.lineWidth = 1.0;
    layer.fillColor = color.CGColor;
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    
    CGPathRelease(bound);
    
    layer.position = point;
    
    return layer;
}

- (CAShapeLayer *)createSeparatorLineWithColor:(UIColor *)color andPosition:(CGPoint)point {
    CAShapeLayer *layer = [CAShapeLayer new];
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(160,0)];
    [path addLineToPoint:CGPointMake(160, self.frame.size.height)];
    
    layer.path = path.CGPath;
    layer.lineWidth = 1.0;
    layer.strokeColor = color.CGColor;
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    
    CGPathRelease(bound);
    
    layer.position = point;

    return layer;
}

- (CATextLayer *)createTextLayerWithNSString:(NSString *)string withColor:(UIColor *)color andPosition:(CGPoint)point {
    
    CGSize size = [self calculateTitleSizeWithString:string];
    
    CATextLayer *layer = [CATextLayer new];
    CGFloat sizeWidth = (size.width < (self.frame.size.width / _numOfMenu) - AdaptW(25)) ? size.width : self.frame.size.width / _numOfMenu - AdaptW(25);
    layer.bounds = CGRectMake(0, 0, sizeWidth, size.height);
    layer.string = string;
    layer.fontSize = AdaptFont(13.f);
    layer.alignmentMode = kCAAlignmentCenter;
    layer.foregroundColor = color.CGColor;
    layer.contentsScale = [[UIScreen mainScreen] scale];
    layer.truncationMode = kCATruncationEnd;
//    layer.wrapped = YES;
    layer.position = point;
    
    return layer;
}

- (CGSize)calculateTitleSizeWithString:(NSString *)string
{
    CGFloat fontSize = AdaptFont(13.f);
    NSDictionary *dic = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    CGSize size = [string boundingRectWithSize:CGSizeMake(280, 20) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return size;
}

#pragma mark - gesture handle
- (void)menuTapped:(UITapGestureRecognizer *)paramSender {
    
    if (_dataSource == nil) {
        return;
    }
    
    if ([self.selectedArray count] != 0) {
        _tempSelectedArray = [NSMutableArray arrayWithArray:self.selectedArray];
    }
    else {
        _tempSelectedArray = [NSMutableArray array];
    }
    
    CGPoint touchPoint = [paramSender locationInView:self];
    //calculate index
    NSInteger tapIndex = touchPoint.x / (self.frame.size.width / _numOfMenu);
    
    if ([_delegate respondsToSelector:@selector(menu:didSelectColumn:)]) {
        [_delegate menu:self didSelectColumn:tapIndex];
    }

    for (int i = 0; i < _numOfMenu; i++) {
        if (i != tapIndex) {
            [self animateIndicator:_indicators[i] Forward:NO complete:^{
                [self animateTitle:_titles[i] show:NO complete:^{
                    
                }];
            }];
            [(CALayer *)self.bgLayers[i] setBackgroundColor:BackColor.CGColor];
        }
    }
    
    BOOL displayByCollectionView = NO;
    
    if ([_dataSource respondsToSelector:@selector(displayByCollectionViewInColumn:)]) {
        displayByCollectionView = [_dataSource displayByCollectionViewInColumn:tapIndex];
    }
    
    if (displayByCollectionView) {
        
        UICollectionView *collectionView = _collectionView;
        
        if (tapIndex == _currentSelectedMenudIndex && _show) {
            [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView collectionView:collectionView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
                _currentSelectedMenudIndex = tapIndex;
                _show = NO;
            }];
            [self changeCollectionTitleWithShow:NO array:self.selectedArray index:_currentSelectedMenudIndex];
            
            [(CALayer *)self.bgLayers[tapIndex] setBackgroundColor:SelectColor.CGColor];
        } else {
            
            _currentSelectedMenudIndex = tapIndex;
            
            [_collectionView reloadData];
            
            if (_currentSelectedMenudIndex!=-1) {
                // 需要隐藏tableview
                [self animateLeftTableView:_leftTableView rightTableView:_rightTableView show:NO complete:^{
                    
                    [self animateIdicator:_indicators[tapIndex] background:_backGroundView collectionView:collectionView title:_titles[tapIndex] forward:YES complecte:^{
                        _show = YES;
                    }];
                }];
            } else{
                [self animateIdicator:_indicators[tapIndex] background:_backGroundView collectionView:collectionView title:_titles[tapIndex] forward:YES complecte:^{
                    _show = YES;
                }];
            }
            
            [self changeCollectionTitleWithShow:YES array:self.selectedArray index:_currentSelectedMenudIndex];
            
            [(CALayer *)self.bgLayers[tapIndex] setBackgroundColor:SelectColor.CGColor];
        }
        
    } else{
        
        BOOL haveRightTableView = [_dataSource haveRightTableViewInColumn:tapIndex];
//        UITableView *leftTableView = _leftTableView;
        UITableView *rightTableView = nil;
        
        if (haveRightTableView) {
            rightTableView = _rightTableView;
            // 修改左右tableview显示比例
            
        }
        
        if (tapIndex == _currentSelectedMenudIndex && _show) {
            
            [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView leftTableView:_leftTableView rightTableView:_rightTableView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
                _currentSelectedMenudIndex = tapIndex;
                _show = NO;
            }];
            
            [(CALayer *)self.bgLayers[tapIndex] setBackgroundColor:BackColor.CGColor];
        } else {
            
            [self changeCollectionTitleWithShow:NO array:self.selectedArray index:1];
            
            _hadSelected = NO;
            
            _currentSelectedMenudIndex = tapIndex;
            
            if ([_dataSource respondsToSelector:@selector(currentLeftSelectedRow:)]) {
                
                _leftSelectedRow = [_dataSource currentLeftSelectedRow:_currentSelectedMenudIndex];
            }
            
            if (rightTableView) {
                [rightTableView reloadData];
            }
            [_leftTableView reloadData];
            
            CGFloat ratio = [_dataSource widthRatioOfLeftColumn:_currentSelectedMenudIndex];
            if (_leftTableView) {
                
                _leftTableView.frame = CGRectMake(_leftTableView.frame.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width*ratio, 0);
            }
            
            if (_rightTableView) {
                
                _rightTableView.frame = CGRectMake(_origin.x+_leftTableView.frame.size.width, self.frame.origin.y + self.frame.size.height, self.frame.size.width*(1-ratio), 0);
            }
            
            if (_currentSelectedMenudIndex!=-1) {
                // 需要隐藏collectionview
                [self animateCollectionView:_collectionView show:NO complete:^{
                    
                    [self animateIdicator:_indicators[tapIndex] background:_backGroundView leftTableView:_leftTableView rightTableView:_rightTableView title:_titles[tapIndex] forward:YES complecte:^{
                        _show = YES;
                    }];
                }];
                
            } else{
                [self animateIdicator:_indicators[tapIndex] background:_backGroundView leftTableView:_leftTableView rightTableView:_rightTableView title:_titles[tapIndex] forward:YES complecte:^{
                    _show = YES;
                }];
            }
            [(CALayer *)self.bgLayers[tapIndex] setBackgroundColor:SelectColor.CGColor];
        }
    }
}

- (void)backgroundTapped:(UITapGestureRecognizer *)paramSender
{
    BOOL displayByCollectionView = NO;
    
    if ([_dataSource respondsToSelector:@selector(displayByCollectionViewInColumn:)]) {
        
        displayByCollectionView = [_dataSource displayByCollectionViewInColumn:_currentSelectedMenudIndex];
    }

    if (displayByCollectionView) {
        
        [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView collectionView:_collectionView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
            _show = NO;
        }];
        
        [self changeCollectionTitleWithShow:NO array:self.selectedArray index:_currentSelectedMenudIndex];
        
    } else{
        [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView leftTableView:_leftTableView rightTableView:_rightTableView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
            _show = NO;
        }];
    }
    
    [(CALayer *)self.bgLayers[_currentSelectedMenudIndex] setBackgroundColor:BackColor.CGColor];
    
    [_tempSelectedArray removeAllObjects];
    
//    NSLog(@"退出临时:%@",_tempSelectedArray);
//    NSLog(@"退出保存:%@",self.selectedArray);
}

#pragma mark - animation method
- (void)animateIndicator:(CAShapeLayer *)indicator Forward:(BOOL)forward complete:(void(^)())complete {
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.25];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithControlPoints:0.4 :0.0 :0.2 :1.0]];
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    anim.values = forward ? @[ @0, @(M_PI) ] : @[ @(M_PI), @0 ];
    
    if (!anim.removedOnCompletion) {
        [indicator addAnimation:anim forKey:anim.keyPath];
    } else {
        [indicator addAnimation:anim forKey:anim.keyPath];
        [indicator setValue:anim.values.lastObject forKeyPath:anim.keyPath];
    }
    
    [CATransaction commit];
    
    if (forward) {
        // 展开
        indicator.fillColor = _textSelectedColor.CGColor;
    }
    else {
        // 收缩
        indicator.fillColor = _indicatorColor.CGColor;
    }
    
    complete();
}

- (void)animateBackGroundView:(UIView *)view show:(BOOL)show complete:(void(^)())complete {
    if (show) {
        [self.superview addSubview:view];
        [view.superview addSubview:self];
        
        [UIView animateWithDuration:0.2 animations:^{
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }
    complete();
}

/**
 *动画显示下拉菜单
 */
- (void)animateLeftTableView:(UITableView *)leftTableView rightTableView:(UITableView *)rightTableView show:(BOOL)show complete:(void(^)())complete {
    
    CGFloat ratio = [_dataSource widthRatioOfLeftColumn:_currentSelectedMenudIndex];
    
    if (show) {
        
        CGFloat leftTableViewHeight = 0;
        
        CGFloat rightTableViewHeight = 0;
        
        if (leftTableView) {
            
            leftTableView.frame = CGRectMake(_origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width*ratio, 0);
            [self.superview addSubview:leftTableView];
            
            leftTableViewHeight = ([leftTableView numberOfRowsInSection:0] > 5) ? (5 * leftTableView.rowHeight) : ([leftTableView numberOfRowsInSection:0] * leftTableView.rowHeight);

        }

        if (rightTableView) {
            
            rightTableView.frame = CGRectMake(_origin.x+leftTableView.frame.size.width, self.frame.origin.y + self.frame.size.height, self.frame.size.width*(1-ratio), 0);
            
            [self.superview addSubview:rightTableView];
            
            rightTableViewHeight = ([rightTableView numberOfRowsInSection:0] > 5) ? (5 * rightTableView.rowHeight) : ([rightTableView numberOfRowsInSection:0] * rightTableView.rowHeight);
        }

//        CGFloat tableViewHeight = MAX(leftTableViewHeight, rightTableViewHeight);

        [UIView animateWithDuration:0.2 animations:^{
            if (leftTableView) {
                leftTableView.frame = CGRectMake(_origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width*ratio, leftTableViewHeight);
            }
            if (rightTableView) {
                rightTableView.frame = CGRectMake(_origin.x+leftTableView.frame.size.width, self.frame.origin.y + self.frame.size.height, self.frame.size.width*(1-ratio), rightTableViewHeight);
            }
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            
            if (leftTableView) {
                leftTableView.frame = CGRectMake(_origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width*ratio, 0);
            }
            if (rightTableView) {
                rightTableView.frame = CGRectMake(_origin.x+leftTableView.frame.size.width, self.frame.origin.y + self.frame.size.height, self.frame.size.width*(1-ratio), 0);
            }
            
        } completion:^(BOOL finished) {
            
            if (leftTableView) {
                [leftTableView removeFromSuperview];
            }
            if (rightTableView) {
                [rightTableView removeFromSuperview];
            }
        }];
    }
    complete();
}

/**
 *动画显示下拉菜单
 */
- (void)animateCollectionView:(UICollectionView *)collectionView show:(BOOL)show complete:(void(^)())complete {
    
    if (show) {
        
        CGFloat collectionViewHeight = 0;
        
        if (collectionView) {
            collectionView.frame = CGRectMake(_origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, 0);
            [self.superview addSubview:collectionView];
            
            collectionViewHeight = ([collectionView numberOfItemsInSection:0] > 10) ? (5 * CollectionHeight) : (ceil([collectionView numberOfItemsInSection:0]/2) * CollectionHeight);
            
            if (collectionViewHeight == 0) {
                collectionViewHeight = CollectionHeight;
            }
        }
        
        _bottomControlView.frame = CGRectMake(_origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, kButtomViewHeight);
        [self.superview addSubview:_bottomControlView];
        
        [UIView animateWithDuration:0.2 animations:^{
            if (collectionView) {
                collectionView.frame = CGRectMake(_origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, collectionViewHeight);
            }
            
            _bottomControlView.frame = CGRectMake(_origin.x, CGRectGetMaxY(collectionView.frame)-2, self.frame.size.width, kButtomViewHeight);
            
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            if (collectionView) {
                collectionView.frame = CGRectMake(_origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, 0);
            }
            
            _bottomControlView.frame = CGRectMake(_origin.x, CGRectGetMaxY(collectionView.frame)-2, self.frame.size.width, kButtomViewHeight);
            
            [_bottomControlView removeFromSuperview];
            
        } completion:^(BOOL finished) {
            
            if (collectionView) {
                [collectionView removeFromSuperview];
            }
            
        }];
    }
    complete();
}

- (void)animateTitle:(CATextLayer *)title show:(BOOL)show complete:(void(^)())complete {
    CGSize size = [self calculateTitleSizeWithString:title.string];
    CGFloat sizeWidth = (size.width < (self.frame.size.width / _numOfMenu) - AdaptW(25)) ? size.width : self.frame.size.width / _numOfMenu - AdaptW(25);
    title.bounds = CGRectMake(0, 0, sizeWidth, size.height);
    
    if (!show) {
        title.foregroundColor = _textColor.CGColor;
    }
    else {
        title.foregroundColor = _textSelectedColor.CGColor;
    }
    
    complete();
}

- (void)animateIdicator:(CAShapeLayer *)indicator background:(UIView *)background leftTableView:(UITableView *)leftTableView rightTableView:(UITableView *)rightTableView title:(CATextLayer *)title forward:(BOOL)forward complecte:(void(^)())complete{
    
    [self animateIndicator:indicator Forward:forward complete:^{
        [self animateTitle:title show:forward complete:^{
            [self animateBackGroundView:background show:forward complete:^{
                [self animateLeftTableView:leftTableView rightTableView:rightTableView show:forward complete:^{
                }];
            }];
        }];
    }];
    
    complete();
}

- (void)animateIdicator:(CAShapeLayer *)indicator background:(UIView *)background collectionView:(UICollectionView *)collectionView title:(CATextLayer *)title forward:(BOOL)forward complecte:(void(^)())complete{
    
    [self animateIndicator:indicator Forward:forward complete:^{
        [self animateTitle:title show:forward complete:^{
            [self animateBackGroundView:background show:forward complete:^{
                [self animateCollectionView:collectionView show:forward complete:^{

                }];
            }];
        }];
    }];
    
    complete();
}

#pragma mark - table datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger leftOrRight = 0;
    if (_rightTableView==tableView) {
        leftOrRight = 1;
    }
    
    NSAssert(self.dataSource != nil, @"menu's dataSource shouldn't be nil");
    if ([self.dataSource respondsToSelector:@selector(menu:numberOfRowsInColumn:leftOrRight: leftRow:)]) {
        return [self.dataSource menu:self numberOfRowsInColumn:self.currentSelectedMenudIndex leftOrRight:leftOrRight leftRow:_leftSelectedRow];
    } else {
        NSAssert(0 == 1, @"required method of dataSource protocol should be implemented");
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"DropDownMenuCell";

    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    
    JSPBackgroundCellView *bg = [[JSPBackgroundCellView alloc]init];
    bg.backgroundColor = [UIColor whiteColor];
    cell.selectedBackgroundView = bg;

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = self.textColor;
    titleLabel.highlightedTextColor = _textSelectedColor;
    titleLabel.tag = 1;
    titleLabel.font = [UIFont systemFontOfSize:14.0];
        
    [cell addSubview:titleLabel];
    
    
    NSInteger leftOrRight = 0;
    
    if (_rightTableView==tableView) {
        
        leftOrRight = 1;
    }
    
//    UILabel *titleLabel = (UILabel*)[cell viewWithTag:1];
    
    CGSize textSize;
    
    if ([self.dataSource respondsToSelector:@selector(menu:titleForRowAtIndexPath:)]) {
        
        titleLabel.text = [self.dataSource menu:self titleForRowAtIndexPath:[JSIndexPath indexPathWithCol:self.currentSelectedMenudIndex leftOrRight:leftOrRight leftRow:_leftSelectedRow row:indexPath.row]];
        // 只取宽度
        textSize = [titleLabel.text textSizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(MAXFLOAT, 14) lineBreakMode:NSLineBreakByWordWrapping];
        
    }
    
    cell.backgroundColor = kCellBgColor;
    cell.textLabel.font = [UIFont systemFontOfSize:AdaptW(14.f)];
    cell.separatorInset = UIEdgeInsetsZero;
    
    if (leftOrRight == 1) {
        
        CGFloat marginX = AdaptW(20);
        
        titleLabel.frame = CGRectMake(marginX, 0, textSize.width, CellHeight);
        //右边tableview
        cell.backgroundColor = SelectColor;
        titleLabel.textColor = _textSelectedColor;
        
        if ([titleLabel.text isEqualToString:[(CATextLayer *)[_titles objectAtIndex:_currentSelectedMenudIndex] string]]) {
            
            UIImageView *accessoryImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_check"]];
            
            accessoryImageView.frame = CGRectMake(titleLabel.frame.origin.x+titleLabel.frame.size.width+AdaptW(10), (CellHeight-AdaptH(12))/2, AdaptW(16), AdaptH(12));
            
            accessoryImageView.backgroundColor = [UIColor blackColor];
            
            [cell addSubview:accessoryImageView];
        } else{
            
            
        }
    } else{
        
        CGFloat ratio = [_dataSource widthRatioOfLeftColumn:_currentSelectedMenudIndex];
        
        CGFloat marginX = (self.frame.size.width*ratio-textSize.width)/2;
        
        titleLabel.frame = CGRectMake(marginX, 0, textSize.width, CellHeight);
        
        if (!_hadSelected && _leftSelectedRow == indexPath.row) {
            cell.backgroundColor = SelectColor;
            titleLabel.textColor = _textSelectedColor;
            
            BOOL haveRightTableView = [_dataSource haveRightTableViewInColumn:_currentSelectedMenudIndex];
            if(!haveRightTableView){
                UIImageView *accessoryImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_check"]];
                
                accessoryImageView.frame = CGRectMake(titleLabel.frame.origin.x+titleLabel.frame.size.width+AdaptW(10), (CellHeight-AdaptH(12))/2, AdaptW(16), AdaptH(12));
                
                [cell addSubview:accessoryImageView];
            }
        } else{
            
        }
    }
    
    
    return cell;
}

#pragma mark - tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger leftOrRight = 0;
    if (_rightTableView==tableView) {
        leftOrRight = 1;
    } else {
        _leftSelectedRow = indexPath.row;
    }
    
    if (self.delegate || [self.delegate respondsToSelector:@selector(menu:didSelectRowAtIndexPath:)]) {
        
        BOOL haveRightTableView = [_dataSource haveRightTableViewInColumn:_currentSelectedMenudIndex];
        
        if ((leftOrRight==0 && !haveRightTableView) || leftOrRight==1) {
            [self confiMenuWithSelectRow:indexPath.row leftOrRight:leftOrRight];
        }
        
        [self.delegate menu:self didSelectRowAtIndexPath:[JSIndexPath indexPathWithCol:self.currentSelectedMenudIndex leftOrRight:leftOrRight leftRow:_leftSelectedRow row:indexPath.row]];
        
        if (leftOrRight==0 && haveRightTableView) {
            if (!_hadSelected) {
                _hadSelected = YES;
                [_leftTableView reloadData];
                NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:_leftSelectedRow inSection:0];
                
                [_leftTableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
            
            [_rightTableView reloadData];
        }
        
    } else {
        //TODO: delegate is nil
    }
}

- (void)confiMenuWithSelectRow:(NSInteger)row leftOrRight:(NSInteger)leftOrRight{
    CATextLayer *title = (CATextLayer *)_titles[_currentSelectedMenudIndex];

    // 不允许修改title
    BOOL isChangeTitle = YES;
    if ([_dataSource respondsToSelector:@selector(changeTitleInColumn:)]) {
        isChangeTitle = [_dataSource changeTitleInColumn:_currentSelectedMenudIndex];
    }
    if (isChangeTitle) {
        title.string = [self.dataSource menu:self titleForRowAtIndexPath:[JSIndexPath indexPathWithCol:self.currentSelectedMenudIndex leftOrRight:leftOrRight leftRow:_leftSelectedRow row:row]];
    }
    
    [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView leftTableView:_leftTableView rightTableView:_rightTableView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
        _show = NO;
    }];
    [(CALayer *)self.bgLayers[_currentSelectedMenudIndex] setBackgroundColor:BackColor.CGColor];
    
    CAShapeLayer *indicator = (CAShapeLayer *)_indicators[_currentSelectedMenudIndex];
    indicator.position = CGPointMake(title.position.x + title.frame.size.width / 2 + AdaptW(8), indicator.position.y);
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    // 为collectionview时 leftOrRight 为-1
    if ([self.dataSource respondsToSelector:@selector(menu:numberOfRowsInColumn:leftOrRight: leftRow:)]) {
        return [self.dataSource menu:self numberOfRowsInColumn:self.currentSelectedMenudIndex leftOrRight:-1 leftRow:-1];
    } else {
        NSAssert(0 == 1, @"required method of dataSource protocol should be implemented");
        return 0;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *collectionCell = @"CollectionCell";
    JSCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCell forIndexPath:indexPath];
    
    if ([self.dataSource respondsToSelector:@selector(menu:titleForRowAtIndexPath:)]) {
        cell.textLabel.text = [self.dataSource menu:self titleForRowAtIndexPath:[JSIndexPath indexPathWithCol:self.currentSelectedMenudIndex leftOrRight:-1 leftRow:-1 row:indexPath.row]];
    } else {
        NSAssert(0 == 1, @"dataSource method needs to be implemented");
    }

//    cell.backgroundColor = [UIColor whiteColor];
//    cell.selectedBackgroundView.backgroundColor = BackColor;

    cell.textLabel.font = [UIFont systemFontOfSize:AdaptFont(14.f)];
    
    if (!_isCollectionMultiselect) {
        cell.textLabel.textColor = self.textColor;
        
        if ([cell.textLabel.text isEqualToString:[(CATextLayer *)[_titles objectAtIndex:_currentSelectedMenudIndex] string]]) {
            cell.backgroundColor = BackColor;
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_make"]];
        } else{
            
            [cell removeAccessoryView];
        }
    }
    else {
        
        for (NSString * string in _tempSelectedArray) {
            if ([cell.textLabel.text isEqualToString:string]) {
                cell.checkImg.hidden = NO;
                cell.selectedLine.hidden = NO;
                cell.textLabel.textColor = kTextSelectColor;
            }
        }
    }
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((collectionView.frame.size.width)/2, CollectionHeight + 1);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark --UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_isCollectionMultiselect) {
        if (self.delegate || [self.delegate respondsToSelector:@selector(menu:didSelectRowAtIndexPath:)]) {
            
            [self confiMenuWithSelectRow:indexPath.row];
            
            [self.delegate menu:self didSelectRowAtIndexPath:[JSIndexPath indexPathWithCol:self.currentSelectedMenudIndex leftOrRight:-1 leftRow:-1 row:indexPath.row]];
            
        } else {
            //TODO: delegate is nil
        }
    }
    else {
        
        NSString * selectString = [self.dataSource menu:self titleForRowAtIndexPath:[JSIndexPath indexPathWithCol:self.currentSelectedMenudIndex leftOrRight:-1 leftRow:-1 row:indexPath.item]];

        if ([_tempSelectedArray containsObject:selectString]) {
            JSCollectionViewCell * cell = (JSCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
            cell.checkImg.hidden = YES;
            cell.selectedLine.hidden = YES;
            cell.textLabel.textColor = self.textColor;
            [_tempSelectedArray removeObject:selectString];
            [self.collectionView reloadData];
        }
        else {
            [_tempSelectedArray addObject:selectString];
        }
        
        [self changeCollectionTitleWithShow:YES array:_tempSelectedArray index:_currentSelectedMenudIndex];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_isCollectionMultiselect) {
        
    }
    else {
        
        NSString * deselectString = [self.dataSource menu:self titleForRowAtIndexPath:[JSIndexPath indexPathWithCol:self.currentSelectedMenudIndex leftOrRight:-1 leftRow:-1 row:indexPath.item]];
        [_tempSelectedArray removeObject:deselectString];
        
        [self changeCollectionTitleWithShow:YES array:_tempSelectedArray index:_currentSelectedMenudIndex];
    }
}

- (void)confiMenuWithSelectRow:(NSInteger)row{
    
    CATextLayer *title = (CATextLayer *)_titles[_currentSelectedMenudIndex];
    
    // 不允许修改title
    BOOL isChangeTitle = YES;
    if ([_dataSource respondsToSelector:@selector(changeTitleInColumn:)]) {
        isChangeTitle = [_dataSource changeTitleInColumn:_currentSelectedMenudIndex];
    }
    if (isChangeTitle) {
        title.string = [self.dataSource menu:self titleForRowAtIndexPath:[JSIndexPath indexPathWithCol:self.currentSelectedMenudIndex leftOrRight:-1 leftRow:-1 row:row]];
    }

    [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView collectionView:_collectionView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
        _show = NO;
    }];

    [(CALayer *)self.bgLayers[_currentSelectedMenudIndex] setBackgroundColor:BackColor.CGColor];
    
    CAShapeLayer *indicator = (CAShapeLayer *)_indicators[_currentSelectedMenudIndex];
    indicator.position = CGPointMake(title.position.x + title.frame.size.width / 2 + AdaptW(8), indicator.position.y);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end
