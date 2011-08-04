#import <Foundation/Foundation.h>

#import "cocos2d.h"
#import "BlockBase.h"

@interface BlockSpriteConnector : NSObject {
@private
	BlockBase* _block;
	CCSprite* _sprite;
	BOOL _isDead;
}

@property(readonly, assign) BlockBase* block;
@property(readonly, assign) CCSprite* sprite;
@property(readonly) BOOL isDead;

- (id)initWithBlock:(BlockBase*)block sprite:(CCSprite*)sprite;
- (void)update;

@end
