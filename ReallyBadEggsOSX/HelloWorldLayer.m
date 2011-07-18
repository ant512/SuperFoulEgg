//
//  HelloWorldLayer.m
//  ReallyBadEggsOSX
//
//  Created by Antony Dzeryn on 16/07/2011.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// HelloWorldLayer implementation
@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		
		// Load sprite sheet definitions
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"red.plist"];
		
		// Create sprite sheet from cached definitions
		CCSpriteBatchNode* spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"red.png"];
		[self addChild:spriteSheet];
		
		
		NSMutableArray* animFrames = [NSMutableArray array];
		
		for (int i = 0; i < 24; ++i) {
			[animFrames addObject:
			 [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
			  [NSString stringWithFormat:@"red%02d.png", i]]];
		}
		
		CCAnimation* anim = [CCAnimation animationWithFrames:animFrames delay:0.1f];
		
		CGSize winSize = [CCDirector sharedDirector].winSize;
		
		CCSprite* sprite = [CCSprite spriteWithSpriteFrameName:@"red00.png"];
		sprite.position = ccp(winSize.width / 2, winSize.height / 2);
		[sprite setTextureRect:CGRectMake(16, 0, 16, 16)];
		[spriteSheet addChild:sprite];
		
		//[self addChild:sprite];
		
		
		// create and initialize a Label
		//CCLabelTTF *label = [CCLabelTTF labelWithString:@"Hello World" fontName:@"Marker Felt" fontSize:64];

		// ask director the the window size
		//CGSize size = [[CCDirector sharedDirector] winSize];
	
		// position the label on the center of the screen
		//label.position =  ccp( size.width /2 , size.height/2 );
		
		// add the label as a child to this Layer
		//[self addChild: label];
		
		[self schedule:@selector(nextFrame:)];
		
		self.isKeyboardEnabled = YES;
		
		
		
		_grid1 = [[Grid alloc] initWithHeight:2 playerNumber:0];
		
		_blockFactory = [[BlockFactory alloc] initWithPlayerCount:2 blockColourCount:4];
		_controller1 = [[AIController alloc] init];
		
		_runner1 = [[GridRunner alloc] initWithController:_controller1 grid:_grid1 blockFactory:_blockFactory playerNumber:0 x:0 gameType:GameTypeSinglePlayer speed:9];
		
		((AIController*)_controller1).gridRunner = _runner1;
		
	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	[_grid1 dealloc];
	[_grid2 dealloc];
	[(id)_controller1 dealloc];
	[(id)_controller2 dealloc];
	[_runner1 dealloc];
	[_runner2 dealloc];
	
	[super dealloc];
}

- (void)nextFrame:(ccTime)dt {
	[_runner1 iterate];
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
