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
}

@property(readwrite, assign) GridRunner* runner1;
@property(readwrite, assign) GridRunner* runner2;

@property(readonly) CCSpriteBatchNode* redBlockSpriteSheet;
@property(readonly) CCSpriteBatchNode* blueBlockSpriteSheet;
@property(readonly) CCSpriteBatchNode* greenBlockSpriteSheet;
@property(readonly) CCSpriteBatchNode* yellowBlockSpriteSheet;
@property(readonly) CCSpriteBatchNode* orangeBlockSpriteSheet;
@property(readonly) CCSpriteBatchNode* purpleBlockSpriteSheet;
@property(readonly) CCSpriteBatchNode* garbageBlockSpriteSheet;
@property(readonly) CCSpriteBatchNode* gridBottomBlockSpriteSheet;
@property(readonly) CCSpriteBatchNode* gridBottomLeftBlockSpriteSheet;
@property(readonly) CCSpriteBatchNode* gridBottomRightBlockSpriteSheet;

- (id)init;

@end
