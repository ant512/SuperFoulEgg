#import "cocos2d.h"

#import "Grid.h"
#import "GridRunner.h"
#import "AIController.h"
#import "ControllerProtocol.h"
#import "BlockFactory.h"
#import "PlayerController.h"
#import "Grid.h"
#import "GridRunner.h"
#import "AIController.h"
#import "ControllerProtocol.h"
#import "BlockFactory.h"
#import "GameDisplayLayer.h"
#import "PlayerController.h"
#import "BlockSpriteConnector.h"

#define MAX_PLAYERS 2
#define FRAME_RATE 60

typedef enum {
	GameActiveState = 0,
	GamePausedState = 1,
	GameOverEffectState = 2,
	GameOverState = 3
} GameState;

@interface GameDisplayLayer : CCLayer {
	CCSpriteBatchNode* _redBlockSpriteSheet;
	CCSpriteBatchNode* _blueBlockSpriteSheet;
	CCSpriteBatchNode* _greenBlockSpriteSheet;
	CCSpriteBatchNode* _yellowBlockSpriteSheet;
	CCSpriteBatchNode* _orangeBlockSpriteSheet;
	CCSpriteBatchNode* _purpleBlockSpriteSheet;
	CCSpriteBatchNode* _garbageBlockSpriteSheet;
	CCSpriteBatchNode* _gridBottomBlockSpriteSheet;
	CCSpriteBatchNode* _gridBottomLeftBlockSpriteSheet;
	CCSpriteBatchNode* _gridBottomRightBlockSpriteSheet;
	CCSpriteBatchNode* _incomingSpriteSheet;
	CCSpriteBatchNode* _messageSpriteSheet;
	
	BlockFactory* _blockFactory;
	GameState _state;
	
	GridRunner* _runners[MAX_PLAYERS];
	Grid* _grids[MAX_PLAYERS];
	id <ControllerProtocol> _controllers[MAX_PLAYERS];
	NSMutableArray* _blockSpriteConnectors[MAX_PLAYERS];
	NSMutableArray* _incomingGarbageSprites[MAX_PLAYERS];
	int _gameWins[MAX_PLAYERS];
	int _matchWins[MAX_PLAYERS];
	
	int _deathEffectTimer;
}

+ (CCScene*)scene;
- (id)init;
- (void)update:(ccTime)dt;
- (void)createBlockSpriteConnector:(BlockBase*)block
							 gridX:(int)gridX
							 gridY:(int)gridY
					connectorArray:(NSMutableArray*)connectorArray;

- (void)runActiveState;
- (void)runPausedState;
- (void)runGameOverEffectState;
- (void)runGameOverState;
- (void)updateBlockSpriteConnectors;
- (void)updateIncomingGarbageDisplayForRunner:(GridRunner*)runner;
- (void)loadSounds;
- (void)unloadSounds;
- (void)prepareSpriteSheets;
- (void)loadBackground;
- (void)setBlocksVisible:(BOOL)visible;
- (void)pauseGame;
- (void)resumeGame;
- (void)resetGame;
- (void)setupCallbacks;

@end
