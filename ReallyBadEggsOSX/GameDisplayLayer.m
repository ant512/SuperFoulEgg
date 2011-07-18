#import "GameDisplayLayer.h"
#import "GameScene.h"

@implementation GameDisplayLayer

- (void)nextFrame:(ccTime)dt {
	[((GameScene*)self.parent).runner1 iterate];
}

-(BOOL)ccKeyUp:(NSEvent*)event {
	
	NSString * character = [event characters];
    unichar keyCode = [character characterAtIndex: 0];
	
	printf("%d", keyCode);
	
	/*
	 // Set pressed key to true
	 if (keyCode == 0xF700) { _movement[0] = NO; } // Up
	 if (keyCode == 0xF701) { _movement[1] = NO; } // Down
	 if (keyCode == 0xF702) { _movement[2] = NO; } // Left
	 if (keyCode == 0xF703) { _movement[3] = NO; } // Right
	 
	 // Other keys
	 if (keyCode == 27) { } // Escape
	 */
	
	return YES;
}

-(BOOL)ccKeyDown:(NSEvent*)event {
	
	NSString * character = [event characters];
    unichar keyCode = [character characterAtIndex: 0];
	
	printf("%d", keyCode);
	
	/*
	 // Set pressed key to true
	 if (keyCode == 0xF700) { _movement[0] = YES; } // Up
	 if (keyCode == 0xF701) { _movement[1] = YES; } // Down
	 if (keyCode == 0xF702) { _movement[2] = YES; } // Left
	 if (keyCode == 0xF703) { _movement[3] = YES; } // Right
	 
	 // Other keys
	 if (keyCode == 27) { } // Escape
	 */
	
	return YES;
}

@end
