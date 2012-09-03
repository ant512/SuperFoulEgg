#import "cocos2d.h"

#import "Grid.h"
#import "GridRunner.h"
#import "SmartAIController.h"
#import "ControllerProtocol.h"
#import "BlockFactory.h"
#import "PlayerOneController.h"
#import "PlayerTwoController.h"
#import "Grid.h"
#import "GridRunner.h"
#import "ControllerProtocol.h"
#import "BlockFactory.h"
#import "GameLayer.h"
#import "BlockSpriteConnector.h"

#define MAX_PLAYERS 2
#define FRAME_RATE 60
#define GRID_1_X 48
#define GRID_2_X 624
#define GRID_Y 0
#define NEXT_BLOCK_1_X 408
#define NEXT_BLOCK_2_X 546
#define NEXT_BLOCK_Y -280
#define GRID_2_TAG_X 537
#define GRID_2_TAG_Y 462
#define GRID_1_MATCH_SCORE_X 444
#define GRID_1_GAME_SCORE_X 531
#define GRID_1_SCORES_Y 363
#define GRID_2_MATCH_SCORE_X 477
#define GRID_2_GAME_SCORE_X 570
#define GRID_2_SCORES_Y 285

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
	CCSpriteBatchNode* _orangeNumberSpriteSheet;
	CCSpriteBatchNode* _purpleNumberSpriteSheet;
	
	BlockFactory* _blockFactory;
	GameState _state;
	
	GridRunner* _runners[MAX_PLAYERS];
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
- (void)createWinLabels;
- (void)createNextBlockSpriteConnectorPairForRunner:(GridRunner*)runner;
- (BOOL)moveNextBlockToGridForPlayer:(int)playerNumber block:(BlockBase*)block;
- (void)addBlockSpriteConnectorForPlayer:(int)playerNumber block:(BlockBase*)block;
- (void)hitColumnWithGarbageForPlayerNumber:(int)playerNumber column:(int)column;
- (CGFloat)panForPlayerNumber:(int)playerNumber;
- (void)blankSecondGrid;
- (void)createSpritesForNumber:(int)number colour:(NSString*)colour x:(int)x y:(int)y;

@end
