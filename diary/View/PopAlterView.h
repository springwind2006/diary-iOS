#import <UIKit/UIKit.h>

@interface PopAlterView : UIView

@property (strong, nonatomic) UIView *transparentView;
@property (strong, nonatomic) UIView *alterView;
@property (strong, nonatomic) UILabel *labTitle;
@property (strong, nonatomic) UIButton *btnCancle;
@property (strong, nonatomic) UIButton *btnConfirm;

/**
 * 自定义提示框
 *
 *  @param theView 提示框弹出的view
 *  @param title   提示框的标题
 */
- (void)showInView:(UIView *)theView withTitle:(NSString *)title;


//点击按钮后的回调方法
@property (nonatomic,strong) void (^btnAction)(NSInteger tag);

@end
