#import <Foundation/Foundation.h>

#import "cocos2d.h"
#import "BlockBase.h"
#import "Grid.h"

#define BLOCK_EXPLODE_START_FRAME 16
#define BLOCK_EXPLODE_FRAME_COUNT 6
#define BLOCK_LAND_START_FRAME 22
#define BLOCK_ANIMATION_SPEED 2
#define GARBAGE_HIT_OFFSET 5

@interface BlockSpriteConnector : NSObject {
@private
	BlockBase* _block;		/**< The block in the grid that this connector joins with a sprite. */
	CCSprite* _sprite;		/**< The sprite on screen that this connector joins with a block. */
	int _gridX;				/**< The x co-ordinate of the grid that contains the block. */
	int _gridY;				/**< The y co-ordinate of the grid that contains the block. */
	BOOL _isDead;			/**< If true, the block is no longer in the grid and the connector needs to be released. */
	int _timer;				/**< Used to control animations. */
	int _frame;				/**< Currently visible frame of animation. */
	int _yOffset;			/**< Offset from 0 of y co-ordinates, used when a garbage block lands on top of this. */
}

/**
 * The block in the grid that this connector joins with a sprite.
 */
@property(readonly, assign) BlockBase* block;

/**
 * The sprite on screen that this connector joins with a block.
 */
@property(readonly, assign) CCSprite* sprite;

/**
 * If true, the block is no longer in the grid and the connector needs to be
 * released.
 */
@property(readonly) BOOL isDead;

/**
 * Initialises a new instance of the class.
 * @param block The block in the grid that this connector joins with a sprite.
 * @param sprite The sprite on screen that this connector joins with a block.
 */
- (id)initWithBlock:(BlockBase*)block sprite:(CCSprite*)sprite gridX:(int)gridX gridY(int)gridY;

/**
 * Updates the sprite to match the status of the block.
 */
- (void)update;

/**
 * Sets the visible animation frame to the supplied value.
 * @param frame The frame to view.
 */
- (void)setSpriteFrame:(int)frame;

/**
 * Updates the sprite's position to match the block's.
 */
- (void)updateSpritePosition;

/**
 * Offsets the y co-ordinate of the sprite to simulate the weight of the garbage
 * landing on it.
 */
- (void)hitWithGarbage;

@end
