#import "AppDelegate.h"
#import "GameLayer.h"
#import "ZombieLayer.h"
#import "Settings.h"

@implementation SuperFoulEggAppDelegate

@synthesize window = _window;
@synthesize glView = _glView;
@synthesize messageLabel = _messageLabel;

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

- (void)dealloc {
	[[CCDirector sharedDirector] end];
	[_window release];
	[_glView release];
	
	[super dealloc];
}

#pragma mark AppDelegate - IBActions

- (IBAction)buttonClicked:(id)sender {
	_activeButton.state = NO;
	_activeButton = sender;
	_activeButton.state = YES;
	
	[_messageLabel setHidden:NO];
	_messageLabel.stringValue = [NSString stringWithFormat:@"Press the key for %@", _activeButton.alternateTitle];
}

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

#pragma mark SZPreferencesPanelDelegate

- (void)didReceiveKeyDown:(NSEvent *)event sender:(SZPreferencesPanel *)sender {
	
	switch (_activeButton.tag) {
		case 1:
			[Settings sharedSettings].keyCodeTwoUp = [event.characters characterAtIndex:0];
			break;
		case 2:
			[Settings sharedSettings].keyCodeTwoDown = [event.characters characterAtIndex:0];
			break;
		case 3:
			[Settings sharedSettings].keyCodeTwoLeft = [event.characters characterAtIndex:0];
			break;
		case 4:
			[Settings sharedSettings].keyCodeTwoRight = [event.characters characterAtIndex:0];
			break;
		case 5:
			[Settings sharedSettings].keyCodeTwoA = [event.characters characterAtIndex:0];
			break;
		case 6:
			[Settings sharedSettings].keyCodeTwoB = [event.characters characterAtIndex:0];
			break;
			
		case 7:
			[Settings sharedSettings].keyCodeOneUp = [event.characters characterAtIndex:0];
			break;
		case 8:
			[Settings sharedSettings].keyCodeOneDown = [event.characters characterAtIndex:0];
			break;
		case 9:
			[Settings sharedSettings].keyCodeOneLeft = [event.characters characterAtIndex:0];
			break;
		case 10:
			[Settings sharedSettings].keyCodeOneRight = [event.characters characterAtIndex:0];
			break;
		case 11:
			[Settings sharedSettings].keyCodeOneA = [event.characters characterAtIndex:0];
			break;
		case 12:
			[Settings sharedSettings].keyCodeOneB = [event.characters characterAtIndex:0];
			break;
	}
	
	unichar keyCode = [event.characters characterAtIndex:0];
	
	switch (keyCode) {
		case DEFAULT_KEY_CODE_TWO_LEFT:
			_activeButton.title = @"←";
			break;
		case DEFAULT_KEY_CODE_TWO_RIGHT:
			_activeButton.title = @"→";
			break;
		case DEFAULT_KEY_CODE_TWO_UP:
			_activeButton.title = @"↑";
			break;
		case DEFAULT_KEY_CODE_TWO_DOWN:
			_activeButton.title = @"↓";
			break;
		
		default:
			_activeButton.title = event.characters;
			break;
	}
	
	_activeButton.state = NO;
	_activeButton = nil;
	[_messageLabel setHidden:YES];
	
	[[Settings sharedSettings] save];
}

@end
