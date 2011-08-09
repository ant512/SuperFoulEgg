#import "GameScene.h"

#import "cocos2d.h"
#import "SimpleAudioEngine.h"
#import "CDAudioManager.h"
#import "CocosDenshion.h"

#import "RedBlock.h"
#import "GreenBlock.h"
#import "BlueBlock.h"
#import "PurpleBlock.h"
#import "YellowBlock.h"
#import "OrangeBlock.h"
#import "GarbageBlock.h"
#import "GridBottomBlock.h"
#import "GridBottomLeftBlock.h"
#import "GridBottomRightBlock.h"

#import "Pad.h"

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
		
		_state = GameActiveState;
		
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"chain.wav"];
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"dead.wav"];
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"drop.wav"];
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"garbage.wav"];
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"garbagebig.wav"];
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"land.wav"];
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"lose.wav"];
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"move.wav"];
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"multichain1.wav"];
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"multichain2.wav"];
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"pause.wav"];
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"rotate.wav"];
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"win.wav"];

		_blockSpriteConnectors[0] = [[NSMutableArray alloc] init];
		_blockSpriteConnectors[1] = [[NSMutableArray alloc] init];
		
		// Game components
		_blockFactory = [[BlockFactory alloc] initWithPlayerCount:2 blockColourCount:4];

		_grid1 = [[Grid alloc] initWithPlayerNumber:0];
		_grid2 = [[Grid alloc] initWithPlayerNumber:1];
		
		_controller1 = [[PlayerController alloc] init];
		_controller2 = [[AIController alloc] initWithHesitation:0];
		
		_runner1 = [[GridRunner alloc] initWithController:_controller1 grid:_grid1 blockFactory:_blockFactory playerNumber:0 speed:0];
		_runner2 = [[GridRunner alloc] initWithController:_controller2 grid:_grid2 blockFactory:_blockFactory playerNumber:1 speed:0];
		
		((AIController*)_controller2).gridRunner = _runner2;
		
		_gameDisplayLayer = [GameDisplayLayer node];
		_gameDisplayLayer.runner1 = _runner1;
		_gameDisplayLayer.runner2 = _runner2;
		
		// Reference self in a way that blocks can use it without retaining it
		__block GameScene* scene = self;
		
		// Callback function that runs each time a new block is added to the
		// grid.  We need to create a new sprite for the block and connect the
		// two together.
		_runner1.onNextBlocksCreated = ^(GridRunner* runner) {

			int gridX = runner == _runner1 ? 136 : 182;
			int gridY = -46;
			
			NSMutableArray* connectorArray = _blockSpriteConnectors[runner == _runner1 ? 0 : 1];

			// Create a new sprite for both next blocks
			for (int i = 0; i < 2; ++i) {
				[scene createBlockSpriteConnector:[runner nextBlock:i] gridX:gridX gridY:gridY connectorArray:connectorArray];
				gridX += BLOCK_SIZE;
			}
		};
		
		_grid1.onBlockAdd = ^(Grid* grid, BlockBase* block) {
			
			int gridX = grid == _grid1 ? 16 : 208;
			int gridY = 0;
			
			NSMutableArray* connectorArray = _blockSpriteConnectors[grid == _grid1 ? 0 : 1];
			
			// If there is already a connector for this block, we need to adjust
			// its grid co-ordinates back to the real values.  At present the
			// co-ords are being abused to make the sprite appear in the "next
			// block" location
			for (BlockSpriteConnector* connector in connectorArray) {
				if (connector.block == block) {
					connector.gridX = gridX;
					connector.gridY = gridY;
					
					[connector updateSpritePosition];
					
					return;
				}
			}
			
			// No existing block exists (this must be a garbage block) so create
			// the connector
			[scene createBlockSpriteConnector:block gridX:gridX gridY:gridY connectorArray:connectorArray];
		};

		// Callback function that runs each time a garbage block lands.  It
		// offsets all of the blocks in the column so that the column appears to
		// squash under the garbage weight.
		_grid1.onGarbageBlockLand = ^(Grid* grid, BlockBase* block) {
			
			int index = grid == _grid1 ? 0 : 1;
			
			for (BlockSpriteConnector* connector in _blockSpriteConnectors[index]) {
				if (connector.block.x == block.x) {
					[connector hitWithGarbage];
				}
			}
		};
		
		_grid1.onGarbageLand = ^(Grid* grid) {
			CGFloat pan = grid == _grid1 ? -1.0 : 1.0;
			[[SimpleAudioEngine sharedEngine] playEffect:@"garbage.wav" pitch:1.0 pan:pan gain:1.0];
		};
		
		_grid1.onLand = ^(Grid* grid) {
			CGFloat pan = grid == _grid1 ? -1.0 : 1.0;
			[[SimpleAudioEngine sharedEngine] playEffect:@"land.wav" pitch:1.0 pan:pan gain:1.0];
		};
		
		_grid1.onGarbageRowAdded = ^(Grid* grid) {
			CGFloat pan = grid == _grid1 ? -1.0 : 1.0;
			[[SimpleAudioEngine sharedEngine] playEffect:@"garbagebig.wav" pitch:1.0 pan:pan gain:1.0];
		};
		
		_runner1.onLiveBlockMove = ^(GridRunner* runner) {
			CGFloat pan = runner == _runner1 ? -1.0 : 1.0;
			[[SimpleAudioEngine sharedEngine] playEffect:@"move.wav" pitch:1.0 pan:pan gain:1.0];
		};
		
		_runner1.onLiveBlockRotate = ^(GridRunner* runner) {
			CGFloat pan = runner == _runner1 ? -1.0 : 1.0;
			[[SimpleAudioEngine sharedEngine] playEffect:@"rotate.wav" pitch:1.0 pan:pan gain:1.0];
		};
		
		_runner1.onLiveBlockDropStart = ^(GridRunner* runner) {
			CGFloat pan = runner == _runner1 ? -1.0 : 1.0;
			[[SimpleAudioEngine sharedEngine] playEffect:@"drop.wav" pitch:1.0 pan:pan gain:1.0];
		};
		
		_runner1.onChainExploded = ^(GridRunner* runner, int sequence) {
			
			CGFloat pan = runner == _runner1 ? -1.0 : 1.0;
			[[SimpleAudioEngine sharedEngine] playEffect:@"chain.wav" pitch:(1.0 + (sequence * 0.05)) pan:pan gain:1.0];
		};
		
		_runner1.onMultipleChainsExploded = ^(GridRunner* runner) {
			
			NSString* file;
			CGFloat pan;
			
			if (runner == _runner1) {
				file = @"multichain1.wav";
				pan = -1.0;
			} else {
				file = @"multichain2.wav";
				pan = 1.0;
			}
			
			[[SimpleAudioEngine sharedEngine] playEffect:file pitch:1.0 pan:pan gain:1.0];
		};

		// Since closures are copied, we can use the same closures for both
		// grids/runners
		_runner2.onNextBlocksCreated = _runner1.onNextBlocksCreated;
		_runner2.onLiveBlockMove = _runner1.onLiveBlockMove;
		_runner2.onLiveBlockRotate = _runner1.onLiveBlockRotate;
		_runner2.onLiveBlockDropStart = _runner2.onLiveBlockDropStart;
		_runner2.onChainExploded = _runner1.onChainExploded;
		_runner2.onMultipleChainsExploded = _runner1.onMultipleChainsExploded;
		
		_grid2.onBlockAdd = _grid1.onBlockAdd;
		_grid2.onGarbageBlockLand = _grid1.onGarbageBlockLand;
		_grid2.onGarbageRowAdded = _grid1.onGarbageRowAdded;
		_grid2.onGarbageLand = _grid1.onGarbageLand;
		_grid2.onLand = _grid1.onLand;

		[self addChild:_gameDisplayLayer];
		
		[_grid1 createBottomRow];
		[_grid2 createBottomRow];

		[_grid1 addGarbage:6];
		[_grid2 addGarbage:6];
		
		[self scheduleUpdate];
	}
	return self;
}

- (void)update:(ccTime)dt {
	
	// ccTime is measured in fractions of a second; we need it in frames per
	// second, using 60fps as the framerate
	int frames = (int)(round(2.0f * dt * 60) / 2.0f);

	// Ensure that at least one frame will be processed
	if (frames == 0) frames = 1;
	
	switch (_state) {
		case GameActiveState:
			for (int i = 0; i < frames; ++i) {
				[self iterateGame];
			}
			break;
		case GamePausedState:
			break;
		case GameOverState:
			break;
	}


}

- (void)iterateGame {
	
	[_runner1 iterate];
	
	if (_runner2 == nil) {
		if (_runner1.isDead) {
			[[SimpleAudioEngine sharedEngine] playEffect:@"dead.wav"];
		}
	} else {
		[_runner2 iterate];
		
		if (_runner1.isDead && !_runner2.isDead) {
			
			// TODO: Player one dead
			
			[[SimpleAudioEngine sharedEngine] playEffect:@"dead.wav"];
			_state = GameOverState;
		} else if (_runner2.isDead && !_runner1.isDead) {
			
			// TODO: Player two dead
			
			[[SimpleAudioEngine sharedEngine] playEffect:@"dead.wav"];
			_state = GameOverState;
		} else if (_runner2.isDead && _runner1.isDead) {
			
			// TODO: Both dead
			
			[[SimpleAudioEngine sharedEngine] playEffect:@"dead.wav"];
			_state = GameOverState;
		}
		
		// Move garbage from one runner to the other
		if ([_runner1 addIncomingGarbage:_runner2.outgoingGarbageCount]) {
			[_runner2 clearOutgoingGarbageCount];
		}
		
		if ([_runner2 addIncomingGarbage:_runner1.outgoingGarbageCount]) {
			[_runner1 clearOutgoingGarbageCount];
		}
		
		[self updateBlockSpriteConnectors];
	}
	
	[[Pad instance] update];
}

- (void)updateBlockSpriteConnectors {

	for (int j = 0; j < 2; ++j) {
		for (int i = 0; i < [_blockSpriteConnectors[j] count]; ++i) {
			if (((BlockSpriteConnector*)[_blockSpriteConnectors[j] objectAtIndex:i]).isDead) {
				[_blockSpriteConnectors[j] removeObjectAtIndex:i];
				--i;
			} else {
				[[_blockSpriteConnectors[j] objectAtIndex:i] update];
			}
		}
	}
}

- (void)dealloc {
	[_grid1 release];
	[_grid2 release];
	[(id)_controller1 release];
	[(id)_controller2 release];
	[_runner1 release];
	[_runner2 release];
	[_blockFactory release];
	
	[[SimpleAudioEngine sharedEngine] unloadEffect:@"chain.wav"];
	[[SimpleAudioEngine sharedEngine] unloadEffect:@"dead.wav"];
	[[SimpleAudioEngine sharedEngine] unloadEffect:@"drop.wav"];
	[[SimpleAudioEngine sharedEngine] unloadEffect:@"garbage.wav"];
	[[SimpleAudioEngine sharedEngine] unloadEffect:@"garbagebig.wav"];
	[[SimpleAudioEngine sharedEngine] unloadEffect:@"land.wav"];
	[[SimpleAudioEngine sharedEngine] unloadEffect:@"lose.wav"];
	[[SimpleAudioEngine sharedEngine] unloadEffect:@"move.wav"];
	[[SimpleAudioEngine sharedEngine] unloadEffect:@"multichain1.wav"];
	[[SimpleAudioEngine sharedEngine] unloadEffect:@"multichain2.wav"];
	[[SimpleAudioEngine sharedEngine] unloadEffect:@"pause.wav"];
	[[SimpleAudioEngine sharedEngine] unloadEffect:@"rotate.wav"];
	[[SimpleAudioEngine sharedEngine] unloadEffect:@"win.wav"];
	
	for (int i = 0; i < 2; ++i) {
		[_blockSpriteConnectors[i] release];
	}
	
	[super dealloc];
}

- (void)createBlockSpriteConnector:(BlockBase*)block gridX:(int)gridX gridY:(int)gridY connectorArray:(NSMutableArray*)connectorArray {

	CCSprite* sprite = nil;
	CCSpriteBatchNode* sheet = nil;
	
	if ([block isKindOfClass:[RedBlock class]]) {
		sprite = [CCSprite spriteWithSpriteFrameName:@"red00.png"];
		sheet = _gameDisplayLayer.redBlockSpriteSheet;
	} else if ([block isKindOfClass:[GreenBlock class]]) {
		sprite = [CCSprite spriteWithSpriteFrameName:@"green00.png"];
		sheet = _gameDisplayLayer.greenBlockSpriteSheet;
	} else if ([block isKindOfClass:[BlueBlock class]]) {
		sprite = [CCSprite spriteWithSpriteFrameName:@"blue00.png"];
		sheet = _gameDisplayLayer.blueBlockSpriteSheet;
	} else if ([block isKindOfClass:[YellowBlock class]]) {
		sprite = [CCSprite spriteWithSpriteFrameName:@"yellow00.png"];
		sheet = _gameDisplayLayer.yellowBlockSpriteSheet;
	} else if ([block isKindOfClass:[OrangeBlock class]]) {
		sprite = [CCSprite spriteWithSpriteFrameName:@"orange00.png"];
		sheet = _gameDisplayLayer.orangeBlockSpriteSheet;
	} else if ([block isKindOfClass:[PurpleBlock class]]) {
		sprite = [CCSprite spriteWithSpriteFrameName:@"purple00.png"];
		sheet = _gameDisplayLayer.purpleBlockSpriteSheet;
	} else if ([block isKindOfClass:[GarbageBlock class]]) {
		sprite = [CCSprite spriteWithSpriteFrameName:@"grey00.png"];
		sheet = _gameDisplayLayer.garbageBlockSpriteSheet;
	} else if ([block isKindOfClass:[GridBottomBlock class]]) {
		sprite = [CCSprite spriteWithSpriteFrameName:@"gridbottom00.png"];
		sheet = _gameDisplayLayer.gridBottomBlockSpriteSheet;
	} else if ([block isKindOfClass:[GridBottomLeftBlock class]]) {
		sprite = [CCSprite spriteWithSpriteFrameName:@"gridbottomleft00.png"];
		sheet = _gameDisplayLayer.gridBottomLeftBlockSpriteSheet;
	} else if ([block isKindOfClass:[GridBottomRightBlock class]]) {
		sprite = [CCSprite spriteWithSpriteFrameName:@"gridbottomright00.png"];
		sheet = _gameDisplayLayer.gridBottomRightBlockSpriteSheet;
	}
	
	// Connect the sprite and block together
	BlockSpriteConnector* connector = [[BlockSpriteConnector alloc] initWithBlock:block sprite:sprite gridX:gridX gridY:gridY];
	[connectorArray addObject:connector];
	
	[sheet addChild:sprite];
}

@end
