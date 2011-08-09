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

typedef enum {
	GameActiveState = 0,
	GamePausedState = 1,
	GameOverState = 2
} GameState;

@interface GameScene : CCScene {
	Grid* _grid1;
	Grid* _grid2;
	id <ControllerProtocol> _controller1;
	id <ControllerProtocol> _controller2;
	GridRunner* _runner1;
	GridRunner* _runner2;
	BlockFactory* _blockFactory;
	GameDisplayLayer* _gameDisplayLayer;
	GameState _state;

	NSMutableArray* _blockSpriteConnectors[2];
}

@property(readonly) Grid* grid1;
@property(readonly) Grid* grid2;
@property(readonly) id <ControllerProtocol> controller1;
@property(readonly) id <ControllerProtocol> controller2;
@property(readonly) GridRunner* runner1;
@property(readonly) GridRunner* runner2;

- (void)update:(ccTime)dt;
- (void)createBlockSpriteConnector:(BlockBase*)block
					gridX:(int)gridX
					gridY:(int)gridY
					connectorArray:(NSMutableArray*)connectorArray;

- (void)iterateGame;
- (void)updateBlockSpriteConnectors;

@end
