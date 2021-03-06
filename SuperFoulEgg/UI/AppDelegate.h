#import "cocos2d.h"
#import "SZPreferencesPanel.h"

@interface SuperFoulEggAppDelegate : NSObject <NSApplicationDelegate, NSWindowDelegate, SZPreferencesPanelDelegate>
{
	NSWindow *_window;
	CCGLView *_glView;
	NSTextField *_messageLabel;
	NSButton *_activeButton;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet CCGLView *glView;
@property (assign) IBOutlet NSTextField *messageLabel;

- (IBAction)buttonClicked:(id)sender;
- (IBAction)toggleFullScreen:(id)sender;

@end
