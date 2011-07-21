#import "cocos2d.h"

#import "Grid.h"
#import "GridRunner.h"
#import "AIController.h"
#import "ControllerProtocol.h"
#import "BlockFactory.h"
#import "PlayerController.h"

@interface GameDisplayLayer : CCLayer {
	GridRunner* _runner1;
	GridRunner* _runner2;
}

- (id)initWithRunner1:runner1:(GridRunner*)runner1 runner2:(GridRunner*)runner2

@end
