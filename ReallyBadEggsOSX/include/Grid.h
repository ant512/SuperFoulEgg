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

@interface Grid : NSObject {
@private
	BlockBase* _data[GRID_SIZE];
	SZPoint* _liveBlocks[LIVE_BLOCK_COUNT];
	BOOL _hasLiveBlocks;
	int _columnOffsets[GRID_WIDTH];
	int _playerNumber;
	
	GridEvent _onBlockLand;
	GridEvent _onGarbageLand;
	GridEvent _onBlockMove;
	GridEvent _onBlockRotate;
	GridEvent _onGarbageRowAdded;
}

@property(readonly) BOOL hasLiveBlocks;
@property(readwrite, copy) GridEvent onBlockLand;
@property(readwrite, copy) GridEvent onGarbageLand;
@property(readwrite, copy) GridEvent onBlockMove;
@property(readwrite, copy) GridEvent onBlockRotate;
@property(readwrite, copy) GridEvent onGarbageRowAdded;


- (id)initWithHeight:(int)height playerNumber:(int)playerNumber;
- (void)dealloc;

- (void)clear;
- (BlockBase*)blockAtCoordinatesX:(int)x y:(int)y;
- (BOOL)explodeChains:(int*)score chainCount:(int*)chainCount blocks:(int*)blocks;
- (void)dropLiveBlocks;
- (BOOL)dropBlocks;
- (void)moveLiveBlocksLeft;
- (void)moveLiveBlocksRight;
- (void)rotateLiveBlocksClockwise;
- (void)rotateLiveBlocksAntiClockwise;
- (BOOL)addLiveBlocks:(BlockBase*)block1 block2:(BlockBase*)block2;
- (void)connectBlocks;
- (BOOL)animate;
- (int)heightOfColumnAtIndex:(int)column;
- (void)addGarbage:(int)count;
- (int)getPotentialExplodedBlockCount:(int)x y:(int)y block:(BlockBase*)block checkedData:(BOOL*)checkedData;
- (NSArray*)newLiveBlockPoints;

- (void)setBlockAtCoordinatesX:(int)x y:(int)y block:(BlockBase*)block;
- (void)moveBlockFromSourceX:(int)sourceX sourceY:(int)srcY toDestinationX:(int)destX destinationY:(int)destY;
- (BOOL)isValidCoordinateX:(int)x y:(int)y;
- (NSMutableArray*)newPointChainFromCoordinatesX:(int)x y:(int)y checkedData:(BOOL*)checkedData;
- (NSMutableArray*)newPointChainsFromAllCoordinates;

@end