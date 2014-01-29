#import "TXTextView.h"

#define HELP_HTML_LAYOUT @"<html><head><meta name=\"viewport\" content=\"width=device-width; initial-scale=1.0; maxium-scale=1.0; user-scalable=no;\"><style type='text/css'>#wrap {height: 100%%; width: 100%%; overflow-y: scroll; -webkit-overflow-scrolling: touch;} #content {font-size:%fpt; color:#555; line-height:%fpx; font-family:arial;} </style></head><body><div id=\"wrap\"><div id=\"content\" contenteditable=\"%@\"></div></div><script>var text = document.getElementById('content'); text.onkeyup = function() { location.href = 'txtextview://changed'; }; function setText(innerText) { text.innerText = innerText; }</script></body></html>"

static CGFloat const kDefaultFontSize = 17.0;
static CGFloat const kDefaultLineSpacingRatio = 1.2;

@interface TXTextView()

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation TXTextView

@synthesize font = _font, lineSpacing = _lineSpacing;

- (id)initWithText:(NSString *)text withFont:(UIFont *)font withLineSpacing:(CGFloat)lineSpacing {
    self = [super init];
    if (self) {
        _text = text;
        _font = font;
        _lineSpacing = lineSpacing;
    }
    return self;
}

#pragma mark - Getter, Setter
- (void)setText:(NSString * __strong )text {
     _text = text;
    [self setNeedsDisplay];
}

- (UIFont *)font {
    if (_font == nil) {
        _font = [UIFont systemFontOfSize:kDefaultFontSize];
    }
    return _font;
}
- (void)setFont:(UIFont *)font {
    _font = font;
    [self setNeedsDisplay];
}

- (CGFloat)lineSpacing {
    if (_lineSpacing == 0) {
        _lineSpacing = self.font.lineHeight * kDefaultLineSpacingRatio;
    }
    return _lineSpacing;
}

- (void)setLineSpacing:(CGFloat)lineSpacing {
    _lineSpacing = lineSpacing;
    [self setNeedsDisplay];
}

- (void)setEditable:(BOOL)editable {
    _editable = editable;
    [self setNeedsDisplay];
}

- (UIWebView *)webView {
    if (_webView == nil) {
        _webView = [[UIWebView alloc] init];
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

#pragma mark - View Life Cycle
- (void)drawRect:(CGRect)rect {
    [self.webView loadHTMLString:[NSString stringWithFormat:HELP_HTML_LAYOUT,
                                  self.font.pointSize,
                                  self.lineSpacing,
                                  (self.editable) ? @"true" : @"false"]
                         baseURL:nil];

    self.webView.frame = self.bounds;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *escapedText = [self.text stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    escapedText = [escapedText stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"];
	[self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setText('%@');", escapedText]];
}

#pragma mark - WebView Delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([request.URL.scheme isEqualToString:@"txtextview"]) {
        _text = [_webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('content').innerText"];
    }
    return YES;
}



@end