#import <Foundation/NSObject.h>
#import <Foundation/NSArray.h>

#import "SZPoint.h"
#import "BlockBase.h"

#define GRID_WIDTH 6
#define GRID_HEIGHT 13
#define CHAIN_LENGTH 4
#define GRID_SIZE 78
#define LIVE_BLOCK_COUNT 2
#define BLOCK_EXPLODE_SCORE 10

@class Grid;
@class BlockBase;

/**
 * Signature of a closure used as an event callback.  The grid that raised the
 * event is passed as the parameter.  These events affect the grid as a whole,
 * such as a row of garbage being added to the grid or a block landing.
 */
typedef void(^GridEvent)(Grid*);

/**
 * Signature of a closure used as an event callback.  The grid and block that
 * raised the event are passed as the parameters.  These events are specific to
 * individual blocks, such as a block being added to the grid or a garbage block
 * landing.
 */
typedef void(^GridBlockEvent)(Grid* grid, BlockBase* block);

/**
 * Maintains the list of blocks that make up the playing grid.
 */
@interface Grid : NSObject {
@private
	BlockBase* _data[GRID_SIZE];			/**< The array of blocks that constitutes the grid. */
	SZPoint* _liveBlocks[LIVE_BLOCK_COUNT];	/**< The co-ordinates of the two live blocks in the grid. */
	BOOL _hasLiveBlocks;					/**< True if the grid has player-controlled blocks; false if not. */
	int _playerNumber;						/**< The zero-based number of the player controlling this grid. */
	
	GridEvent _onGarbageRowAdded;			/**< Event triggered when an entire row of garbage is added to the grid. */
	GridEvent _onLand;						/**< Event triggered when any block lands. */
	GridEvent _onGarbageLand;				/**< Event triggered when any garbage lands. */

	GridBlockEvent _onBlockAdd;				/**< Event triggered when a new block is added to the grid. */
	GridBlockEvent _onBlockRemove;			/**< Event triggered when a block is removed from the grid. */
	GridBlockEvent _onGarbageBlockLand;		/**< Event triggered when a single garbage block lands. */
}

@property(readonly) BOOL hasLiveBlocks;
@property(readonly) int playerNumber;

@property(readwrite, copy) GridEvent onGarbageLand;
@property(readwrite, copy) GridEvent onGarbageRowAdded;
@property(readwrite, copy) GridEvent onLand;

@property(readwrite, copy) GridBlockEvent onBlockAdd;
@property(readwrite, copy) GridBlockEvent onBlockRemove;
@property(readwrite, copy) GridBlockEvent onGarbageBlockLand;

- (id)initWithPlayerNumber:(int)playerNumber;
- (void)dealloc;

- (void)clear;
- (BlockBase*)blockAtCoordinatesX:(int)x y:(int)y;
- (BOOL)explodeChains:(int*)score chainCount:(int*)chainCount blocks:(int*)blocks;
- (void)dropLiveBlocks;
- (BOOL)dropBlocks;
- (BOOL)moveLiveBlocksLeft;
- (BOOL)moveLiveBlocksRight;
- (BOOL)rotateLiveBlocksClockwise;
- (BOOL)rotateLiveBlocksAntiClockwise;
- (BOOL)addBlock:(BlockBase*)block x:(int)x y:(int)y;
- (BOOL)addLiveBlocks:(BlockBase*)block1 block2:(BlockBase*)block2;
- (void)connectBlocks;
- (BOOL)animate;
- (int)heightOfColumnAtIndex:(int)column;
- (void)addGarbage:(int)count;
- (int)getPotentialExplodedBlockCount:(int)x y:(int)y block:(BlockBase*)block checkedData:(BOOL*)checkedData;
- (BlockBase*)liveBlock:(int)index;

- (void)setBlockAtCoordinatesX:(int)x y:(int)y block:(BlockBase*)block;
- (void)moveBlockFromSourceX:(int)sourceX sourceY:(int)sourceY toDestinationX:(int)destinationX destinationY:(int)destinationY;
- (BOOL)isValidCoordinateX:(int)x y:(int)y;
- (NSMutableArray*)newPointChainFromCoordinatesX:(int)x y:(int)y checkedData:(BOOL*)checkedData;
- (NSMutableArray*)newPointChainsFromAllCoordinates;

- (void)createBottomRow;

@end
