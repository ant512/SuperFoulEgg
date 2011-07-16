#import <Foundation/NSObject.h>

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
	BOOL _isLanding;				/**< True if the block is landing. */
	BOOL _isFalling;				/**< True if the block is falling. */
	BOOL _hasDroppedHalfBlock;		/**< True if the block has dropped half a grid square. */
}

/**
 * True if the block is exploding.
 */
@property(readonly) BOOL isExploding;

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
 */
- (id)init;

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
 * Check if the block has finished exploding and needs to be removed from the
 * grid.
 * @return True if the block has exploded.
 */
- (BOOL)isExploded;

/**
 * Inform the block that it is falling.
 */
- (void)fall;

/**
 * Explode the block.  Starts the explosion animation.
 */
- (void)explode;

/**
 * Inform the block that it has landed.
 */
- (void)land;

/**
 * If any animations  - landing or exploding - are active, the animations
 * run.  If the block is landing and the landing animation has finished, the
 * isLanding() property is set to false.  Alternatively, if the block is
 * exploding and the explosion animation has finished, the isExploded()
 * property is set to true.
 */
- (void)animate;

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

@end
