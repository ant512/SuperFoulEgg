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
	if ((self = [super init])) {
		
		// Game components
		_blockFactory = [[BlockFactory alloc] initWithPlayerCount:2 blockColourCount:4];

		_grid1 = [[Grid alloc] initWithHeight:2 playerNumber:0];
		_grid2 = [[Grid alloc] initWithHeight:2 playerNumber:1];
		
		_controller1 = [[PlayerController alloc] init];
		_controller2 = [[AIController alloc] init];
		
		_runner1 = [[GridRunner alloc] initWithController:_controller1 grid:_grid1 blockFactory:_blockFactory playerNumber:0 x:0 gameType:GameTypeTwoPlayer speed:9];
		_runner2 = [[GridRunner alloc] initWithController:_controller2 grid:_grid2 blockFactory:_blockFactory playerNumber:1 x:100 gameType:GameTypeTwoPlayer speed:9];
		
		((AIController*)_controller2).gridRunner = _runner2;
		
		_gameDisplayLayer = [GameDisplayLayer node];
		_gameDisplayLayer.runner1 = _runner1;
		_gameDisplayLayer.runner2 = _runner2;
		
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
