#import <Cocoa/Cocoa.h>

@class SZPreferencesPanel;

@protocol SZPreferencesPanelDelegate <NSObject>

- (void)didReceiveKeyDown:(NSEvent *)event sender:(SZPreferencesPanel *)sender;

@end

@interface SZPreferencesPanel : NSPanel {
	NSButton *_oneUpButton;
	NSButton *_oneDownButton;
	NSButton *_oneLeftButton;
	NSButton *_oneRightButton;
	NSButton *_oneAButton;
	NSButton *_oneBButton;
	NSButton *_twoUpButton;
	NSButton *_twoDownButton;
	NSButton *_twoLeftButton;
	NSButton *_twoRightButton;
	NSButton *_twoAButton;
	NSButton *_twoBButton;
	
	id <SZPreferencesPanelDelegate> _controller;
}

@property (assign) IBOutlet NSButton *oneUpButton;
@property (assign) IBOutlet NSButton *oneDownButton;
@property (assign) IBOutlet NSButton *oneLeftButton;
@property (assign) IBOutlet NSButton *oneRightButton;
@property (assign) IBOutlet NSButton *oneAButton;
@property (assign) IBOutlet NSButton *oneBButton;

@property (assign) IBOutlet NSButton *twoUpButton;
@property (assign) IBOutlet NSButton *twoDownButton;
@property (assign) IBOutlet NSButton *twoLeftButton;
@property (assign) IBOutlet NSButton *twoRightButton;
@property (assign) IBOutlet NSButton *twoAButton;
@property (assign) IBOutlet NSButton *twoBButton;


@property (retain) IBOutlet id <SZPreferencesPanelDelegate> controller;

@end
