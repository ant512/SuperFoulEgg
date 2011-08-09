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
@synthesize gridBottomBlockSpriteSheet = _gridBottomBlockSpriteSheet;
@synthesize gridBottomLeftBlockSpriteSheet = _gridBottomLeftBlockSpriteSheet;
@synthesize gridBottomRightBlockSpriteSheet = _gridBottomRightBlockSpriteSheet;

- (id)init {

	if ((self = [super init])) {
	
		self.isKeyboardEnabled = YES;
		
		CCSprite* playfield = [CCSprite spriteWithFile:@"playfield.png"];
		playfield.position = CGPointMake(160, 128);
		[playfield.texture setAliasTexParameters];
		[self addChild:playfield z:0];

		// Load sprite sheet definitions
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"red.plist"];
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"green.plist"];
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"blue.plist"];
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"yellow.plist"];
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"purple.plist"];
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"orange.plist"];
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"grey.plist"];
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"gridbottom.plist"];
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"gridbottomleft.plist"];
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"gridbottomright.plist"];
		
		// Create sprite sheets from cached definitions
		_redBlockSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"red.png"];
		_greenBlockSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"green.png"];
		_blueBlockSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"blue.png"];
		_yellowBlockSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"yellow.png"];
		_orangeBlockSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"orange.png"];
		_purpleBlockSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"purple.png"];
		_garbageBlockSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"grey.png"];
		_gridBottomBlockSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"gridbottom.png"];
		_gridBottomLeftBlockSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"gridbottomleft.png"];
		_gridBottomRightBlockSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"gridbottomright.png"];
		
		// Disable anti-aliasing on all sprite sheets
		[_redBlockSpriteSheet.texture setAliasTexParameters];
		[_greenBlockSpriteSheet.texture setAliasTexParameters];
		[_blueBlockSpriteSheet.texture setAliasTexParameters];
		[_yellowBlockSpriteSheet.texture setAliasTexParameters];
		[_orangeBlockSpriteSheet.texture setAliasTexParameters];
		[_purpleBlockSpriteSheet.texture setAliasTexParameters];
		[_garbageBlockSpriteSheet.texture setAliasTexParameters];
		[_gridBottomBlockSpriteSheet.texture setAliasTexParameters];
		[_gridBottomLeftBlockSpriteSheet.texture setAliasTexParameters];
		[_gridBottomRightBlockSpriteSheet.texture setAliasTexParameters];

		// Add sprite sheets to the layer
		[self addChild:_redBlockSpriteSheet];
		[self addChild:_greenBlockSpriteSheet];
		[self addChild:_blueBlockSpriteSheet];
		[self addChild:_yellowBlockSpriteSheet];
		[self addChild:_orangeBlockSpriteSheet];
		[self addChild:_purpleBlockSpriteSheet];
		[self addChild:_garbageBlockSpriteSheet];
		[self addChild:_gridBottomBlockSpriteSheet];
		[self addChild:_gridBottomLeftBlockSpriteSheet];
		[self addChild:_gridBottomRightBlockSpriteSheet];

		[[Pad instance] reset];
	}
	
	return self;
}

-(BOOL)ccKeyUp:(NSEvent*)event {
	
	NSString * character = [event characters];
    unichar keyCode = [character characterAtIndex: 0];
	
	if (keyCode == 0xF700) [[Pad instance] releaseUp];
	if (keyCode == 0xF701) [[Pad instance] releaseDown];
	if (keyCode == 0xF702) [[Pad instance] releaseLeft];
	if (keyCode == 0xF703) [[Pad instance] releaseRight];
	
	if (keyCode == 0x78) [[Pad instance] releaseA];
	if (keyCode == 0x7A) [[Pad instance] releaseB];

	// Other keys
	if (keyCode == 27) { } // Escape
	
	//[[CCDirector sharedDirector] pause];
	
	return YES;
}

-(BOOL)ccKeyDown:(NSEvent*)event {
	
	NSString * character = [event characters];
    unichar keyCode = [character characterAtIndex: 0];
	
	if (keyCode == 0xF700) [[Pad instance] pressUp];
	if (keyCode == 0xF701) [[Pad instance] pressDown];
	if (keyCode == 0xF702) [[Pad instance] pressLeft];
	if (keyCode == 0xF703) [[Pad instance] pressRight];
	
	if (keyCode == 0x78) [[Pad instance] pressA];
	if (keyCode == 0x7A) [[Pad instance] pressB];
	
	// Other keys
	if (keyCode == 27) { } // Escape
	
	return YES;
}

@end
