#import <Foundation/Foundation.h>

#import "GameDisplayLayer.h"
#import "GameScene.h"
#import "PlayerController.h"
#import "Pad.h"
#import "SZPoint.h"

@implementation GameDisplayLayer

@synthesize runner1 = _runner1;
@synthesize runner2 = _runner2;

@synthesize redBlockSpriteSheet = _redBlockSpriteSheet;
@synthesize blueBlockSpriteSheet = _blueBlockSpriteSheet;
@synthesize greenBlockSpriteSheet = _greenBlockSpriteSheet;
@synthesize yellowBlockSpriteSheet = _yellowBlockSpriteSheet;
@synthesize orangeBlockSpriteSheet = _orangeBlockSpriteSheet;
@synthesize purpleBlockSpriteSheet = _purpleBlockSpriteSheet;
@synthesize garbageBlockSpriteSheet = _garbageBlockSpriteSheet;

- (id)init {

	if ((self = [super init])) {
	
		self.isKeyboardEnabled = YES;

		// Load sprite sheet definitions
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"red.plist"];


		// TODO: Uncomment this when the sprite sheets are ready
		/*
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"green.plist"];
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"blue.plist"];
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"yellow.plist"];
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"orange.plist"];
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"purple.plist"];
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"garbage.plist"];
		*/
		
		// Create sprite sheets from cached definitions
		// TODO: Change strings to correct PNG filenames
		_redBlockSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"red.png"];
		_greenBlockSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"red.png"];
		_blueBlockSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"red.png"];
		_yellowBlockSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"red.png"];
		_orangeBlockSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"red.png"];
		_purpleBlockSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"red.png"];
		_garbageBlockSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"red.png"];

		// Add sprite sheets to the layer
		[self addChild:_redBlockSpriteSheet];
		[self addChild:_greenBlockSpriteSheet];
		[self addChild:_blueBlockSpriteSheet];
		[self addChild:_yellowBlockSpriteSheet];
		[self addChild:_orangeBlockSpriteSheet];
		[self addChild:_purpleBlockSpriteSheet];
		[self addChild:_garbageBlockSpriteSheet];

		[[Pad instance] reset];


	}
	
	return self;
}

-(BOOL)ccKeyUp:(NSEvent*)event {
	
	NSString * character = [event characters];
    unichar keyCode = [character characterAtIndex: 0];
	
	NSLog(@"%d", keyCode);
	
	if (keyCode == 0xF700) [[Pad instance] releaseUp];
	if (keyCode == 0xF701) [[Pad instance] releaseDown];
	if (keyCode == 0xF702) [[Pad instance] releaseLeft];
	if (keyCode == 0xF703) [[Pad instance] releaseRight];
	
	if (keyCode == 0x7A) [[Pad instance] releaseA];
	if (keyCode == 0x78) [[Pad instance] releaseB];

	// Other keys
	if (keyCode == 27) { } // Escape
	
	return YES;
}

-(BOOL)ccKeyDown:(NSEvent*)event {
	
	NSString * character = [event characters];
    unichar keyCode = [character characterAtIndex: 0];
	
	if (keyCode == 0xF700) [[Pad instance] pressUp];
	if (keyCode == 0xF701) [[Pad instance] pressDown];
	if (keyCode == 0xF702) [[Pad instance] pressLeft];
	if (keyCode == 0xF703) [[Pad instance] pressRight];
	
	if (keyCode == 0x7A) [[Pad instance] pressA];
	if (keyCode == 0x78) [[Pad instance] pressB];
	
	// Other keys
	if (keyCode == 27) { } // Escape
	
	return YES;
}

@end
