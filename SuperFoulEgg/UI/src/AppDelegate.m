#import "AppDelegate.h"
#import "GameLayer.h"
#import "ZombieLayer.h"

@implementation SuperFoulEggAppDelegate
@synthesize controlsWindow = _controlsWindow;
@synthesize window = _window;
@synthesize glView = _glView;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	CCDirectorMac *director = (CCDirectorMac*) [CCDirector sharedDirector];
	
	[director setDisplayStats:NO];
	[director setOriginalWinSize:CGSizeMake(960, 768)];
	
	[director setView:_glView];
	
	// EXPERIMENTAL stuff.
	// 'Effects' don't work correctly when autoscale is turned on.
	// Use kCCDirectorResize_NoScale if you don't want auto-scaling.
	[director setResizeMode:kCCDirectorResize_AutoScale];
	
	// Enable "moving" mouse event. Default no.
	[_window setAcceptsMouseMovedEvents:NO];
	
	_window.delegate = self;
	
	[director runWithScene:[ZombieLayer scene]];
}

- (void)applicationDidBecomeActive:(NSNotification *)notification {
	CCDirectorMac *director = (CCDirectorMac*) [CCDirector sharedDirector];
	
	if ([director isFullScreen]) [NSCursor hide];
}

- (void)applicationDidResignActive:(NSNotification *)notification {
	CCDirectorMac *director = (CCDirectorMac*) [CCDirector sharedDirector];
	
	if ([director isFullScreen]) [NSCursor unhide];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
	return YES;
}

- (void)windowWillClose:(NSNotification *)notification {
	[_controlsWindow close];
}

- (void)dealloc {
	[[CCDirector sharedDirector] end];
	[_window release];
	[_controlsWindow release];
	[_glView release];
	
	[super dealloc];
}

#pragma mark AppDelegate - IBActions

- (IBAction)toggleFullScreen: (id)sender {
	CCDirectorMac *director = (CCDirectorMac*) [CCDirector sharedDirector];
	
	if ([director isFullScreen]) {
		[director setFullScreen:NO];
		[NSCursor unhide];
	} else {
		[director setFullScreen:YES];
		[NSCursor hide];
	}
}

- (IBAction)showControls:(id)sender {
	
	NSMenuItem *menuItem = (NSMenuItem *)sender;
	
	if (menuItem.state == 0) {
		_controlsWindow.isVisible = YES;
		menuItem.state = 1;
	} else {
		_controlsWindow.isVisible = NO;
		menuItem.state = 0;
	}
}

@end
