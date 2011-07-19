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
		
		_grid1 = [[Grid alloc] initWithHeight:2 playerNumber:0];
		_grid2 = [[Grid alloc] initWithHeight:2 playerNumber:1];
		
		_blockFactory = [[BlockFactory alloc] initWithPlayerCount:2 blockColourCount:4];
		_controller1 = [[PlayerController alloc] init];
		_controller2 = [[AIController alloc] init];
		
		_runner1 = [[GridRunner alloc] initWithController:_controller1 grid:_grid1 blockFactory:_blockFactory playerNumber:0 x:0 gameType:GameTypeTwoPlayer speed:9];
		_runner2 = [[GridRunner alloc] initWithController:_controller2 grid:_grid2 blockFactory:_blockFactory playerNumber:1 x:100 gameType:GameTypeTwoPlayer speed:9];

		
		((AIController*)_controller2).gridRunner = _runner2;
		
		_gameDisplayLayer = [GameDisplayLayer node];
		
		[self addChild:_gameDisplayLayer];
	}
	return self;
}

- (void) dealloc
{
	[_grid1 release];
	[_grid2 release];
	[(id)_controller1 release];
	[(id)_controller2 release];
	[_runner1 release];
	[_runner2 release];
	
	[super dealloc];
}

@end
