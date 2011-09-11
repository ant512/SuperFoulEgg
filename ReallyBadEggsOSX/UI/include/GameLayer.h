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
#import "GameLayer.h"
#import "PlayerController.h"
#import "BlockSpriteConnector.h"

#define MAX_PLAYERS 2
#define FRAME_RATE 60
#define GRID_1_X 16
#define GRID_2_X 208
#define GRID_Y 0
#define NEXT_BLOCK_1_X 136
#define NEXT_BLOCK_2_X 182
#define NEXT_BLOCK_Y -46
#define GRID_2_TAG_X 179
#define GRID_2_TAG_Y 154

typedef enum {
	GameActiveState = 0,
	GamePausedState = 1,
	GameOverEffectState = 2,
	GameOverState = 3
} GameState;

@interface GameLayer : CCLayer {
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
	CCSpriteBatchNode* _playerTagSpriteSheet;
	
	BlockFactory* _blockFactory;
	GameState _state;
	
	GridRunner* _runners[MAX_PLAYERS];
	NSMutableArray* _blockSpriteConnectors[MAX_PLAYERS];
	NSMutableArray* _incomingGarbageSprites[MAX_PLAYERS];
	int _gameWins[MAX_PLAYERS];
	int _matchWins[MAX_PLAYERS];
	
	int _deathEffectTimer;

	CCLabelTTF* _matchWinsLabels[MAX_PLAYERS];
	CCLabelTTF* _gameWinsLabels[MAX_PLAYERS];
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
- (void)createWinLabels;
- (void)createNextBlockSpriteConnectorPairForRunner:(GridRunner*)runner;
- (BOOL)moveNextBlockToGridForPlayer:(int)playerNumber block:(BlockBase*)block;
- (void)addBlockSpriteConnectorForPlayer:(int)playerNumber block:(BlockBase*)block;
- (void)hitColumnWithGarbageForPlayerNumber:(int)playerNumber column:(int)column;
- (CGFloat)panForPlayerNumber:(int)playerNumber;
- (void)blankSecondGrid;

@end
