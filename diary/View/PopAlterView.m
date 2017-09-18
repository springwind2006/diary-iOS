#import "PopAlterView.h"

@implementation PopAlterView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {

        _transparentView = [[UIView alloc] initWithFrame:frame];
        _transparentView.backgroundColor= [UIColor colorWithWhite:0 alpha:0.25];
        [self addSubview:_transparentView];

        _alterView = [[UIView alloc] initWithFrame:CGRectMake((frame.size.width-200)/2, (frame.size.height-100)/2, 200, 100)];
        _alterView.backgroundColor = [UIColor whiteColor];
        _alterView.layer.cornerRadius = 5.0;
        _alterView.layer.masksToBounds = YES;
        [_transparentView addSubview:_alterView];

        _labTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 180, 50)];
        _labTitle.textAlignment = NSTextAlignmentCenter;
        _labTitle.numberOfLines = 0;
        [_alterView addSubview:_labTitle];

        _btnCancle = [[UIButton alloc] initWithFrame:CGRectMake(10, 60, 80, 30)];
        [_btnCancle setTitle:@"取消" forState:UIControlStateNormal];
        _btnCancle.layer.cornerRadius = 12.0;
        _btnCancle.layer.masksToBounds = YES;
        _btnCancle.backgroundColor = [UIColor grayColor];
        [_btnCancle setTag:100];
        [_btnCancle addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_alterView addSubview:_btnCancle];

        _btnConfirm = [[UIButton alloc] initWithFrame:CGRectMake (105, 60, 80, 30)];
        [_btnConfirm setTitle:@"确定" forState:UIControlStateNormal];
        _btnConfirm.layer.cornerRadius = 12.0;
        _btnConfirm.layer.masksToBounds = YES;
        _btnConfirm.backgroundColor = [UIColor blueColor];
        [_btnConfirm addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_btnConfirm setTag:200];
        [_alterView addSubview:_btnConfirm];
    }
    return self;
}

- (void)showInView:(UIView *)theView withTitle:(NSString *)title{
    [theView addSubview:self];
    _labTitle.text = title;
}

-(void)btnClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
    _btnAction(btn.tag);

    [self removeFromSuperview];
}

@end
