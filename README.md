# TXTextView
iOS6 UITextView의 lineSpacing가 무시되는 버그를 해결하기 위해 UIWebView로 구현한 TextView입니다.

http://stackoverflow.com/questions/12562506/nsparagraphstyle-line-spacing-ignored

````
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textView = [[TXTextView alloc] init];
    self.textView.frame = self.view.bounds;
    self.textView.text = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.";
    
    [self.view addSubview:self.textView];
}
````
