#import <Cocoa/Cocoa.h>

@class SZPreferencesPanel;

@protocol SZPreferencesPanelDelegate <NSObject>

- (void)didReceiveKeyDown:(NSEvent *)event sender:(SZPreferencesPanel *)sender;

@end

@interface SZPreferencesPanel : NSPanel {
	NSButton *oneUpButton;
	NSButton *oneDownButton;
	NSButton *oneLeftButton;
	NSButton *oneRightButton;
	NSButton *oneAButton;
	NSButton *oneBButton;
	NSButton *twoUpButton;
	NSButton *twoDownButton;
	NSButton *twoLeftButton;
	NSButton *twoRightButton;
	NSButton *twoAButton;
	NSButton *twoBButton;
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
