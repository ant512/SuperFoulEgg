#import "GameDisplayLayer.h"
#import "GameScene.h"
#import "PlayerController.h"
#import "Pad.h"

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
	[[Pad instance] update];
}

-(BOOL)ccKeyUp:(NSEvent*)event {
	
	NSString * character = [event characters];
    unichar keyCode = [character characterAtIndex: 0];

    id <ControllerProtocol> controller = _runner1.controller;
	
	if (keyCode == 0xF700) [[Pad instance] releaseUp];
	if (keyCode == 0xF701) [[Pad instance] releaseDown];
	if (keyCode == 0xF702) [[Pad instance] releaseLeft];
	if (keyCode == 0xF703) [[Pad instance] releaseRight];

	// Other keys
	if (keyCode == 27) { } // Escape
	
	return YES;
}

-(BOOL)ccKeyDown:(NSEvent*)event {
	
	NSString * character = [event characters];
    unichar keyCode = [character characterAtIndex: 0];

    id <ControllerProtocol> controller = _runner1.controller;
	
	if (keyCode == 0xF700) [[Pad instance] pressUp];
	if (keyCode == 0xF701) [[Pad instance] pressDown];
	if (keyCode == 0xF702) [[Pad instance] pressLeft];
	if (keyCode == 0xF703) [[Pad instance] pressRight];
	
	// Other keys
	if (keyCode == 27) { } // Escape
	
	return YES;
}

@end
