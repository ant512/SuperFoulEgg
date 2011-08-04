#import <Foundation/Foundation.h>

#import "cocos2d.h"
#import "BlockBase.h"

#define BLOCK_EXPLODE_START_FRAME 16
#define BLOCK_EXPLODE_FRAME_COUNT 6
#define BLOCK_LAND_START_FRAME 22
#define BLOCK_ANIMATION_SPEED 2

@interface BlockSpriteConnector : NSObject {
@private
	BlockBase* _block;
	CCSprite* _sprite;
	BOOL _isDead;
	int _timer;
	int _frame;
}

@property(readonly, assign) BlockBase* block;
@property(readonly, assign) CCSprite* sprite;
@property(readonly) BOOL isDead;

- (id)initWithBlock:(BlockBase*)block sprite:(CCSprite*)sprite;
- (void)update;
- (void)setSpriteFrame:(int)frame;
- (void)updateSpritePosition;

@end
