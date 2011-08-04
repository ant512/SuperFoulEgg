#import "GameScene.h"

#import "RedBlock.h"
#import "GreenBlock.h"
#import "BlueBlock.h"
#import "PurpleBlock.h"
#import "YellowBlock.h"
#import "OrangeBlock.h"
#import "GarbageBlock.h"

#import "BlockSpriteConnector.h"

@implementation GameScene

@synthesize grid1 = _grid1;
@synthesize grid2 = _grid2;
@synthesize controller1 = _controller1;
@synthesize controller2 = _controller2;
@synthesize runner1 = _runner1;
@synthesize runner2 = _runner2;

-(id) init
{
	if ((self = [super init])) {

		_blockSpriteConnectors = [[NSMutableArray alloc] init];
		
		// Game components
		_blockFactory = [[BlockFactory alloc] initWithPlayerCount:2 blockColourCount:4];

		_grid1 = [[Grid alloc] initWithHeight:2 playerNumber:0 x:0 y:0];
		_grid2 = [[Grid alloc] initWithHeight:2 playerNumber:1 x:100 y:0];
		
		_controller1 = [[PlayerController alloc] init];
		_controller2 = [[AIController alloc] init];
		
		_runner1 = [[GridRunner alloc] initWithController:_controller1 grid:_grid1 blockFactory:_blockFactory playerNumber:0 gameType:GameTypeTwoPlayer speed:9];
		_runner2 = [[GridRunner alloc] initWithController:_controller2 grid:_grid2 blockFactory:_blockFactory playerNumber:1 gameType:GameTypeTwoPlayer speed:9];
		
		((AIController*)_controller2).gridRunner = _runner2;
		
		_gameDisplayLayer = [GameDisplayLayer node];
		_gameDisplayLayer.runner1 = _runner1;
		_gameDisplayLayer.runner2 = _runner2;
		
		// Callback function that runs each time a new block is added to the
		// grid.  We need to create a new sprite for the block and connect the
		// two together.
		_runner2.grid.onBlockAdd = ^(Grid* grid, BlockBase* block) {

			// Create a new sprite appropriate to the block type
			CCSprite* sprite = nil;
			CCSpriteSheet* sheet = nil;

			// TODO: Update PNG names when sprites are ready
			if ([block isKindOfClass:RedBlock]) {
				sprite = [CCSprite spriteWithSpriteFrameName:@"red00.png"];
				sheet = _gameDisplayLayer.redBlockSpriteSheet;
			} else if ([block isKindOfClass:BlueBlock]) {
				sprite = [CCSprite spriteWithSpriteFrameName:@"red00.png"];
				sheet = _gameDisplayLayer.greenBlockSpriteSheet;
			} else if ([block isKindOfClass:GreenBlock]) {
				sprite = [CCSprite spriteWithSpriteFrameName:@"red00.png"];
				sheet = _gameDisplayLayer.blueBlockSpriteSheet;
			} else if ([block isKindOfClass:YellowBlock]) {
				sprite = [CCSprite spriteWithSpriteFrameName:@"red00.png"];
				sheet = _gameDisplayLayer.yellowBlockSpriteSheet;
			} else if ([block isKindOfClass:OrangeBlock]) {
				sprite = [CCSprite spriteWithSpriteFrameName:@"red00.png"];
				sheet = _gameDisplayLayer.orangeBlockSpriteSheet;
			} else if ([block isKindOfClass:PurpleBlock]) {
				sprite = [CCSprite spriteWithSpriteFrameName:@"red00.png"];
				sheet = _gameDisplayLayer.purpleBlockSpriteSheet;
			} else if ([block isKindOfClass:GarbageBlock]) {
				sprite = [CCSprite spriteWithSpriteFrameName:@"red00.png"];
				sheet = _gameDisplayLayer.garbageBlockSpriteSheet;
			}

			//CGSize winSize = [CCDirector sharedDirector].winSize;
			//sprite.position = ccp((block.x + 1) * 16, winSize.height - ((block.y + 1) * 16));

			// Connect the sprite and block together
			BlockSpriteConnector* connector = [[BlockSpriteConnector alloc] initWithBlock:block sprite:sprite];
			[_blockSpriteConnectors addObject:connector];
			[connector release];

			[sheet addChild:sprite];
		};

		[self addChild:_gameDisplayLayer];

		[self scheduleUpdate];
	}
	return self;
}

- (void)update:(ccTime)dt {
	[_runner1 iterate];
	[_runner2 iterate];
	[[Pad instance] update];

	// Run block sprite connector logic
	for (int i = 0; i < [_blockSpriteConnectors count]; ++i) {
		if ([_blockSpriteConnectors objectAtIndex:i].isDead) {
			[_blockSpriteConnectors removeObjectAtIndex:i];
			--i;
		} else {
			[[_blockSpriteConnectors objectAtIndex:i] update];
		}
	}
}

- (void) dealloc
{
	[_grid1 release];
	[_grid2 release];
	[(id)_controller1 release];
	[(id)_controller2 release];
	[_runner1 release];
	[_runner2 release];
	[_blockSpriteConnectors release];
	
	[super dealloc];
}

@end
