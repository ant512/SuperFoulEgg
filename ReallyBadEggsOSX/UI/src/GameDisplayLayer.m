#import <Foundation/Foundation.h>

#import "cocos2d.h"
#import "SimpleAudioEngine.h"
#import "CDAudioManager.h"
#import "CocosDenshion.h"

#import "GameDisplayLayer.h"
#import "PlayerController.h"
#import "Pad.h"
#import "SZPoint.h"

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
#import "Settings.h"

@implementation GameDisplayLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameDisplayLayer *layer = [GameDisplayLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
	if ((self = [super init])) {
		
		sranddev();
		
		self.isKeyboardEnabled = YES;
		
		_blockFactory = nil;
		
		for (int i = 0; i < MAX_PLAYERS; ++i) {
			_grids[i] = nil;
			_controllers[i] = nil;
			_runners[i] = nil;
			_blockSpriteConnectors[i] = nil;
			_incomingGarbageSprites[i] = nil;

			_matchWinsLabels[i] = nil;
			_gameWinsLabels[i] = nil;

			_matchWins[i] = 0;
			_gameWins[i] = 0;
		}
		
		[self loadBackground];
		[self prepareSpriteSheets];
		[self loadSounds];
		[self resetGame];
		[self createWinLabels];

		[self scheduleUpdate];
	}
	return self;
}

- (void)setupCallbacks {

	// Reference self in a way that blocks can use it without retaining it
	__block GameDisplayLayer* layer = self;
	
	// Callback function that runs each time a new block is added to the
	// grid.  We need to create a new sprite for the block and connect the
	// two together.
	_runners[0].onNextBlocksCreated = ^(GridRunner* runner) {
		
		int gridX = runner == _runners[0] ? 136 : 182;
		int gridY = -46;
		
		NSMutableArray* connectorArray = _blockSpriteConnectors[runner == _runners[0] ? 0 : 1];
		
		// Create a new sprite for both next blocks
		for (int i = 0; i < 2; ++i) {
			[layer createBlockSpriteConnector:[runner nextBlock:i] gridX:gridX gridY:gridY connectorArray:connectorArray];
			gridX += BLOCK_SIZE;
		}
	};
	
	_grids[0].onBlockAdd = ^(Grid* grid, BlockBase* block) {
		
		int gridX = grid == _grids[0] ? 16 : 208;
		int gridY = 0;
		
		NSMutableArray* connectorArray = _blockSpriteConnectors[grid == _grids[0] ? 0 : 1];
		
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
		[layer createBlockSpriteConnector:block gridX:gridX gridY:gridY connectorArray:connectorArray];
	};
	
	// Callback function that runs each time a garbage block lands.  It
	// offsets all of the blocks in the column so that the column appears to
	// squash under the garbage weight.
	_grids[0].onGarbageBlockLand = ^(Grid* grid, BlockBase* block) {
		
		int index = grid == _grids[0] ? 0 : 1;
		
		for (BlockSpriteConnector* connector in _blockSpriteConnectors[index]) {
			if (connector.block.x == block.x) {
				[connector hitWithGarbage];
			}
		}
	};
	
	_grids[0].onGarbageLand = ^(Grid* grid) {
		CGFloat pan = grid == _grids[0] ? -1.0 : 1.0;
		[[SimpleAudioEngine sharedEngine] playEffect:@"garbage.wav" pitch:1.0 pan:pan gain:1.0];
	};
	
	_grids[0].onLand = ^(Grid* grid) {
		CGFloat pan = grid == _grids[0] ? -1.0 : 1.0;
		[[SimpleAudioEngine sharedEngine] playEffect:@"land.wav" pitch:1.0 pan:pan gain:1.0];
	};
	
	_grids[0].onGarbageRowAdded = ^(Grid* grid) {
		CGFloat pan = grid == _grids[0] ? -1.0 : 1.0;
		[[SimpleAudioEngine sharedEngine] playEffect:@"garbagebig.wav" pitch:1.0 pan:pan gain:1.0];
	};
	
	_runners[0].onLiveBlockMove = ^(GridRunner* runner) {
		CGFloat pan = runner == _runners[0] ? -1.0 : 1.0;
		[[SimpleAudioEngine sharedEngine] playEffect:@"move.wav" pitch:1.0 pan:pan gain:1.0];
	};
	
	_runners[0].onLiveBlockRotate = ^(GridRunner* runner) {
		CGFloat pan = runner == _runners[0] ? -1.0 : 1.0;
		[[SimpleAudioEngine sharedEngine] playEffect:@"rotate.wav" pitch:1.0 pan:pan gain:1.0];
	};
	
	_runners[0].onLiveBlockDropStart = ^(GridRunner* runner) {
		CGFloat pan = runner == _runners[0] ? -1.0 : 1.0;
		[[SimpleAudioEngine sharedEngine] playEffect:@"drop.wav" pitch:1.0 pan:pan gain:1.0];
	};
	
	_runners[0].onChainExploded = ^(GridRunner* runner, int sequence) {
		
		CGFloat pan = runner == _runners[0] ? -1.0 : 1.0;
		[[SimpleAudioEngine sharedEngine] playEffect:@"chain.wav" pitch:(1.0 + (sequence * 0.05)) pan:pan gain:1.0];
	};
	
	_runners[0].onMultipleChainsExploded = ^(GridRunner* runner) {
		
		NSString* file;
		CGFloat pan;
		
		if (runner == _runners[0]) {
			file = @"multichain1.wav";
			pan = -1.0;
		} else {
			file = @"multichain2.wav";
			pan = 1.0;
		}
		
		[[SimpleAudioEngine sharedEngine] playEffect:file pitch:1.0 pan:pan gain:1.0];
	};
	
	_runners[0].onIncomingGarbageCleared = ^(GridRunner* runner) {
		[self updateIncomingGarbageDisplayForRunner:runner];
	};

	// Since closures are copied, we can use the same closures for both
	// grids/runners
	int players = [Settings sharedSettings].gameType == GamePracticeType ? 1 : 2;
	
	if (players > 1) {
		_runners[1].onNextBlocksCreated = _runners[0].onNextBlocksCreated;
		_runners[1].onLiveBlockMove = _runners[0].onLiveBlockMove;
		_runners[1].onLiveBlockRotate = _runners[0].onLiveBlockRotate;
		_runners[1].onChainExploded = _runners[0].onChainExploded;
		_runners[1].onMultipleChainsExploded = _runners[0].onMultipleChainsExploded;
		_runners[1].onIncomingGarbageCleared = _runners[0].onIncomingGarbageCleared;
		
		_grids[1].onBlockAdd = _grids[0].onBlockAdd;
		_grids[1].onGarbageBlockLand = _grids[0].onGarbageBlockLand;
		_grids[1].onGarbageRowAdded = _grids[0].onGarbageRowAdded;
		_grids[1].onGarbageLand = _grids[0].onGarbageLand;
		_grids[1].onLand = _grids[0].onLand;
	}
}

- (void)loadSounds {
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
}

- (void)unloadSounds {
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
}

- (void)prepareSpriteSheets {
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
	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"incoming.plist"];
	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"message.plist"];
	
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
	_incomingSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"incoming.png"];
	_messageSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"message.png"];
	
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
	[_incomingSpriteSheet.texture setAliasTexParameters];
	[_messageSpriteSheet.texture setAliasTexParameters];
	
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
	[self addChild:_incomingSpriteSheet];
	[self addChild:_messageSpriteSheet];
}

- (void)loadBackground {
	int x = [[CCDirector sharedDirector] winSize].width / 2;
	int y = [[CCDirector sharedDirector] winSize].height / 2;

	CCSprite* playfield = [CCSprite spriteWithFile:@"playfield.png"];
	playfield.position = CGPointMake(x, y);
	[playfield.texture setAliasTexParameters];
	[self addChild:playfield z:0];
}

- (void)runGameOverEffectState {

	// Work out who lost
	int loser = 0;
	
	if (_runners[1] != nil) {
		if (_runners[0].isDead && !_runners[1].isDead) {
			loser = 0;
		} else if (_runners[1].isDead && !_runners[0].isDead) {
			loser = 1;
		}
	}
	
	// Dribble sprites of loser off screen
	BOOL requiresIteration = NO;
	
	if (_deathEffectTimer % 8 == 0) {
		for (BlockSpriteConnector* connector in _blockSpriteConnectors[loser]) {
			
			CCSprite* sprite = connector.sprite;
			BlockBase* block = connector.block;
			
			// Don't drop the next block sprites
			if (block == [_runners[loser] nextBlock:0] || block == [_runners[loser] nextBlock:1]) {
				continue;
			}
			
			if ((_deathEffectTimer > 0 && (block.x == 2 || block.x == 3)) ||
				(_deathEffectTimer > 8 && (block.x == 1 || block.x == 4)) ||
				(_deathEffectTimer > 16)) {
				sprite.position = ccp(sprite.position.x, sprite.position.y - (BLOCK_SIZE / 2));
			}
			
			if (sprite.position.y > -BLOCK_SIZE / 2) {
				requiresIteration = YES;
			}
		}
	} else {
		requiresIteration = YES;
	}
	
	if (!requiresIteration) {
		_state = GameOverState;
		
		if (loser == 0) {
			++_gameWins[1];
			
			if (_gameWins[1] == [Settings sharedSettings].gamesPerMatch) {
				
				// Player 2 wins this round
				[[SimpleAudioEngine sharedEngine] playEffect:@"lose.wav"];
				
				++_matchWins[1];
				_gameWins[0] = 0;
				_gameWins[1] = 0;
			}
		} else {
			++_gameWins[0];
			
			if (_gameWins[0] == [Settings sharedSettings].gamesPerMatch) {
				
				// Player 1 wins this round
				[[SimpleAudioEngine sharedEngine] playEffect:@"win.wav"];
				
				++_matchWins[0];
				_gameWins[0] = 0;
				_gameWins[1] = 0;
			}	
		}

		[self createWinLabels];
	}
	
	++_deathEffectTimer;
}

- (void)update:(ccTime)dt {
	
	// ccTime is measured in fractions of a second; we need it in frames per
	// second, using 60fps as the framerate
	int frames = (int)(round(2.0f * dt * FRAME_RATE) / 2.0f);
	
	// Ensure that at least one frame will be processed
	if (frames == 0) frames = 1;
	
	for (int i = 0; i < frames; ++i) {
		
		switch (_state) {
			case GameActiveState:
				[self runActiveState];
				break;
				
			case GamePausedState:
				[self runPausedState];
				break;
				
			case GameOverEffectState:
				[self runGameOverEffectState];
				break;
				
			case GameOverState:
				[self runGameOverState];
				break;
		}
		
		[[Pad instance] update];
	}
}

- (void)setBlocksVisible:(BOOL)visible {
	for (int i = 0; i < MAX_PLAYERS; ++i) {

		if (_blockSpriteConnectors[i] == nil) continue;

		for (BlockSpriteConnector* connector in _blockSpriteConnectors[i]) {
			if (connector.block.y < GRID_HEIGHT - 1) {
				[connector.sprite setVisible:visible];
			}
		}
	}
}

- (void)pauseGame {
	_state = GamePausedState;
	
	[[SimpleAudioEngine sharedEngine] playEffect:@"pause.wav"];
	
	// Show "paused" message on both grids
	CCSprite* sprite = [CCSprite spriteWithSpriteFrameName:@"paused.png"];
	sprite.position = ccp(208 + (sprite.contentSize.width / 2), ([[CCDirector sharedDirector] winSize].height - sprite.contentSize.height) / 2);
	[_messageSpriteSheet addChild:sprite];
	
	if (_grids[1] != nil) {
		sprite = [CCSprite spriteWithSpriteFrameName:@"paused.png"];
		sprite.position = ccp(16 + (sprite.contentSize.width / 2), ([[CCDirector sharedDirector] winSize].height - sprite.contentSize.height) / 2);
		[_messageSpriteSheet addChild:sprite];
	}
	
	[self setBlocksVisible:NO];
}

- (void)resumeGame {
	_state = GameActiveState;

	// Remove all "paused" messages
	while ([[_messageSpriteSheet children] count] > 0) {
		[_messageSpriteSheet removeChildAtIndex:0 cleanup:YES];
	}

	[self setBlocksVisible:YES];
}

- (void)createWinLabels {

	// Delete existing labels
	for (int i = 0; i < MAX_PLAYERS; ++i) {
		if (_matchWinsLabels[i] != nil) {
			[_matchWinsLabels[i] removeFromParentAndCleanup:YES];
			[_matchWinsLabels[i] release];
			_matchWinsLabels[i] = nil;
		}

		if (_gameWinsLabels[i] != nil) {
			[_gameWinsLabels[i] removeFromParentAndCleanup:YES];
			[_gameWinsLabels[i] release];
			_gameWinsLabels[i] = nil;
		}
	}

	// Labels for player 1
	_matchWinsLabels[0] = [[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", _matchWins[0]] fontName:@"Courier" fontSize:12] retain];
	_matchWinsLabels[0].position =  ccp(10, 10);
	[self addChild: _matchWinsLabels[0]];

	_gameWinsLabels[0] = [[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", _gameWins[0]] fontName:@"Courier" fontSize:12] retain];
	_gameWinsLabels[0].position =  ccp(20, 10);
	[self addChild: _gameWinsLabels[0]];

	// Labels for player 2
	if ([Settings sharedSettings].gameType != GamePracticeType) {
		_matchWinsLabels[1] = [[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", _matchWins[1]] fontName:@"Courier" fontSize:12] retain];
		_matchWinsLabels[1].position =  ccp(10, 20);
		[self addChild: _matchWinsLabels[1]];

		_gameWinsLabels[1] = [[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", _gameWins[1]] fontName:@"Courier" fontSize:12] retain];
		_gameWinsLabels[1].position =  ccp(20, 20);
		[self addChild: _gameWinsLabels[1]];
	}
}

- (void)resetGame {

	_state = GameActiveState;
	_deathEffectTimer = 0;

	[[Pad instance] reset];

	// Release all existing game objects
	if (_blockFactory != nil) [_blockFactory release];
	
	for (int i = 0; i < MAX_PLAYERS; ++i) {
		if (_grids[i] != nil) {
			[_grids[i] release];
			_grids[i] = nil;
		}

		if (_controllers[i] != nil) {
			[(id)_controllers[i] release];
			_controllers[i] = nil;
		}

		if (_runners[i] != nil) {
			[_runners[i] release];
			_runners[i] = nil;
		}

		if (_blockSpriteConnectors[i] != nil) {
			[_blockSpriteConnectors[i] release];
			_blockSpriteConnectors[i] = nil;
		}

		if (_incomingGarbageSprites[i] != nil) {

			for (CCSprite* sprite in _incomingGarbageSprites[i]) {
				[sprite removeFromParentAndCleanup:YES];
			}

			[_incomingGarbageSprites[i] release];

			_incomingGarbageSprites[i] = nil;
		}
	}

	// Create new game objects
	int players = [Settings sharedSettings].gameType == GamePracticeType ? 1 : 2;

	_blockFactory = [[BlockFactory alloc] initWithPlayerCount:players blockColourCount:[Settings sharedSettings].blockColours];
	
	_blockSpriteConnectors[0] = [[NSMutableArray alloc] init];
	_incomingGarbageSprites[0] = [[NSMutableArray alloc] init];

	_grids[0] = [[Grid alloc] initWithPlayerNumber:0];
	_controllers[0] = [[PlayerController alloc] init];
	_runners[0] = [[GridRunner alloc] initWithController:_controllers[0]
													grid:_grids[0]
											blockFactory:_blockFactory
											playerNumber:0
												   speed:[Settings sharedSettings].speed];

	if (players > 1) {
		_blockSpriteConnectors[1] = [[NSMutableArray alloc] init];
		_incomingGarbageSprites[1] = [[NSMutableArray alloc] init];

		_grids[1] = [[Grid alloc] initWithPlayerNumber:1];
		_controllers[1] = [[AIController alloc] initWithHesitation:(int)([Settings sharedSettings].aiType) grid:_grids[1]];
		_runners[1] = [[GridRunner alloc] initWithController:_controllers[1]
														grid:_grids[1]
												blockFactory:_blockFactory
												playerNumber:1
													   speed:[Settings sharedSettings].speed];
	}

	[self setupCallbacks];

	[_grids[0] createBottomRow];
	[_grids[0] addGarbage:GRID_WIDTH * [Settings sharedSettings].height];

	if (_grids[1] != nil) {
		[_grids[1] createBottomRow];
		[_grids[1] addGarbage:GRID_WIDTH * [Settings sharedSettings].height];
	}
}

- (void)runGameOverState {
	if ([[Pad instance] isStartNewPress] || [[Pad instance] isANewPress]) {
		[self resetGame];
	}
}

- (void)runPausedState {
	if ([[Pad instance] isStartNewPress]) {
		[self resumeGame];
	}
}

- (void)runActiveState {
	
	// Check for pause mode request
	if ([[Pad instance] isStartNewPress]) {
		[self pauseGame];
		return;
	}
	
	[_runners[0] iterate];
	
	if (_runners[1] == nil) {
		if (_runners[0].isDead) {
			
			// Single player dead
			[[SimpleAudioEngine sharedEngine] playEffect:@"dead.wav"];
			_state = GameOverEffectState;
			_deathEffectTimer = 0;
		}
	} else {
		[_runners[1] iterate];
		
		if (_runners[0].isDead && !_runners[1].isDead) {
			
			// Player one dead
			[[SimpleAudioEngine sharedEngine] playEffect:@"dead.wav"];
			
			CCSprite* sprite = [CCSprite spriteWithSpriteFrameName:@"winner.png"];
			sprite.position = ccp(208 + (sprite.contentSize.width / 2), ([[CCDirector sharedDirector] winSize].height - sprite.contentSize.height) / 2);
			[_messageSpriteSheet addChild:sprite];

			_state = GameOverEffectState;
			_deathEffectTimer = 0;
			
		} else if (_runners[1].isDead && !_runners[0].isDead) {
			
			// Player two dead
			[[SimpleAudioEngine sharedEngine] playEffect:@"dead.wav"];
			
			CCSprite* sprite = [CCSprite spriteWithSpriteFrameName:@"winner.png"];
			sprite.position = ccp(16 + (sprite.contentSize.width / 2), ([[CCDirector sharedDirector] winSize].height - sprite.contentSize.height) / 2);
			[_messageSpriteSheet addChild:sprite];
			
			_state = GameOverEffectState;
			_deathEffectTimer = 0;
			
		} else if (_runners[1].isDead && _runners[0].isDead) {
			
			// Both dead
			[[SimpleAudioEngine sharedEngine] playEffect:@"dead.wav"];
			
			_state = GameOverEffectState;
			_deathEffectTimer = 0;
		}
		
		// Move garbage from one runner to the other
		if ([_runners[0] addIncomingGarbage:_runners[1].outgoingGarbageCount]) {
			[_runners[1] clearOutgoingGarbageCount];
			
			[self updateIncomingGarbageDisplayForRunner:_runners[0]];
		}
		
		if ([_runners[1] addIncomingGarbage:_runners[0].outgoingGarbageCount]) {
			[_runners[0] clearOutgoingGarbageCount];
			
			[self updateIncomingGarbageDisplayForRunner:_runners[1]];
		}
		
		[self updateBlockSpriteConnectors];
	}
}

- (void)updateBlockSpriteConnectors {
	
	for (int j = 0; j < MAX_PLAYERS; ++j) {

		if (_blockSpriteConnectors[j] == nil) continue;

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

- (void)updateIncomingGarbageDisplayForRunner:(GridRunner*)runner {
	
	int playerNumber = runner == _runners[0] ? 0 : 1;
	
	// Remove existing boulders
	for (int i = 0; i < [_incomingGarbageSprites[playerNumber] count]; ++i) {
		[_incomingSpriteSheet removeChild:[_incomingGarbageSprites[playerNumber] objectAtIndex:i] cleanup:YES];
	}
	
	[_incomingGarbageSprites[playerNumber] removeAllObjects];
	
	int garbage = _runners[playerNumber].incomingGarbageCount;
	
	if (garbage == 0) return;
	
	int faceBoulders = garbage / GARBAGE_FACE_BOULDER_VALUE;
	garbage -= faceBoulders * GARBAGE_FACE_BOULDER_VALUE;
	
	int largeBoulders = garbage / GARBAGE_LARGE_BOULDER_VALUE;
	garbage -= largeBoulders * GARBAGE_LARGE_BOULDER_VALUE;
	
	int spriteY = [[CCDirector sharedDirector] winSize].height - 1;
	int spriteX = playerNumber == 0 ? 0 : [[CCDirector sharedDirector] winSize].width - BLOCK_SIZE;
	
	for (int i = 0; i < faceBoulders; ++i) {
		CCSprite* boulder = [CCSprite spriteWithSpriteFrameName:@"incoming2.png"];
		boulder.position = ccp(spriteX + (BLOCK_SIZE / 2), spriteY - ([boulder contentSize].height / 2));
		[_incomingSpriteSheet addChild:boulder];
		
		spriteY -= [boulder contentSize].height + 1;
		
		[_incomingGarbageSprites[playerNumber] addObject:boulder];
	}
	
	for (int i = 0; i < largeBoulders; ++i) {
		CCSprite* boulder = [CCSprite spriteWithSpriteFrameName:@"incoming1.png"];
		boulder.position = ccp(spriteX + (BLOCK_SIZE / 2), spriteY - ([boulder contentSize].height / 2));
		[_incomingSpriteSheet addChild:boulder];
		
		spriteY -= [boulder contentSize].height + 1;
		
		[_incomingGarbageSprites[playerNumber] addObject:boulder];
	}
	
	for (int i = 0; i < garbage; ++i) {
		CCSprite* boulder = [CCSprite spriteWithSpriteFrameName:@"incoming0.png"];
		boulder.position = ccp(spriteX + (BLOCK_SIZE / 2), spriteY - ([boulder contentSize].height / 2));
		[_incomingSpriteSheet addChild:boulder];
		
		spriteY -= [boulder contentSizeInPixels].height + 1;
		
		[_incomingGarbageSprites[playerNumber] addObject:boulder];
	}
}

- (void)dealloc {
	
	[_blockFactory release];
	
	[self unloadSounds];
	
	for (int i = 0; i < MAX_PLAYERS; ++i) {
		if (_grids[i] != nil) [_grids[i] release];
		if (_controllers[i] != nil) [(id)_controllers[i] release];
		if (_runners[i] != nil) [_runners[i] release];
		if (_blockSpriteConnectors[i] != nil) [_blockSpriteConnectors[i] release];
		if (_incomingGarbageSprites[i] != nil) [_incomingGarbageSprites[i] release];
		if (_matchWinsLabels[i] != nil) [_matchWinsLabels[i] release];
		if (_gameWinsLabels[i] != nil) [_gameWinsLabels[i] release];
	}
	
	[super dealloc];
}

- (void)createBlockSpriteConnector:(BlockBase*)block gridX:(int)gridX gridY:(int)gridY connectorArray:(NSMutableArray*)connectorArray {
	
	CCSprite* sprite = nil;
	CCSpriteBatchNode* sheet = nil;
	
	if ([block isKindOfClass:[RedBlock class]]) {
		sprite = [CCSprite spriteWithSpriteFrameName:@"red00.png"];
		sheet = _redBlockSpriteSheet;
	} else if ([block isKindOfClass:[GreenBlock class]]) {
		sprite = [CCSprite spriteWithSpriteFrameName:@"green00.png"];
		sheet = _greenBlockSpriteSheet;
	} else if ([block isKindOfClass:[BlueBlock class]]) {
		sprite = [CCSprite spriteWithSpriteFrameName:@"blue00.png"];
		sheet = _blueBlockSpriteSheet;
	} else if ([block isKindOfClass:[YellowBlock class]]) {
		sprite = [CCSprite spriteWithSpriteFrameName:@"yellow00.png"];
		sheet = _yellowBlockSpriteSheet;
	} else if ([block isKindOfClass:[OrangeBlock class]]) {
		sprite = [CCSprite spriteWithSpriteFrameName:@"orange00.png"];
		sheet = _orangeBlockSpriteSheet;
	} else if ([block isKindOfClass:[PurpleBlock class]]) {
		sprite = [CCSprite spriteWithSpriteFrameName:@"purple00.png"];
		sheet = _purpleBlockSpriteSheet;
	} else if ([block isKindOfClass:[GarbageBlock class]]) {
		sprite = [CCSprite spriteWithSpriteFrameName:@"grey00.png"];
		sheet = _garbageBlockSpriteSheet;
	} else if ([block isKindOfClass:[GridBottomBlock class]]) {
		sprite = [CCSprite spriteWithSpriteFrameName:@"gridbottom00.png"];
		sheet = _gridBottomBlockSpriteSheet;
	} else if ([block isKindOfClass:[GridBottomLeftBlock class]]) {
		sprite = [CCSprite spriteWithSpriteFrameName:@"gridbottomleft00.png"];
		sheet = _gridBottomLeftBlockSpriteSheet;
	} else if ([block isKindOfClass:[GridBottomRightBlock class]]) {
		sprite = [CCSprite spriteWithSpriteFrameName:@"gridbottomright00.png"];
		sheet = _gridBottomRightBlockSpriteSheet;
	}
	
	// Connect the sprite and block together
	BlockSpriteConnector* connector = [[BlockSpriteConnector alloc] initWithBlock:block sprite:sprite gridX:gridX gridY:gridY];
	[connectorArray addObject:connector];
	[connector release];
	
	[sheet addChild:sprite];
}

- (BOOL)ccKeyUp:(NSEvent*)event {
	
	NSString * character = [event characters];
    unichar keyCode = [character characterAtIndex: 0];
	
	if (keyCode == [Settings sharedSettings].keyCodeUp) [[Pad instance] releaseUp];
	if (keyCode == [Settings sharedSettings].keyCodeDown) [[Pad instance] releaseDown];
	if (keyCode == [Settings sharedSettings].keyCodeLeft) [[Pad instance] releaseLeft];
	if (keyCode == [Settings sharedSettings].keyCodeRight) [[Pad instance] releaseRight];
	
	if (keyCode == [Settings sharedSettings].keyCodeA) [[Pad instance] releaseA];
	if (keyCode == [Settings sharedSettings].keyCodeB) [[Pad instance] releaseB];

	if (keyCode == [Settings sharedSettings].keyCodeStart) [[Pad instance] releaseStart];
	
	return YES;
}

-(BOOL)ccKeyDown:(NSEvent*)event {
	
	NSString * character = [event characters];
    unichar keyCode = [character characterAtIndex: 0];
	
	if (keyCode == [Settings sharedSettings].keyCodeUp) [[Pad instance] pressUp];
	if (keyCode == [Settings sharedSettings].keyCodeDown) [[Pad instance] pressDown];
	if (keyCode == [Settings sharedSettings].keyCodeLeft) [[Pad instance] pressLeft];
	if (keyCode == [Settings sharedSettings].keyCodeRight) [[Pad instance] pressRight];
	
	if (keyCode == [Settings sharedSettings].keyCodeA) [[Pad instance] pressA];
	if (keyCode == [Settings sharedSettings].keyCodeB) [[Pad instance] pressB];
	
	if (keyCode == [Settings sharedSettings].keyCodeStart) [[Pad instance] pressStart];
	
	return YES;
}

@end
