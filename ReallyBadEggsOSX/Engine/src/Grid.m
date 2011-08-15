#import <Foundation/Foundation.h>

#import "Grid.h"
#import "GarbageBlock.h"
#import "GridBottomBlock.h"
#import "GridBottomLeftBlock.h"
#import "GridBottomRightBlock.h"
#import "SZPoint.h"

@implementation Grid

@synthesize hasLiveBlocks = _hasLiveBlocks;
@synthesize playerNumber = _playerNumber;

@synthesize onBlockAdd = _onBlockAdd;
@synthesize onBlockRemove = _onBlockRemove;
@synthesize onGarbageBlockLand = _onGarbageBlockLand;

@synthesize onGarbageLand = _onGarbageLand;
@synthesize onGarbageRowAdded = _onGarbageRowAdded;
@synthesize onLand = _onLand;

- (id)initWithPlayerNumber:(int)playerNumber {
	if ((self = [super init])) {
		_hasLiveBlocks = NO;
		_playerNumber = playerNumber;
		
		for (int i = 0; i < LIVE_BLOCK_COUNT; ++i) {
			_liveBlocks[i] = nil;
		}
	}
	
	return self;
}

- (id)init {
	return [self initWithPlayerNumber:0];
}

- (void)dealloc {
	if (_onBlockAdd != nil) Block_release(_onBlockAdd);
	if (_onBlockRemove != nil) Block_release(_onBlockRemove);
	if (_onGarbageBlockLand != nil) Block_release(_onGarbageBlockLand);
	if (_onGarbageLand != nil) Block_release(_onGarbageLand);
	if (_onGarbageRowAdded != nil) Block_release(_onGarbageRowAdded);
	if (_onLand != nil) Block_release(_onLand);
	
	[super dealloc];
}

- (void)addBlock:(BlockBase*)block x:(int)x y:(int)y {
	if (_onBlockAdd != nil) _onBlockAdd(self, block);
	[super addBlock:block x:x y:y];
}

- (void)removeBlockAtX:(int)x y:(int)y {
	if (_onBlockRemove != nil) _onBlockRemove(self, [self blockAtX:x y:y]);
	[super removeBlockAtX:x y:y];
}

- (void)createBottomRow {

	BlockBase* block = [[GridBottomLeftBlock alloc] init];
	[self addBlock:block x:0 y:GRID_HEIGHT - 1];
	[block release];
	
	for (int i = 1; i < GRID_WIDTH - 1; ++i) {
		block = [[GridBottomBlock alloc] init];
		[self addBlock:block x:i y:GRID_HEIGHT - 1];
		[block release];
	}
	
	block = [[GridBottomRightBlock alloc] init];
	[self addBlock:block x:GRID_WIDTH - 1 y:GRID_HEIGHT - 1];
	[block release];
}

- (BOOL)explodeChains:(int*)score chainCount:(int*)chainCount blocks:(int*)blocks {
	
	*score = 0;
	*blocks = 0;

	NSMutableArray* chains = [self newPointChainsFromAllCoordinates];
	
	int iteration = 0;

	// These are the co-ordinates of the 4 blocks adjacent to the current block
	static int xCoords[4] = { -1, 1, 0, 0 };
	static int yCoords[4] = { 0, 0, -1, 1 };

	for (NSArray* chain in chains) {

		*score += BLOCK_EXPLODE_SCORE * [chain count] * ([chain count] - CHAIN_LENGTH + 1);
		*blocks += [chain count];

		for (SZPoint* point in chain) {
            
            if ([self blockAtX:point.x y:point.y].state == BlockExplodingState) {
                int j  =2;
                ++j;
                
            }
			
			[[self blockAtX:point.x y:point.y] startExploding];

			// Remove any adjacent garbage
			for (int i = 0; i < 4; ++i) {

				BlockBase* garbage = [self blockAtX:point.x + xCoords[i] y:point.y + yCoords[i]];
				if (garbage != nil && [garbage isKindOfClass:[GarbageBlock class]]) {
					[garbage startExploding];

					*score += BLOCK_EXPLODE_SCORE * iteration;
				}
			}
		}

		++iteration;
	}

	[chains release];

	return *score > 0;
}

- (NSMutableArray*)newPointChainsFromAllCoordinates {

	NSMutableArray* chains = [[NSMutableArray alloc] init];

	// Array of bools remembers which blocks we've already examined so that we
	// don't check them again and get stuck in a loop
	BOOL checkedData[GRID_SIZE];

	for (int i = 0; i < GRID_SIZE; ++i) {
		checkedData[i] = NO;
	}

	for (int y = 0; y < GRID_HEIGHT; ++y) {
		for (int x = 0; x < GRID_WIDTH; ++x) {

			// Skip if block already checked
			if (checkedData[x + (y * GRID_WIDTH)]) continue;

			NSMutableArray* chain = [self newPointChainFromCoordinatesX:x y:y checkedData:checkedData];

			// Only remember the chain if it has the minimum number of blocks in
			// it at least
			if ([chain count] >= CHAIN_LENGTH) {
				[chains addObject:chain];
			}
			
			[chain release];
		}
	}
	
	return chains;
}

- (BlockBase*)liveBlock:(int)index {
	NSAssert(index < 2, @"Only 2 live blocks are available.");
	
	return _liveBlocks[index];
}

- (int)getPotentialExplodedBlockCount:(int)x y:(int)y block:(BlockBase*)block checkedData:(BOOL*)checkedData {

	NSAssert([self isValidCoordinateX:x y:y], @"Invalid co-ordinates supplied.");
	
	checkedData[x + (y * GRID_WIDTH)] = YES;

	NSMutableArray* chain = [[NSMutableArray alloc] init];
	NSMutableArray* singleChain = nil;

	// These are the co-ordinates of the 4 blocks adjacent to the current block
	static int xCoords[4] = { -1, 1, 0, 0 };
	static int yCoords[4] = { 0, 0, -1, 1 };

	// Analyze all adjacent blocks
	for (int i = 0; i < 4; ++i) {

		BlockBase* gridBlock = [self blockAtX:x + xCoords[i] y:y + yCoords[i]];
		if (gridBlock != nil && [gridBlock class] == [block class]) {
			singleChain = [self newPointChainFromCoordinatesX:x + xCoords[i] y:y + yCoords[i] checkedData:checkedData];

			for (id point in singleChain) {
				[chain addObject:point];
			}

			[singleChain release];
		}
	}

	// Calculate how many garbage blocks will be exploded by the chain
	int garbageCount = 0;

	if ([chain count] >= CHAIN_LENGTH) {
		BlockBase* gridBlock = nil;

		for (id item in chain) {

			SZPoint* point = (SZPoint*)item;
			
			// Check all adjacent blocks to see if they are garbage
			for (int i = 0; i < 4; ++i) {

				gridBlock = [self blockAtX:point.x + xCoords[i] y:point.y + yCoords[i]];

				if ((gridBlock != nil) && (!checkedData[point.x + xCoords[i] + ((point.y + yCoords[i]) * GRID_WIDTH)])) {

					if ([gridBlock isKindOfClass:[GarbageBlock class]]) {
						checkedData[point.x + xCoords[i] + ((point.y + yCoords[i]) * GRID_WIDTH)] = YES;
						++garbageCount;
					}
				}
			}
		}
	}

	// Total length is the number of connected grid blocks found, plus the
	// block we're trying to place, plus the number of garbage blocks that will
	// be exploded
	int length = (int)[chain count] + 1 + garbageCount;

	[chain release];

	return length;
}

- (NSMutableArray*)newPointChainFromCoordinatesX:(int)x y:(int)y checkedData:(BOOL*)checkedData {

	NSAssert([self isValidCoordinateX:x y:y], @"Invalid co-ordinates supplied.");

	// Stop if we've checked this block already
	if (checkedData[x + (y * GRID_WIDTH)]) return nil;

	int index = 0;

	NSMutableArray* chain = [[NSMutableArray alloc] init];

	// Add the start of the chain to the list of blocks that comprise the chain
	SZPoint* startPoint = [[SZPoint alloc] initWithX:x y:y];

	[chain addObject:startPoint];
	[startPoint release];

	// Ensure we don't check this block again
	checkedData[x + (y * GRID_WIDTH)] = YES;

	// Check the blocks that surround every block in the chain to see if they
	// should be part of the chain.  If so, add them to the chain.
	while (index < [chain count]) {

		SZPoint* point = [chain objectAtIndex:index];
		BlockBase* block = [self blockAtX:point.x y:point.y];

		if (block == nil) return chain;

		// Check if the block on the left of this is part of the chain.  Ignore
		// the block if it has already been checked.
		if (point.x - 1 >= 0 && !checkedData[point.x - 1 + (point.y * GRID_WIDTH)]) {

			if ([block hasLeftConnection]) {

				// Block is part of the chain so remember its co-ordinates
				SZPoint* adjacentPoint = [[SZPoint alloc] initWithX:point.x - 1 y:point.y];

				[chain addObject:adjacentPoint];

				// Now that we know this block is part of a chain we don't want
				// to check it again
				checkedData[adjacentPoint.x + (adjacentPoint.y * GRID_WIDTH)] = YES;

				[adjacentPoint release];
			}
		}

		if (point.x + 1 < GRID_WIDTH && !checkedData[point.x + 1 + (point.y * GRID_WIDTH)]) {

			if ([block hasRightConnection]) {

				SZPoint* adjacentPoint = [[SZPoint alloc] initWithX:point.x + 1 y:point.y];

				[chain addObject:adjacentPoint];

				checkedData[adjacentPoint.x + (adjacentPoint.y * GRID_WIDTH)] = YES;

				[adjacentPoint release];
			}
		}

		if (point.y - 1 >= 0 && !checkedData[point.x + ((point.y - 1) * GRID_WIDTH)]) {

			if ([block hasTopConnection]) {

				SZPoint* adjacentPoint = [[SZPoint alloc] initWithX:point.x y:point.y - 1];

				[chain addObject:adjacentPoint];

				checkedData[adjacentPoint.x + (adjacentPoint.y * GRID_WIDTH)] = YES;

				[adjacentPoint release];
			}
		}

		if (point.y + 1 < GRID_HEIGHT && !checkedData[point.x + ((point.y + 1) * GRID_WIDTH)]) {

			if ([block hasBottomConnection]) {

				SZPoint* adjacentPoint = [[SZPoint alloc] initWithX:point.x y:point.y + 1];

				[chain addObject:adjacentPoint];

				checkedData[adjacentPoint.x + (adjacentPoint.y * GRID_WIDTH)] = YES;

				[adjacentPoint release];
			}
		}

		index++;
	}

	return chain;
}

- (void)dropLiveBlocks {

	NSAssert(_hasLiveBlocks, @"No live blocks in play.");

	BOOL hasLanded = NO;

	// Check both live blocks for collisions before we try to drop them.  This
	// prevents us from getting into a situation in which one of the pair drops
	// and the other hits something
	for (int i = 0; i < LIVE_BLOCK_COUNT; ++i) {

		// Check if the block has landed on another.  We don't need to bother
		// checking if the block is at the bottom of the grid because live
		// blocks can never reach there - the row of bottom blocks prevents it
		BlockBase* blockBelow = [self blockAtX:_liveBlocks[i].x y:_liveBlocks[i].y + 1];

		if (blockBelow != nil) {

			// Do not land if the block below is also falling
			if (blockBelow.state != BlockFallingState) {
				_hasLiveBlocks = NO;

				[_liveBlocks[i] startLanding];

				hasLanded = YES;
			}
		}
	}

	if (_hasLiveBlocks) {

		// Blocks are still live - drop them to the next position.  Drop block
		// 1 first as when vertical 1 is always below
		for (int i = LIVE_BLOCK_COUNT - 1; i >= 0; --i) {

			if (_liveBlocks[i].hasDroppedHalfBlock) {
				[self moveBlockFromSourceX:_liveBlocks[i].x sourceY:_liveBlocks[i].y toDestinationX:_liveBlocks[i].x destinationY:_liveBlocks[i].y + 1];
			}
			
			[_liveBlocks[i] dropHalfBlock];
		}
	}

	if (hasLanded) {
		if (_onLand != nil) _onLand(self);
	}
}

- (BOOL)dropBlocks {

	NSAssert(!_hasLiveBlocks, @"Live blocks are in play.");

	BOOL hasDropped = NO;
	BOOL hasLanded = NO;
	BOOL isGarbage = NO;

	// Everything on the bottom row should have landed
	for (int x = 0; x < GRID_WIDTH; ++x) {
		BlockBase* block = [self blockAtX:x y:GRID_HEIGHT - 1];

		if (block != nil && block.state == BlockFallingState) {

			[block startLanding];
			hasLanded = YES;

			// Fire an event if the landed block is garbage
			if ([block isKindOfClass:[GarbageBlock class]]) {
				
				if (_onGarbageBlockLand != nil) _onGarbageBlockLand(self, block);

				isGarbage = YES;
			}
		}
	}

	// Drop starts at the second row from the bottom of the grid as there's no
	// point in dropping the bottom row
	for (int y = GRID_HEIGHT - 2; y >= 0; --y) {
		for (int x = 0; x < GRID_WIDTH; ++x) {
			
			BlockBase* block = [self blockAtX:x y:y];

			// Ignore this block if it's empty
			if (block == nil) continue;

			// Drop the current block if the block below is empty
			if ([self blockAtX:x y:y + 1] == nil) {
				
				if (block.hasDroppedHalfBlock) {
					[self moveBlockFromSourceX:x sourceY:y toDestinationX:x destinationY:y + 1];
				}
				
				[block dropHalfBlock];
				[block startFalling];

				hasDropped = YES;
			} else if (block.state == BlockFallingState) {

				if ([self blockAtX:x y:y + 1].state != BlockFallingState) {

					[block startLanding];
					hasLanded = YES;

					// Fire an event if the landed block is garbage
					if ([block isKindOfClass:[GarbageBlock class]]) {
						
						if (_onGarbageBlockLand != nil) _onGarbageBlockLand(self, block);

						isGarbage = YES;
					}
				}
			}
		}
	}

	if (hasLanded) {
		if (isGarbage) {
			if (_onGarbageLand != nil) _onGarbageLand(self);
		} else {
			if (_onLand != nil) _onLand(self);
		}
	}

	return hasDropped;
}

- (BOOL)moveLiveBlocksLeft {
	NSAssert(_hasLiveBlocks, @"No live blocks in play");

	// 0 block should always be on the left or at the top
	if (_liveBlocks[0].x == 0) return NO;

	// Check the block to the left
	if ([self blockAtX:_liveBlocks[0].x - 1 y:_liveBlocks[0].y] != nil) return NO;

	// If we've dropped half a block we also need to check the block left and
	// down one
	if (_liveBlocks[0].hasDroppedHalfBlock) {
		if ([self blockAtX:_liveBlocks[0].x - 1 y:_liveBlocks[0].y + 1] != nil) return NO;
	}

	// Check 1 block if it is below the 0 block
	if (_liveBlocks[0].x == _liveBlocks[1].x) {
		if ([self blockAtX:_liveBlocks[1].x - 1 y:_liveBlocks[1].y] != nil) return NO;

		// Check the block left and down one if we've dropped a half block
		if (_liveBlocks[1].hasDroppedHalfBlock) {
			if ([self blockAtX:_liveBlocks[1].x - 1 y:_liveBlocks[1].y + 1] != nil) return NO;
		}
	}

	// Blocks can move
	for (int i = 0; i < LIVE_BLOCK_COUNT; ++i) {
		[self moveBlockFromSourceX:_liveBlocks[i].x sourceY:_liveBlocks[i].y toDestinationX:_liveBlocks[i].x - 1 destinationY:_liveBlocks[i].y];
	}

	return YES;
}

- (BOOL)moveLiveBlocksRight {
	NSAssert(_hasLiveBlocks, @"No live blocks in play");

	// 1 block should always be on the right or at the bottom
	if (_liveBlocks[1].x == GRID_WIDTH - 1) return NO;

	// Check the block to the right
	if ([self blockAtX:_liveBlocks[1].x + 1 y:_liveBlocks[1].y] != nil) return NO;

	// If we've dropped half a block we also need to check the block right and
	// down one
	if (_liveBlocks[1].hasDroppedHalfBlock) {
		if ([self blockAtX:_liveBlocks[1].x + 1 y:_liveBlocks[1].y + 1] != nil) return NO;
	}

	// Check 0 block if it is above the 1 block
	if (_liveBlocks[0].x == _liveBlocks[1].x) {
		if ([self blockAtX:_liveBlocks[0].x + 1 y:_liveBlocks[0].y] != nil) return NO;

		// Check the block right and down one if we've dropped a half block
		if (_liveBlocks[0].hasDroppedHalfBlock) {
			if ([self blockAtX:_liveBlocks[0].x + 1 y:_liveBlocks[0].y + 1] != nil) return NO;
		}
	}

	// Blocks can move
	for (int i = LIVE_BLOCK_COUNT - 1; i >= 0; --i) {
		[self moveBlockFromSourceX:_liveBlocks[i].x sourceY:_liveBlocks[i].y toDestinationX:_liveBlocks[i].x + 1 destinationY:_liveBlocks[i].y];
	}

	return YES;
}

- (BOOL)rotateLiveBlocksClockwise {
	NSAssert(_hasLiveBlocks, @"No live blocks in play");

	// Determine whether to swap to a vertical or horizontal arrangement
	if (_liveBlocks[0].y == _liveBlocks[1].y) {

		// Swapping to vertical

		// Do not need to check for the bottom of the well as the bottom row of
		// blocks eliminates the possibility of blocks being there

		// Cannot swap if the block below the block on the right is populated
		if ([self blockAtX:_liveBlocks[1].x y:_liveBlocks[1].y + 1] != nil) return NO;

		// Cannot swap if the block 2 below the block on the right is populated
		// if we've dropped a half block
		if (_liveBlocks[1].hasDroppedHalfBlock) {
			if ([self blockAtX:_liveBlocks[1].x y:_liveBlocks[1].y + 2] != nil) return NO;
		}

		// Perform the rotation

		// Move the right block down one place
		[self moveBlockFromSourceX:_liveBlocks[1].x sourceY:_liveBlocks[1].y toDestinationX:_liveBlocks[1].x destinationY:_liveBlocks[1].y + 1];

		// Move the left block right one place
		[self moveBlockFromSourceX:_liveBlocks[0].x sourceY:_liveBlocks[0].y toDestinationX:_liveBlocks[0].x + 1 destinationY:_liveBlocks[0].y];

	} else {

		// Swapping to horizontal

		// Cannot swap if the blocks are at the left edge of the well
		if (_liveBlocks[0].x == 0) return NO;

		// Cannot swap if the block to the left of the block at the top is populated
		if ([self blockAtX:_liveBlocks[0].x - 1 y:_liveBlocks[0].y] != nil) return NO;

		// Cannot swap if the block below the block on the left of the top block
		// is populated if we've dropped a half block
		if (_liveBlocks[0].hasDroppedHalfBlock) {
			if ([self blockAtX:_liveBlocks[0].x - 1 y:_liveBlocks[0].y + 1] != nil) return NO;
		}

		// Perform the rotation

		// Move the bottom block up and left
		[self moveBlockFromSourceX:_liveBlocks[1].x sourceY:_liveBlocks[1].y toDestinationX:_liveBlocks[0].x - 1 destinationY:_liveBlocks[0].y];

		// 0 block should always be on the left
		BlockBase* tmp = _liveBlocks[0];
		_liveBlocks[0] = _liveBlocks[1];
		_liveBlocks[1] = tmp;
	}

	return YES;
}

- (BOOL)rotateLiveBlocksAntiClockwise {
	NSAssert(_hasLiveBlocks, @"No live blocks in play");

	// Determine whether the blocks swap to a vertical or horizontal arrangement
	if (_liveBlocks[0].y == _liveBlocks[1].y) {

		// Swapping to vertical

		// Do not need to check for the bottom of the well as the bottom row of
		// blocks eliminates the possibility of blocks being there

		// Cannot swap if the block below the block on the right is populated
		if ([self blockAtX:_liveBlocks[1].x y:_liveBlocks[1].y + 1] != nil) return NO;

		// Cannot swap if the block 2 below the block on the right is populated
		// if we've dropped a half block
		if (_liveBlocks[1].hasDroppedHalfBlock) {
			if ([self blockAtX:_liveBlocks[1].x y:_liveBlocks[1].y + 2] != nil) return NO;
		}

		// Perform the rotation

		// Move the left block down and right
		[self moveBlockFromSourceX:_liveBlocks[0].x sourceY:_liveBlocks[0].y toDestinationX:_liveBlocks[1].x destinationY:_liveBlocks[1].y + 1];

		// 0 block should always be at the top
		BlockBase* tmp = _liveBlocks[0];
		_liveBlocks[0] = _liveBlocks[1];
		_liveBlocks[1] = tmp;

	} else {

		// Swapping to horizontal

		// Cannot swap if the blocks are at the left edge of the well
		if (_liveBlocks[0].x == 0) return NO;

		// Cannot swap if the block to the left of the block at the top is populated
		if ([self blockAtX:_liveBlocks[0].x - 1 y:_liveBlocks[0].y] != nil) return NO;

		// Cannot swap if the block below the block on the left of the top block
		// is populated if we've dropped a half block
		if (_liveBlocks[0].hasDroppedHalfBlock) {
			if ([self blockAtX:_liveBlocks[0].x - 1 y:_liveBlocks[0].y + 1] != nil) return NO;
		}

		// Perform the rotation

		// Move the top block left
		[self moveBlockFromSourceX:_liveBlocks[0].x sourceY:_liveBlocks[0].y toDestinationX:_liveBlocks[0].x - 1 destinationY:_liveBlocks[0].y];

		// Move the bottom block up
		[self moveBlockFromSourceX:_liveBlocks[1].x sourceY:_liveBlocks[1].y toDestinationX:_liveBlocks[1].x destinationY:_liveBlocks[1].y - 1];
	}

	return YES;
}

- (BOOL)addLiveBlocks:(BlockBase*)block1 block2:(BlockBase*)block2 {

	// Do not add more live blocks if we have blocks already.  However, return
	// true because we don't want to treat this as a special case; as far as
	// any other code is concerned it did its job - live blocks are in play
	if (_hasLiveBlocks) return YES;

	// Cannot add live blocks if the grid positions already contain blocks
	if ([self blockAtX:2 y:0] != nil) return NO;
	if ([self blockAtX:3 y:0] != nil) return NO;
	
	// Live blocks always appear at the same co-ordinates
	[self addBlock:block1 x:2 y:0];
	[self addBlock:block2 x:3 y:0];

	[block1 startFalling];
	[block2 startFalling];

	_liveBlocks[0] = block1;
	_liveBlocks[1] = block2;

	_hasLiveBlocks = YES;

	return YES;
}

- (void)connectBlocks {
	
	BlockBase* block = nil;
	
	for (int y = 0; y < GRID_HEIGHT; ++y) {
		for (int x = 0; x < GRID_WIDTH; ++x) {
			block = [self blockAtX:x y:y];
			
			if (block == nil) continue;
			
			[block connect:[self blockAtX:x y:y - 1]
					right:[self blockAtX:x + 1 y:y]
					bottom:[self blockAtX:x y:y + 1]
					left:[self blockAtX:x - 1 y:y]];
		}
	}
}

- (BOOL)animate {

	BOOL result = NO;

	for (int y = 0; y < GRID_HEIGHT; ++y) {
		for (int x = 0; x < GRID_WIDTH; ++x) {
			
			BlockBase* block = [self blockAtX:x y:y];
			
			if (block == nil) continue;

			switch (block.state) {
				case BlockExplodedState:

					[self removeBlockAtX:x y:y];
					result = YES;
					break;
				
				case BlockExplodingState:
				case BlockLandingState:
				case BlockRecoveringFromGarbageHitState:

					// Hold up the grid until the block has finished whatever it is
					// doing
					result = YES;
					break;
					
				default:
					break;
			}
		}
	}

	return result;
}

- (void)addGarbage:(int)count {
	int columnHeights[GRID_WIDTH];
	int columns[GRID_WIDTH];
	int items = 0;

	for (int i = 0; i < GRID_WIDTH; ++i) {
		columnHeights[i] = -1;
	}

	// Add all column heights to the array in sorted order
	for (int i = 0; i < GRID_WIDTH; ++i) {
		int height = [self heightOfColumnAtIndex:i];
		int insertPoint = 0;

		// Locate where to insert this value
		for (int j = 0; j < items; ++j) {
			if (height <= columnHeights[j]) {
				insertPoint = j;
				break;
			}
			
			++insertPoint;
		}
				
		// Find the last column with the same height as the target.
		// Once this is known, we'll insert into a random column between
		// the two.  This ensures that the garbage insertion pattern
		// isn't predictable
		int targetEnd = insertPoint;
				
		while (targetEnd < items - 1 && columnHeights[targetEnd + 1] == height) {
			++targetEnd;
		}
				
		// Choose a column between the start and end at random
		insertPoint += rand() % (targetEnd - insertPoint + 1);
		
		// Shuffle items back one space to create a gap for the new value
		for (int k = items; k > insertPoint; --k) {
			columnHeights[k] = columnHeights[k - 1];
			columns[k] = columns[k - 1];
		}

		columnHeights[insertPoint] = height;
		columns[insertPoint] = i;
		++items;
	}

	// Add all garbage
	int activeColumns = 1;
	int y = columnHeights[0];

	if (count >= GRID_WIDTH) {
		if (_onGarbageRowAdded != nil) _onGarbageRowAdded(self);
	}

	while (count > 0) {

		int oldCount = count;

		while (activeColumns < GRID_WIDTH && columnHeights[activeColumns] <= y) ++activeColumns;

		for (int i = 0; i < activeColumns; ++i) {

			// Find a free block
			int garbageY = 0;
			while ([self blockAtX:columns[i] y:garbageY] != nil && garbageY < GRID_HEIGHT) {
				++garbageY;
			}

			// If we couldn't find a free block we'll try it in the next column
			// instead
			if (garbageY == GRID_HEIGHT) continue;

			GarbageBlock* block = [[GarbageBlock alloc] init];
			[self addBlock:block x:columns[i] y:garbageY];
			[block release];

			--count;

			if (count == 0) break;
		}

		// If we failed to place the block the grid must be full
		if (oldCount == count) return;

		++y;
	}
}

@end
