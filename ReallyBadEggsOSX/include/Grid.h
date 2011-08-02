#import <Foundation/NSObject.h>
#import <Foundation/NSArray.h>

#import "SZPoint.h"
#import "BlockBase.h"

#define GRID_WIDTH 6
#define GRID_HEIGHT 12
#define CHAIN_LENGTH 4
#define BLOCK_SIZE 16
#define GRID_SIZE 72
#define LIVE_BLOCK_COUNT 2
#define BLOCK_EXPLODE_SCORE 10
#define GARBAGE_LAND_OFFSET 5

@class Grid;

typedef void(^GridEvent)(Grid*);
typedef void(^GridBlockEvent)(Grid* grid, BlockBase* block);

@interface Grid : NSObject {
@private
	BlockBase* _data[GRID_SIZE];
	SZPoint* _liveBlocks[LIVE_BLOCK_COUNT];
	BOOL _hasLiveBlocks;
	int _columnOffsets[GRID_WIDTH];
	int _playerNumber;
	
	GridEvent _onGarbageRowAdded;			/**< Event triggered when an entire row of garbage is added to the grid. */
	GridEvent _onLand;						/**< Event triggered when any block lands. */
	GridEvent _onGarbageLand;				/**< Event triggered when any garbage lands. */

	GridBlockEvent _onBlockAdd;				/**< Event triggered when a new block is added to the grid. */
	GridBlockEvent _onBlockRemove;			/**< Event triggered when a block is removed from the grid. */
}

@property(readonly) BOOL hasLiveBlocks;

@property(readwrite, copy) GridEvent onGarbageRowAdded;
@property(readwrite, copy) GridEvent onLand;

@property(readwrite, copy) GridBlockEvent onBlockAdd;
@property(readwrite, copy) GridBlockEvent onGarbageLand;
@property(readwrite, copy) GridBlockEvent onBlockRemove;

- (id)initWithHeight:(int)height playerNumber:(int)playerNumber;
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
- (BOOL)addLiveBlocks:(BlockBase*)block1 block2:(BlockBase*)block2;
- (void)connectBlocks;
- (BOOL)animate;
- (int)heightOfColumnAtIndex:(int)column;
- (void)addGarbage:(int)count;
- (int)getPotentialExplodedBlockCount:(int)x y:(int)y block:(BlockBase*)block checkedData:(BOOL*)checkedData;
- (NSArray*)newLiveBlockPoints;

- (void)setBlockAtCoordinatesX:(int)x y:(int)y block:(BlockBase*)block;
- (void)moveBlockFromSourceX:(int)sourceX sourceY:(int)sourceY toDestinationX:(int)destinationX destinationY:(int)destinationY;
- (BOOL)isValidCoordinateX:(int)x y:(int)y;
- (NSMutableArray*)newPointChainFromCoordinatesX:(int)x y:(int)y checkedData:(BOOL*)checkedData;
- (NSMutableArray*)newPointChainsFromAllCoordinates;

@end