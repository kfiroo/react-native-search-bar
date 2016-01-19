#import "RNSearchBar.h"

#import "UIView+React.h"
#import "RCTEventDispatcher.h"

@interface RNSearchBar() <UISearchBarDelegate>

@end

@implementation RNSearchBar
{
    RCTEventDispatcher *_eventDispatcher;
    NSInteger _nativeEventCount;
}

- (instancetype)initWithEventDispatcher:(RCTEventDispatcher *)eventDispatcher
{
    if ((self = [super initWithFrame:CGRectMake(0, 0, 1000, 44)])) {
        _eventDispatcher = eventDispatcher;
        self.delegate = self;
    }
    return self;
}

- (void) searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [_eventDispatcher sendTextEventWithType:RCTTextEventTypeBlur
                                   reactTag:self.reactTag
                                       text:searchBar.text
                                        key:nil
                                 eventCount:_nativeEventCount];
    
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self setShowsCancelButton:YES animated:YES];
    
    for (UIView *subView in self.subviews){
        if([subView isKindOfClass:[UIView class]]){
            for (UIView *subview in subView.subviews){
                if([subview isKindOfClass:[UIButton class]]){
                    [(UIButton*)subview setTitle:@"Done" forState:UIControlStateNormal];
                }
            }
        }
    }
    
    searchBar.keyboardType = UIKeyboardTypeEmailAddress;
    
    [_eventDispatcher sendTextEventWithType:RCTTextEventTypeFocus
                                   reactTag:self.reactTag
                                       text:searchBar.text
                                        key:nil
                                 eventCount:_nativeEventCount];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    _nativeEventCount++;
    
    [_eventDispatcher sendTextEventWithType:RCTTextEventTypeChange
                                   reactTag:self.reactTag
                                       text:searchText
                                        key:nil
                                 eventCount:_nativeEventCount];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSDictionary *event = @{
                            @"target": self.reactTag,
                            @"button": @"search",
                            @"searchText": searchBar.text
                            };
    
    [_eventDispatcher sendInputEventWithName:@"press" body:event];
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.text = @"";
    [self resignFirstResponder];
    [self setShowsCancelButton:NO animated:YES];
    
    NSDictionary *event = @{
                            @"target": self.reactTag,
                            @"button": @"cancel"
                            };
    
    [_eventDispatcher sendInputEventWithName:@"press" body:event];
}

- (void)searchBarClear
{
    self.text = @"";
    [self resignFirstResponder];
    [self setShowsCancelButton:NO animated:YES];
}

@end
