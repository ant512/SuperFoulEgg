#import <Cocoa/Cocoa.h>

@class SZPreferencesPanel;

@protocol SZPreferencesPanelDelegate <NSObject>

- (void)didReceiveKeyDown:(NSEvent *)event sender:(SZPreferencesPanel *)sender;

@end

@interface SZPreferencesPanel : NSPanel

@property (retain) IBOutlet id <SZPreferencesPanelDelegate> controller;

@end
