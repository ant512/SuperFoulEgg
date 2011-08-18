#import <Foundation/Foundation.h>

#import "cocos2d.h"

#import "Grid.h"
#import "GridRunner.h"
#import "AIController.h"
#import "ControllerProtocol.h"
#import "BlockFactory.h"
#import "GameDisplayLayer.h"
#import "PlayerController.h"
#import "BlockSpriteConnector.h"

#define MAX_PLAYERS 2

typedef enum {
	GameActiveState = 0,
	GamePausedState = 1,
	GameOverEffectState = 2,
	GameOverState = 3
} GameState;

@interface GameScene : CCScene {
	BlockFactory* _blockFactory;
	GameDisplayLayer* _gameDisplayLayer;
	GameState _state;

	GridRunner* _runners[MAX_PLAYERS];
	Grid* _grids[MAX_PLAYERS];
	id <ControllerProtocol> _controllers[MAX_PLAYERS];
	NSMutableArray* _blockSpriteConnectors[MAX_PLAYERS];
	NSMutableArray* _incomingGarbageSprites[MAX_PLAYERS];
	int _gameWins[MAX_PLAYERS];
	int _matchWins[MAX_PLAYERS];
	int _gamesPerMatch;
}

- (void)update:(ccTime)dt;
- (void)createBlockSpriteConnector:(BlockBase*)block
					gridX:(int)gridX
					gridY:(int)gridY
					connectorArray:(NSMutableArray*)connectorArray;

- (void)iterateGame;
- (void)updateBlockSpriteConnectors;
- (void)updateIncomingGarbageDisplayForRunner:(GridRunner*)runner;

@end
