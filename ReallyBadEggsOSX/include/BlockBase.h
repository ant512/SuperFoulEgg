#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "Grid.h"

/**
 * Dimensions of a block.  Blocks are square.
 */
#define BLOCK_SIZE 16

@class BlockBase;

typedef void(^BlockEvent)(BlockBase*);

/**
 * Bitmask of possible connections.
 */
enum {
	ConnectionNoneMask = 0,				/**< No connections. */
	ConnectionTopMask = 1,				/**< Top connection. */
	ConnectionLeftMask = 2,				/**< Left connection. */
	ConnectionRightMask = 4,			/**< Right connection. */
	ConnectionBottomMask = 8			/**< Bottom connection. */
};

/**
 * Base class for all blocks that appear in the grid.
 */
@interface BlockBase : NSObject {
@private
	int _connections;				/**< Bitmask of active connections. */
	BOOL _isExploding;				/**< True if the block is exploding. */
	BOOL _isExploded;				/**< True if the block has exploded. */
	BOOL _isLanding;				/**< True if the block is landing. */
	BOOL _isFalling;				/**< True if the block is falling. */
	BOOL _hasDroppedHalfBlock;		/**< True if the block has dropped half a grid square. */

	int _x;							/**< The x co-ordinate of the block. */
	int _y;							/**< The y co-ordinate of the block. */

	BlockEvent _onExplode;			/**< Event triggered when the block starts exploding. */
	BlockEvent _onLand;				/**< Event triggered when the block lands. */
	BlockEvent _onFall;				/**< Event triggered when the block starts falling. */
	BlockEvent _onMove;				/**< Event triggered when the block moves. */
	
	Grid* _grid;					/**< The grid that contains this block. */

	CCSprite* _sprite;				/**< The sprite that represents this block. */
}

/**
 * The sprite that represents this block.
 */
@property(readwrite, assign) CCSprite* sprite;

/**
 * The grid that contains this block.
 */
@property(readonly) Grid* grid;

/**
 * The x co-ordinate of the block.
 */
@property(readonly) int x;

/**
 * The y co-ordinate of the block.
 */
@property(readonly) int y;

/**
 * Event triggered when the block starts exploding.
 */
@property(readwrite, copy) BlockEvent onExplode;

/**
 * Event triggered when the block lands.
 */
@property(readwrite, copy) BlockEvent onLand;

/**
 * Event triggered when the block starts falling.
 */
@property(readwrite, copy) BlockEvent onFall;

/**
 * Event triggered when the block moves.
 */
@property(readwrite, copy) BlockEvent onMove;
		
/**
 * True if the block is exploding.
 */
@property(readonly) BOOL isExploding;

/**
 * True if the block has exploded.
 */
@property(readwrite) BOOL hasExploded;

/**
 * True if the block is landing.
 */
@property(readonly) BOOL isLanding;

/**
 * True if the block is falling.
 */
@property(readonly) BOOL isFalling;

/**
 * True if the block has dropped half a grid square.
 */
@property(readonly) BOOL hasDroppedHalfBlock;

/**
 * Initialises a new instance of the class.
 * @param grid The grid that contains the block.
 */
- (id)initWithGrid:(Grid*)grid;

/**
 * Deallocates the object.
 */
- (void)dealloc;

/**
 * Check if the block is connected to the block on its left.
 * @return True if a connection exists; false if not.
 */
- (BOOL)hasLeftConnection;

/**
 * Check if the block is connected to the block on its right.
 * @return True if a connection exists; false if not.
 */
- (BOOL)hasRightConnection;

/**
 * Check if the block is connected to the block above.
 * @return True if a connection exists; false if not.
 */
- (BOOL)hasTopConnection;

/**
 * Check if the block is connected to the block below.
 * @return True if a connection exists; false if not.
 */
- (BOOL)hasBottomConnection;

/**
 * Check if the block can establish connections.
 * @return True if the block can establish connections.
 */
- (BOOL)isConnectable;

/**
 * Inform the block that it is falling.
 */
- (void)fall;

/**
 * Explode the block.
 */
- (void)explode;

/**
 * Inform the block that it has landed.
 */
- (void)land;

/**
 * Inform the block that it has dropped half a grid square.
 * @return True if the block has dropped half a grid square.
 */
- (void)dropHalfBlock;

/**
 * Attempt to establish which of the surrounding blocks are of the same type as
 * this and remember those connections.
 * @param top The block above this.
 * @param bottom The block below this.
 * @param right The block to the right of this.
 * @param left The block to the left of this.
 */
- (void)connect:(BlockBase*)top right:(BlockBase*)right bottom:(BlockBase*)bottom left:(BlockBase*)left;

/**
 * Sets the connections that the block has to the supplied parameters.
 * @param top The state of the top connection.
 * @param right The state of the right connection.
 * @param bottom The state of the bottom connection.
 * @param left The state of the left connection.
 */
- (void)setConnectionTop:(BOOL)top right:(BOOL)right bottom:(BOOL)bottom left:(BOOL)left;

/**
 * Sets the co-ordinates of the block.  The co-ordinates should be changed every
 * time the block is moved in the grid.
 * @param x The new x co-ordinate.
 * @param y The new y co-ordinate.
 */
- (void)setX:(int)x andY:(int)y;

@end
