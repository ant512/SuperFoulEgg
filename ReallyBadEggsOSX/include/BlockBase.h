#import <Foundation/Foundation.h>

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
	ConnectionNoneMask = 0,					/**< No connections. */
	ConnectionTopMask = 1,					/**< Top connection. */
	ConnectionLeftMask = 2,					/**< Left connection. */
	ConnectionRightMask = 4,				/**< Right connection. */
	ConnectionBottomMask = 8				/**< Bottom connection. */
};

/**
 * List of all possible block states.
 */
typedef enum {
	BlockNormalState = 0,					/**< Block is doing nothing. */
	BlockFallingState = 1,					/**< Block is falling down the grid. */
	BlockLandingState = 2,					/**< Block is landing. */
	BlockExplodingState = 3,				/**< Block is exploding. */
	BlockExplodedState = 4,					/**< Block has exploded. */
	BlockRecoveringFromGarbageHitState = 5	/**< Block is adjusting back to its standard co-ords. */
} BlockState;

/**
 * Base class for all blocks that appear in the grid.
 */
@interface BlockBase : NSObject {
@private
	int _connections;				/**< Bitmask of active connections. */
	BlockState _state;				/**< Current state of the block. */
	BOOL _hasDroppedHalfBlock;		/**< True if the block has dropped half a grid square. */

	int _x;							/**< The x co-ordinate of the block. */
	int _y;							/**< The y co-ordinate of the block. */

	BlockEvent _onStartExploding;	/**< Event triggered when the block starts exploding. */
	BlockEvent _onStopExploding;	/**< Event triggered when the block stops exploding. */
	BlockEvent _onStartLanding;		/**< Event triggered when the block starts landing. */
	BlockEvent _onStopLanding;		/**< Event triggered when the block stops landing. */
	BlockEvent _onStartFalling;		/**< Event triggered when the block starts falling. */
	BlockEvent _onMove;				/**< Event triggered when the block moves. */
	BlockEvent _onConnect;			/**< Event triggered when the block's connections change. */
}

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
@property(readwrite, copy) BlockEvent onStartExploding;

/**
 * Event triggered when the block stops exploding.
 */
@property(readwrite, copy) BlockEvent onStopExploding;

/**
 * Event triggered when the block starts to land.
 */
@property(readwrite, copy) BlockEvent onStartLanding;

/**
 * Event triggered when the block stops landing.
 */
@property(readwrite, copy) BlockEvent onStopLanding;

/**
 * Event triggered when the block starts falling.
 */
@property(readwrite, copy) BlockEvent onStartFalling;

/**
 * Event triggered when the block moves.
 */
@property(readwrite, copy) BlockEvent onMove;

/**
 * Event triggered when the block's connections change.
 */
@property(readwrite, copy) BlockEvent onConnect;
		
/**
 * The current state of the block.
 */
@property(readonly) BlockState state;

/**
 * True if the block has dropped half a grid square.
 */
@property(readonly) BOOL hasDroppedHalfBlock;

/**
 * Bitmask of active connections.
 */
@property(readonly) int connections;

/**
 * Initialises a new instance of the class.
 */
- (id)init;

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
 * Inform the block that it is falling.
 */
- (void)startFalling;

/**
 * Inform the block that it is exploding.
 */
- (void)startExploding;

/**
 * Inform the block that it is no longer exploding.
 */
- (void)stopExploding;

/**
 * Inform the block that it is landing.
 */
- (void)startLanding;

/**
 * Inform the block that it is no longer landing.
 */
- (void)stopLanding;

/**
 * Inform the block that it is recovering from being hit by garbage.
 */
- (void)startRecoveringFromGarbageHit;

/**
 * Inform the block that it is no longer recovering from being hit by garbage.
 */
- (void)stopRecoveringFromGarbageHit;

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
