#import "GameScene.h"

#import "RedBlock.h"
#import "GreenBlock.h"
#import "BlueBlock.h"
#import "PurpleBlock.h"
#import "YellowBlock.h"
#import "OrangeBlock.h"
#import "GarbageBlock.h"

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
		
		_runner2.grid.onBlockAdd = ^(Grid* grid, BlockBase* block) {
			
			CGSize winSize = [CCDirector sharedDirector].winSize;
			
			CCSprite* sprite = [CCSprite spriteWithSpriteFrameName:@"red00.png"];
			//sprite.position = ccp((block.x + 1) * 16, winSize.height - ((block.y + 1) * 16));
			sprite.position = ccp(100 + (block.x * 16), 200 - (block.y * 16));
			[sprite setTextureRect:CGRectMake(16, 0, 16, 16)];
			 
			[[_gameDisplayLayer getChildByTag:1] addChild:sprite];
			
			block.sprite = sprite;
		};
        
		/*
        _runner2.onLiveBlockAdd = ^(GridRunner* sender) {
            
            Grid* grid = sender.grid;
            
            for (int y = 0; y < GRID_HEIGHT; ++y) {
                for (int x = 0; x < GRID_WIDTH; ++x) {
                    
                    BlockBase* block = [grid blockAtCoordinatesX:x y:y];
                    
                    if ([block isKindOfClass:[RedBlock class]]) {
                        printf("1");
                    } else if ([block isKindOfClass:[GreenBlock class]]) {
                        printf("2");
                    } else if ([block isKindOfClass:[BlueBlock class]]) {
                        printf("3");
                    } else if ([block isKindOfClass:[OrangeBlock class]]) {
                        printf("4");
                    } else if ([block isKindOfClass:[PurpleBlock class]]) {
                        printf("5");
                    } else if ([block isKindOfClass:[YellowBlock class]]) {
                        printf("6");
                    } else if ([block isKindOfClass:[GarbageBlock class]]) {
                        printf("7");
                    } else {
                        printf("0");
                    }
                }
                
                printf("\n");
            }
        };*/
		
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
