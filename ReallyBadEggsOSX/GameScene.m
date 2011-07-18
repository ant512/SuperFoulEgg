#import "GameScene.h"

@implementation GameScene

@synthesize grid1 = _grid1;
@synthesize grid2 = _grid2;
@synthesize controller1 = _controller1;
@synthesize controller2 = _controller2;
@synthesize runner1 = _runner1;
@synthesize runner2 = _runner2;

-(id) init
{
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
		
		//self.isKeyboardEnabled = YES;
		
		
		
		_grid1 = [[Grid alloc] initWithHeight:2 playerNumber:0];
		
		_blockFactory = [[BlockFactory alloc] initWithPlayerCount:2 andBlockColourCount:4];
		_controller1 = [[AIController alloc] init];
		
		_runner1 = [[GridRunner alloc] initWithController:_controller1 grid:_grid1 blockFactory:_blockFactory playerNumber:0 x:0 gameType:GameTypeSinglePlayer speed:9];
		
		((AIController*)_controller1).gridRunner = _runner1;
		
	}
	return self;
}

- (void) dealloc
{
	[_grid1 dealloc];
	[_grid2 dealloc];
	[_controller1 dealloc];
	[_controller2 dealloc];
	[_runner1 dealloc];
	[_runner2 dealloc];
	
	[super dealloc];
}

@end
