#import <UIKit/UIKit.h>

static NSString * const kTXTextViewKeyPressedNotification = @"TXTextViewKeyPressedNotification";

typedef enum {
    TXTextViewOverflowVisible = 0,
    TXTextViewOverflowHidden,
    TXTextViewOverflowScroll
} TXTextViewOverflow;

@interface TXTextView : UIView <UIWebViewDelegate>

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic) CGFloat lineSpacing;
@property (nonatomic) BOOL editable;
@property (nonatomic) TXTextViewOverflow overflow;

- (id)initWithText:(NSString *)text withFont:(UIFont *)font withLineSpacing:(CGFloat)lineSpacing;
- (CGFloat)webViewHeight;

@end
