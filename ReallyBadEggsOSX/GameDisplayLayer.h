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

@property(readwrite, assign) GridRunner* runner1;
@property(readwrite, assign) GridRunner* runner2;

- (id)init;

@end
