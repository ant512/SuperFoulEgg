#import <Foundation/Foundation.h>

#import "cocos2d.h"

#import "Grid.h"
#import "GridRunner.h"
#import "AIController.h"
#import "ControllerProtocol.h"
#import "BlockFactory.h"
#import "GameDisplayLayer.h"
#import "PlayerController.h"

@interface GameScene : CCScene {
	Grid* _grid1;
	Grid* _grid2;
	id <ControllerProtocol> _controller1;
	id <ControllerProtocol> _controller2;
	GridRunner* _runner1;
	GridRunner* _runner2;
	BlockFactory* _blockFactory;
	GameDisplayLayer* _gameDisplayLayer;

	NSMutableArray* _blockSpriteConnectors;
}

@property(readonly) Grid* grid1;
@property(readonly) Grid* grid2;
@property(readonly) id <ControllerProtocol> controller1;
@property(readonly) id <ControllerProtocol> controller2;
@property(readonly) GridRunner* runner1;
@property(readonly) GridRunner* runner2;

- (void)update:(ccTime)dt;

@end
