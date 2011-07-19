#import "GameDisplayLayer.h"
#import "GameScene.h"
#import "PlayerController.h"

@implementation GameDisplayLayer

- (id)init {
	if ((self = [super init])) {
		[self schedule:@selector(nextFrame:)];
	
		self.isKeyboardEnabled = YES;
	}
	
	return self;
}

- (void)nextFrame:(ccTime)dt {
	[((GameScene*)self.parent).runner1 iterate];
	[((GameScene*)self.parent).runner2 iterate];
}

-(BOOL)ccKeyUp:(NSEvent*)event {
	
	PlayerController* controller = ((GameScene*)self.parent).controller1;
	
	NSString * character = [event characters];
    unichar keyCode = [character characterAtIndex: 0];
	
	 // Set pressed key to true
	if (keyCode == 0xF700) [controller setUpHeld:NO]; // Up
	if (keyCode == 0xF701) [controller setDownHeld:NO]; // Down
	if (keyCode == 0xF702) [controller setLeftHeld:NO]; // Left
	if (keyCode == 0xF703) [controller setRightHeld:NO]; // Right
	 
	// Other keys
	if (keyCode == 27) { } // Escape
	
	return YES;
}

-(BOOL)ccKeyDown:(NSEvent*)event {
	
	PlayerController* controller = ((GameScene*)self.parent).controller1;
	
	NSString * character = [event characters];
    unichar keyCode = [character characterAtIndex: 0];
	
	if (keyCode == 0xF700) [controller setUpHeld:YES]; // Up
	if (keyCode == 0xF701) [controller setDownHeld:YES]; // Down
	if (keyCode == 0xF702) [controller setLeftHeld:YES]; // Left
	if (keyCode == 0xF703) [controller setRightHeld:YES]; // Right
	
	// Other keys
	if (keyCode == 27) { } // Escape
	
	return YES;
}

@end
