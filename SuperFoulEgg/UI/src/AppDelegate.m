#import "AppDelegate.h"
#import "GameLayer.h"
#import "ZombieLayer.h"

@implementation SuperFoulEggAppDelegate

@synthesize window=window_, glView=glView_;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	CCDirectorMac *director = (CCDirectorMac*) [CCDirector sharedDirector];
	
	[director setDisplayStats:NO];
	[director setOriginalWinSize:CGSizeMake(960, 768)];
	
	[director setView:glView_];
	
	// EXPERIMENTAL stuff.
	// 'Effects' don't work correctly when autoscale is turned on.
	// Use kCCDirectorResize_NoScale if you don't want auto-scaling.
	[director setResizeMode:kCCDirectorResize_AutoScale];
	
	// Enable "moving" mouse event. Default no.
	[window_ setAcceptsMouseMovedEvents:NO];
	
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

- (void)dealloc {
	[[CCDirector sharedDirector] end];
	[window_ release];
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

@end
