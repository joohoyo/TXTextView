#import "TXTextView.h"

#define HELP_HTML_LAYOUT @"<html><head><meta name=\"viewport\" content=\"width=device-width; initial-scale=1.0; maxium-scale=1.0; user-scalable=no;\"><style type='text/css'>body, div { margin: 0; padding: 0; } #wrap {height: 100%%; width: 100%%; overflow: %@; -webkit-overflow-scrolling: touch;} #content {font-size:%fpt; color:#555; line-height:%fpt; font-family:arial;} </style></head><body><div id=\"wrap\"><div id=\"content\" contenteditable=\"%@\"></div></div><script>var text = document.getElementById('content'); text.onkeyup = function() { location.href = 'txtextview://changed'; }; function setText(innerText) { text.innerText = innerText; } function getHeight() { return document.getElementById('content').offsetHeight; }</script></body></html>"

static CGFloat const kDefaultFontSize = 17.0;
static CGFloat const kDefaultLineSpacingRatio = 0.2;

@interface TXTextView()

@property (nonatomic, strong) UIWebView *webView;
@property (atomic) BOOL isLoading;

@end

@implementation TXTextView

@synthesize font = _font, lineSpacing = _lineSpacing;

- (id)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)initWithText:(NSString *)text withFont:(UIFont *)font withLineSpacing:(CGFloat)lineSpacing {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _text = text;
        _font = font;
        _lineSpacing = lineSpacing;
        
        [self render];
    }
    return self;
}

#pragma mark - Getter, Setter
- (void)setText:(NSString * __strong )text {
     _text = text;
    [self render];
}

- (UIFont *)font {
    if (_font == nil) {
        _font = [UIFont systemFontOfSize:kDefaultFontSize];
    }
    return _font;
}
- (void)setFont:(UIFont *)font {
    _font = font;
    [self render];
}

- (CGFloat)lineSpacing {
    if (_lineSpacing == 0) {
        _lineSpacing = self.font.lineHeight * kDefaultLineSpacingRatio;
    }
    return _lineSpacing;
}

- (void)setLineSpacing:(CGFloat)lineSpacing {
    _lineSpacing = lineSpacing;
    [self render];
}

- (void)setEditable:(BOOL)editable {
    _editable = editable;
    [self render];
}

- (void)setOverflow:(TXTextViewOverflow)overflow {
    _overflow = overflow;
    [self render];
}

- (UIWebView *)webView {
    if (_webView == nil) {
        _webView = [[UIWebView alloc] init];
        _webView.backgroundColor = [UIColor clearColor];
        _webView.opaque = NO;
        _webView.scrollView.scrollEnabled = NO;
        _webView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
                                     UIViewAutoresizingFlexibleWidth |
                                     UIViewAutoresizingFlexibleRightMargin |
                                     UIViewAutoresizingFlexibleTopMargin |
                                     UIViewAutoresizingFlexibleHeight |
                                     UIViewAutoresizingFlexibleBottomMargin);
        _webView.delegate = self;
        
        [self addSubview:_webView];
    }
    return _webView;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.webView.frame = self.bounds;
}

- (void)render {
    self.isLoading = YES;
    
    [self.webView loadHTMLString:[NSString stringWithFormat:HELP_HTML_LAYOUT,
                                  [self overflowCode],
                                  self.font.pointSize,
                                  (self.font.pointSize + self.lineSpacing),
                                  (self.editable) ? @"true" : @"false"]
                         baseURL:nil];
    
    while(self.isLoading) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }

    [self setTextToWebView];
    if (_overflow == TXTextViewOverflowVisible) {
        [self resizeViewByWebViewHeight];
    }
}

- (void)setTextToWebView {
    NSString *escapedText = [self.text stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    escapedText = [escapedText stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"];
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setText('%@');", escapedText]];
}

- (void)resizeViewByWebViewHeight {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, [self webViewHeight]);
}

- (CGFloat)webViewHeight {
    return [[self.webView stringByEvaluatingJavaScriptFromString:@"getHeight()"] floatValue];
}

- (NSString *)overflowCode {
    switch (_overflow) {
        case TXTextViewOverflowVisible:
            return @"visible";
        case TXTextViewOverflowHidden:
            return @"hidden";
        case TXTextViewOverflowScroll:
            return @"scroll";
        default:
            return @"visible";
    }
}

#pragma mark - WebView Delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([request.URL.scheme isEqualToString:@"txtextview"]) {
        _text = [_webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('content').innerText"];
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.isLoading = NO;
}

@end
