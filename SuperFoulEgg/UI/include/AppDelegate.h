#import "cocos2d.h"

@interface SuperFoulEggAppDelegate : NSObject <NSApplicationDelegate, NSWindowDelegate>
{
	NSWindow *_window;
	CCGLView *_glView;
	NSWindow *_controlsWindow;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet CCGLView *glView;
@property (assign) IBOutlet NSWindow *controlsWindow;

- (IBAction)toggleFullScreen:(id)sender;
- (IBAction)showControls:(id)sender;

@end