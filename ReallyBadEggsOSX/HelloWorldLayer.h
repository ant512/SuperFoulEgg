#import "cocos2d.h"

#import "Grid.h"
#import "GridRunner.h"
#import "AIController.h"
#import "ControllerProtocol.h"
#import "BlockFactory.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
	Grid* _grid1;
	Grid* _grid2;
	id <ControllerProtocol> _controller1;
	id <ControllerProtocol> _controller2;
	GridRunner* _runner1;
	GridRunner* _runner2;
	BlockFactory* _blockFactory;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
