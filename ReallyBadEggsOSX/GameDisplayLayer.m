#import "GameDisplayLayer.h"
#import "GameScene.h"
#import "PlayerController.h"

@implementation GameDisplayLayer

@synthesize runner1 = _runner1;
@synthesize runner2 = _runner2;

- (id)init {

	if ((self = [super init])) {

		[self schedule:@selector(nextFrame:)];
	
		self.isKeyboardEnabled = YES;

		// Load sprite sheet definitions
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"red.plist"];
		
		// Create sprite sheet from cached definitions
		CCSpriteBatchNode* spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"red.png"];
		[self addChild:spriteSheet];
		
		// Create animation - do we need this?
		NSMutableArray* animFrames = [NSMutableArray array];
		
		for (int i = 0; i < 24; ++i) {
			[animFrames addObject:
			 [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
			  [NSString stringWithFormat:@"red%02d.png", i]]];
		}
		
		CCAnimation* anim = [CCAnimation animationWithFrames:animFrames delay:0.1f];
		
		// Add test sprite to middle of window
		CGSize winSize = [CCDirector sharedDirector].winSize;
		
		CCSprite* sprite = [CCSprite spriteWithSpriteFrameName:@"red00.png"];
		sprite.position = ccp(winSize.width / 2, winSize.height / 2);
		[sprite setTextureRect:CGRectMake(16, 0, 16, 16)];
		[spriteSheet addChild:sprite];
	}
	
	return self;
}

- (void)nextFrame:(ccTime)dt {
	[_runner1 iterate];
	[_runner2 iterate];
}

-(BOOL)ccKeyUp:(NSEvent*)event {
	
	NSString * character = [event characters];
    unichar keyCode = [character characterAtIndex: 0];

    id <ControllerProtocol> controller = _runner1.controller;
	
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
	
	NSString * character = [event characters];
    unichar keyCode = [character characterAtIndex: 0];

    id <ControllerProtocol> controller = _runner1.controller;
	
	if (keyCode == 0xF700) [controller setUpHeld:YES]; // Up
	if (keyCode == 0xF701) [controller setDownHeld:YES]; // Down
	if (keyCode == 0xF702) [controller setLeftHeld:YES]; // Left
	if (keyCode == 0xF703) [controller setRightHeld:YES]; // Right
	
	// Other keys
	if (keyCode == 27) { } // Escape
	
	return YES;
}

@end
