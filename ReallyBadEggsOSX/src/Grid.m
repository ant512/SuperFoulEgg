#import "Grid.h"
#import "GarbageBlock.h"

@implementation Grid

@synthesize hasLiveBlocks = _hasLiveBlocks;
@synthesize onBlockLand = _onBlockLand;
@synthesize onGarbageLand = _onGarbageLand;
@synthesize onBlockMove = _onBlockMove;
@synthesize onBlockRotate = _onBlockRotate;
@synthesize onGarbageRowAdded = _onGarbageRowAdded;

- (id)initWithHeight:(int)height playerNumber:(int)playerNumber {
	if ((self = [super init])) {
		for (int i = 0; i < GRID_WIDTH * GRID_HEIGHT; ++i) {
			_data[i] = nil;
		}

		_hasLiveBlocks = NO;
		_playerNumber = playerNumber;
		
		for (int i = 0; i < LIVE_BLOCK_COUNT; ++i) {
			_liveBlocks[i] = [[SZPoint alloc] initWithX:0 y:0];
		}

		// Add rows of garbage
		if (height > GRID_HEIGHT) height = GRID_HEIGHT;

		for (int row = 0; row < height; ++row) {
			for (int x = 0; x < GRID_WIDTH; ++x) {
				int y = GRID_HEIGHT - 1 - row;

				[self setBlockAtCoordinatesX:x y:y block:[[GarbageBlock alloc] init]];
			}
		}

		for (int i = 0; i < GRID_WIDTH; ++i) {
			_columnOffsets[i] = 0;
		}
	}
	
	return self;
}

- (void)dealloc {
	
	for (int i = 0; i < LIVE_BLOCK_COUNT; ++i) {
		[_liveBlocks[i] release];
	}
	
	[self clear];
	[super dealloc];
}

- (void)clear {
	for (int i = 0; i < GRID_WIDTH * GRID_HEIGHT; ++i) {
		if (_data[i] != nil) {
			[_data[i] release];
			_data[i] = nil;
		}
	}
}

- (BlockBase*)blockAtCoordinatesX:(int)x y:(int)y {
	if (![self isValidCoordinate:x y:y]) return 0;

	return _data[x + (y * GRID_WIDTH)];
}

- (void)setBlockAtCoordinatesX:(int)x y:(int)y block:(BlockBase*)block {
	if (![self isValidCoordinate:x y:y]) return;

	int index = x + (y * GRID_WIDTH);

	if (_data[index] != nil) {
		[_data[index] release];
	}

	_data[index] = block;
}

- (void)moveBlockFromSourceX:(int)sourceX sourceY:(int)srcY toDestinationX:(int)destX destinationY:(int)destY {
	if (![self isValidCoordinate:srcX y:srcY]) return;
	if (![self isValidCoordinate:destX y:destY]) return;
	if (srcX == destX && srcY == destY) return;

	int srcIndex = srcX + (srcY * GRID_WIDTH);
	int destIndex = destX + (destY * GRID_WIDTH);

	if (_data[destIndex] != nil) {
		[_data[destIndex] release];
	}

	_data[destIndex] = _data[srcIndex];
	_data[srcIndex] = nil;
}

- (BOOL)isValidCoordinate:(int)x y:(int)y {
	if (x < 0) return NO;
	if (x >= GRID_WIDTH) return NO;
	if (y < 0) return NO;
	if (y >= GRID_HEIGHT) return NO;

	return YES;
}

- (BOOL)explodeChains:(int*)score chainCount:(int*)chainCount blocks:(int*)blocks {
	
	*score = 0;
	*blocks = 0;

	NSMutableArray* chains = [self getChains];
	
	int iteration = 0;

	for (id chain in chains) {

		*score += BLOCK_EXPLODE_SCORE * [chain count] * ([chain count] - CHAIN_LENGTH + 1);
		*blocks += [chain count];

		for (id item in chain) {

			SZPoint* point = (SZPoint*)item;
			
			[[self blockAtCoordinatesX:point.x y:point.y] explode];

			// Remove any adjacent garbage

			BlockBase* garbage = [self blockAtCoordinatesX:point.x - 1 y:point.y];
			if (garbage != nil && [garbage isKindOfClass:[GarbageBlock class]]) {
				[[self blockAtCoordinatesX:point.x - 1 y:point.y] explode];

				*score += BLOCK_EXPLODE_SCORE * iteration;
			}

			garbage = [self blockAtCoordinatesX:point.x + 1 y:point.y];
			if (garbage != nil && [garbage isKindOfClass:[GarbageBlock class]]) {
				[[self blockAtCoordinatesX:point.x + 1 y:point.y] explode];

				*score += BLOCK_EXPLODE_SCORE * iteration;
			}

			garbage = [self blockAtCoordinatesX:point.x y:point.y - 1];
			if (garbage != nil && [garbage isKindOfClass:[GarbageBlock class]]) {
				[[self blockAtCoordinatesX:point.x y:point.y - 1] explode];

				*score += BLOCK_EXPLODE_SCORE * iteration;
			}

			garbage = [self blockAtCoordinatesX:point.x y:point.y + 1];
			if (garbage != nil && [garbage isKindOfClass:[GarbageBlock class]]) {
				[[self blockAtCoordinatesX:point.x y:point.y + 1] explode];

				*score += BLOCK_EXPLODE_SCORE * iteration;
			}
		}

		++iteration;
	}

	[chains release];

	return *score > 0;
}

- (NSMutableArray*)getChains {

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

			NSMutableArray* chain = [self getChain:x y:y checkedData:checkedData];

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

- (NSArray*)getLiveBlockPoints {
	
	// Create copies of the live block points and return those.  Avoiding
	// NSCopying for the moment as the edge-cases sound horrendous
	SZPoint* point1 = [[SZPoint alloc] initWithX:_liveBlocks[0].x y:_liveBlocks[0].y];
	SZPoint* point2 = [[SZPoint alloc] initWithX:_liveBlocks[1].x y:_liveBlocks[1].y];
		
	NSArray* points = [[NSMutableArray alloc] initWithObjects:point1, point2, nil];
	
	[point1 release];
	[point2 release];

	return points;
}

- (int)getPotentialExplodedBlockCount:(int)x y:(int)y block:(BlockBase*)block checkedData:(BOOL*)checkedData {
	
	checkedData[x + (y * GRID_WIDTH)] = YES;

	NSMutableArray* chain = [[NSMutableArray alloc] init];
	NSMutableArray* singleChain = nil;

	BlockBase* gridBlock = [self blockAtCoordinatesX:x - 1 y:y];
	if (gridBlock != nil && [gridBlock class] == [block class]) {
		singleChain = [self getChain:x - 1 y:y checkedData:checkedData];

		for (id point in singleChain) {
			[chain addObject:point];
		}

		[singleChain release];
	}

	gridBlock = [self blockAtCoordinatesX:x + 1 y:y];
	if (gridBlock != nil && [gridBlock class] == [block class]) {
		singleChain = [self getChain:x + 1 y:y checkedData:checkedData];

		for (id point in singleChain) {
			[chain addObject:point];
		}

		[singleChain release];
	}

	gridBlock = [self blockAtCoordinatesX:x y:y - 1];
	if (gridBlock != nil && [gridBlock class] == [block class]) {
		singleChain = [self getChain:x y:y - 1 checkedData:checkedData];

		for (id point in singleChain) {
			[chain addObject:point];
		}

		[singleChain release];
	}

	gridBlock = [self blockAtCoordinatesX:x y:y + 1];
	if (gridBlock != nil && [gridBlock class] == [block class]) {
		singleChain = [self getChain:x y:y + 1 checkedData:checkedData];

		for (id point in singleChain) {
			[chain addObject:point];
		}

		[singleChain release];
	}

	// Calculate how many garbage blocks will be exploded by the chain
	int garbageCount = 0;

	if ([chain count] >= CHAIN_LENGTH) {
		BlockBase* gridBlock = nil;

		for (id item in chain) {

			SZPoint* point = (SZPoint*)item;
			
			// Left block
			gridBlock = [self blockAtCoordinatesX:point.x - 1 y:point.y];

			if ((gridBlock != nil) && (!checkedData[point.x - 1 + (point.y * GRID_WIDTH)])) {

				if ([gridBlock isKindOfClass:[GarbageBlock class]]) {
					checkedData[point.x - 1 + (point.y * GRID_WIDTH)] = YES;
					++garbageCount;
				}
			}

			// Right block
			gridBlock = [self blockAtCoordinatesX:point.x + 1 y:point.y];

			if ((gridBlock != nil) && (!checkedData[point.x + 1 + (point.y * GRID_WIDTH)])) {

				if ([gridBlock isKindOfClass:[GarbageBlock class]]) {
					checkedData[point.x + 1 + (point.y * GRID_WIDTH)] = YES;
					++garbageCount;
				}
			}

			// Top block
			gridBlock = [self blockAtCoordinatesX:point.x y:point.y - 1];

			if ((gridBlock != nil) && (!checkedData[point.x + ((point.y - 1) * GRID_WIDTH)])) {

				if ([gridBlock isKindOfClass:[GarbageBlock class]]) {
					checkedData[point.x + ((point.y - 1) * GRID_WIDTH)] = YES;
					++garbageCount;
				}
			}

			// Bottom block
			gridBlock = [self blockAtCoordinatesX:point.x y:point.y + 1];

			if ((gridBlock != nil) && (!checkedData[point.x + ((point.y + 1) * GRID_WIDTH)])) {

				if ([gridBlock isKindOfClass:[GarbageBlock class]]) {
					checkedData[point.x + ((point.y + 1) * GRID_WIDTH)] = YES;
					++garbageCount;
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

- (NSMutableArray*)getChain:(int)x y:(int)y checkedData:(BOOL*)checkedData {

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
		BlockBase* block = [self blockAtCoordinatesX:point.x y:point.y];

		if (block == nil) return chain;

		// Check if the block on the left of this is part of the chain.  Ignore
		// the block if it has already been checked.
		if (!checkedData[point.x - 1 + (point.y * GRID_WIDTH)]) {

			if ([block hasLeftConnection]) {

				// Block is part of the chain so remember its co-ordinates
				SZPoint* adjacentPoint = [[SZPoint alloc] initWithX:point.x - 1 y:point.y];

				[chain addObject:adjacentPoint];

				// Now that we know this block is part of a chain we don't want
				// to check it again
				checkedData[adjacentPoint.x + (point.y * GRID_WIDTH)] = YES;

				[adjacentPoint release];
			}
		}

		if (!checkedData[point.x + 1 + (point.y * GRID_WIDTH)]) {

			if ([block hasRightConnection]) {

				SZPoint* adjacentPoint = [[SZPoint alloc] initWithX:point.x + 1 y:point.y];

				[chain addObject:adjacentPoint];

				checkedData[adjacentPoint.x + (point.y * GRID_WIDTH)] = YES;

				[adjacentPoint release];
			}
		}

		if (point.y - 1 >= 0 && !checkedData[point.x + ((point.y - 1) * GRID_WIDTH)]) {

			if ([block hasTopConnection]) {

				SZPoint* adjacentPoint = [[SZPoint alloc] initWithX:point.x y:point.y - 1];

				[chain addObject:adjacentPoint];

				checkedData[adjacentPoint.x + (point.y * GRID_WIDTH)] = YES;

				[adjacentPoint release];
			}
		}

		if (point.y + 1 < GRID_HEIGHT && !checkedData[point.x + ((point.y + 1) * GRID_WIDTH)]) {

			if ([block hasBottomConnection]) {

				SZPoint* adjacentPoint = [[SZPoint alloc] initWithX:point.x y:point.y + 1];

				[chain addObject:adjacentPoint];

				checkedData[adjacentPoint.x + (point.y * GRID_WIDTH)] = YES;

				[adjacentPoint release];
			}
		}

		index++;
	}

	return chain;
}

- (void)dropLiveBlocks {

	// Abort if we don't have live blocks to move
	if (!_hasLiveBlocks) return;

	BOOL hasLanded = NO;

	// Check both live blocks for collisions before we try to drop them.  This
	// prevents us from getting into a situation in which one of the pair drops
	// and the other hits something
	for (int i = 0; i < LIVE_BLOCK_COUNT; ++i) {

		// Check if block is at bottom of grid
		if (_liveBlocks[i].y + 1 >= GRID_HEIGHT) {
			_hasLiveBlocks = NO;

			BlockBase* block = [self blockAtCoordinatesX:_liveBlocks[i].x y:_liveBlocks[i].y];
			[block land];

			hasLanded = YES;
		} else {

			// Check if the block has landed on another
			BlockBase* blockBelow = [self blockAtCoordinatesX:_liveBlocks[i].x y:_liveBlocks[i].y + 1];

			if (blockBelow != nil) {

				// Do not land if the block below is also falling
				if (!blockBelow.isFalling) {
					_hasLiveBlocks = NO;

					BlockBase* block = [self blockAtCoordinatesX:_liveBlocks[i].x y:_liveBlocks[i].y];
					[block land];

					hasLanded = YES;
				}
			}
		}
	}

	if (_hasLiveBlocks) {

		// Blocks are still live - drop them to the next position.  Drop block
		// 1 first as when vertical 1 is always below
		for (int i = LIVE_BLOCK_COUNT - 1; i >= 0; --i) {

			BlockBase* liveBlock = [self blockAtCoordinatesX:_liveBlocks[i].x y:_liveBlocks[i].y];
			if (liveBlock.hasDroppedHalfBlock) {
				[self moveBlockFromSourceX:_liveBlocks[i].x sourceY:_liveBlocks[i].y toDestinationX:_liveBlocks[i].x destinationY:_liveBlocks[i].y + 1];
				
				// Update the live block co-ordinates
				++_liveBlocks[i].y;
			}
			
			[liveBlock dropHalfBlock];
		}
	}

	if (hasLanded) {
		if (_onBlockLand != nil) _onBlockLand(self);
	}
}

- (BOOL)dropBlocks {

	// Do not allow blocks to drop if we have live blocks
	if (_hasLiveBlocks) return NO;

	BOOL hasDropped = NO;
	BOOL hasLanded = NO;
	BOOL isGarbage = NO;

	// Everything on the bottom row should have landed
	for (int x = 0; x < GRID_WIDTH; ++x) {
		BlockBase* block = [self blockAtCoordinatesX:x y:GRID_HEIGHT - 1];

		if (block != nil && block.isFalling) {

			// Shake the column
			if ([block isKindOfClass:[GarbageBlock class]]) {
				_columnOffsets[x] = GARBAGE_LAND_OFFSET;

				isGarbage = YES;
			}

			[block land];
			hasLanded = YES;
		}
	}

	// Drop starts at the second row from the bottom of the grid as there's no
	// point in dropping the bottom row
	for (int y = GRID_HEIGHT - 2; y >= 0; --y) {
		for (int x = 0; x < GRID_WIDTH; ++x) {
			
			BlockBase* block = [self blockAtCoordinatesX:x y:y];

			// Ignore this block if it's empty
			if (block == nil) continue;

			// Drop the current block if the block below is empty
			if ([self blockAtCoordinatesX:x y:y + 1] == nil) {
				
				if (block.hasDroppedHalfBlock) {
					[self moveBlockFromSourceX:x sourceY:y toDestinationX:x destinationY:y + 1];
				}
				
				[block dropHalfBlock];
				[block fall];

				hasDropped = YES;
			} else if (block.isFalling) {

				if (![self blockAtCoordinatesX:x y:y + 1].isFalling) {
					[block land];
					hasLanded = YES;

					// Shake the column
					if ([block isKindOfClass:[GarbageBlock class]]) {
						_columnOffsets[x] = GARBAGE_LAND_OFFSET;

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
			if (_onBlockLand != nil) _onBlockLand(self);
		}
	}

	return hasDropped;
}

- (void)moveLiveBlocksLeft {
	if (!_hasLiveBlocks) return;

	BOOL canMove = YES;

	// 0 block should always be on the left or at the top
	if (_liveBlocks[0].x == 0) canMove = NO;

	// Check the block to the left
	if ([self blockAtCoordinatesX:_liveBlocks[0].x - 1 y:_liveBlocks[0].y] != nil) canMove = NO;

	// If we've dropped half a block we also need to check the block left and
	// down one
	if ([self blockAtCoordinatesX:_liveBlocks[0].x y:_liveBlocks[0].y].hasDroppedHalfBlock) {
		if ([self blockAtCoordinatesX:_liveBlocks[0].x - 1 y:_liveBlocks[0].y + 1] != nil) canMove = NO;
	}

	// Check 1 block if it is below the 0 block
	if (_liveBlocks[0].x == _liveBlocks[1].x) {
		if ([self blockAtCoordinatesX:_liveBlocks[1].x - 1 y:_liveBlocks[1].y] != nil) canMove = NO;

		// Check the block left and down one if we've dropped a half block
		if ([self blockAtCoordinatesX:_liveBlocks[1].x y:_liveBlocks[1].y].hasDroppedHalfBlock) {
			if ([self blockAtCoordinatesX:_liveBlocks[1].x - 1 y:_liveBlocks[1].y + 1] != nil) canMove = NO;
		}
	}

	if (canMove) {
		for (int i = 0; i < LIVE_BLOCK_COUNT; ++i) {
			[self moveBlockFromSourceX:_liveBlocks[i].x sourceY:_liveBlocks[i].y toDestinationXX:_liveBlocks[i].x - 1 destinationY:_liveBlocks[i].y];
			--_liveBlocks[i].x;
		}

		if (_onBlockMove != nil) _onBlockMove(self);
	}
}

- (void)moveLiveBlocksRight {
	if (!_hasLiveBlocks) return;

	BOOL canMove = YES;

	// 1 block should always be on the right or at the bottom
	if (_liveBlocks[1].x == GRID_WIDTH - 1) canMove = NO;

	// Check the block to the right
	if ([self blockAtCoordinatesX:_liveBlocks[1].x + 1 y:_liveBlocks[1].y] != nil) canMove = NO;

	// If we've dropped half a block we also need to check the block right and
	// down one
	if ([self blockAtCoordinatesX:_liveBlocks[1].x y:_liveBlocks[1].y].hasDroppedHalfBlock) {
		if ([self blockAtCoordinatesX:_liveBlocks[1].x + 1 y:_liveBlocks[1].y + 1] != nil) canMove = NO;
	}

	// Check 0 block if it is above the 1 block
	if (_liveBlocks[0].x == _liveBlocks[1].x) {
		if ([self blockAtCoordinatesX:_liveBlocks[0].x + 1 y:_liveBlocks[0].y] != nil) canMove = NO;

		// Check the block right and down one if we've dropped a half block
		if ([self blockAtCoordinatesX:_liveBlocks[0].x y:_liveBlocks[0].y].hasDroppedHalfBlock) {
			if ([self blockAtCoordinatesX:_liveBlocks[0].x + 1 y:_liveBlocks[0].y + 1] != nil) canMove = NO;
		}
	}

	if (canMove) {
		for (int i = LIVE_BLOCK_COUNT - 1; i >= 0; --i) {
			[self moveBlockFromSourceX:_liveBlocks[i].x sourceY:_liveBlocks[i].y toDestinationX:_liveBlocks[i].x + 1 destinationY:_liveBlocks[i].y];
			++_liveBlocks[i].x;
		}

		if (_onBlockMove != nil) _onBlockMove(self);
	}
}

- (void)rotateLiveBlocksClockwise {
	if (!_hasLiveBlocks) return;

	// Determine whether the blocks swap to a vertical or horizontal arrangement
	if (_liveBlocks[0].y == _liveBlocks[1].y) {

		// Swapping to vertical

		// Cannot swap if the blocks are at the bottom of the well or they have
		// dropped half a block
		if (_liveBlocks[0].y == GRID_HEIGHT - 1) return;
		if (_liveBlocks[0].y == GRID_HEIGHT - 2 && [self blockAtCoordinatesX:_liveBlocks[0].x y:_liveBlocks[0].y].hasDroppedHalfBlock) return;


		// Cannot swap if the block below the block on the right is populated
		if ([self blockAtCoordinatesX:_liveBlocks[1].x y:_liveBlocks[1].y + 1] != nil) return;

		// Cannot swap if the block 2 below the block on the right is populated
		// if we've dropped a half block
		if ([self blockAtCoordinatesX:_liveBlocks[1].x y:_liveBlocks[1].y].hasDroppedHalfBlock) {
			if ([self blockAtCoordinatesX:_liveBlocks[1].x y:_liveBlocks[1].y + 2] != nil) return;
		}

		// Perform the rotation

		// Move the right block down one place
		[self moveBlockFromSourceX:_liveBlocks[1].x sourceY:_liveBlocks[1].y toDestinationX:_liveBlocks[1].x destinationY:_liveBlocks[1].y + 1];
		++_liveBlocks[1].y;

		// Move the left block right one place
		[self moveBlockFromSourceX:_liveBlocks[0].x sourceY:_liveBlocks[0].y toDestinationX:_liveBlocks[0].x + 1 destinationY:_liveBlocks[0].y];
		++_liveBlocks[0].x;

	} else {

		// Swapping to horizontal

		// Cannot swap if the blocks are at the left edge of the well
		if (_liveBlocks[0].x == 0) return;

		// Cannot swap if the block to the left of the block at the top is populated
		if ([self blockAtCoordinatesX:_liveBlocks[0].x - 1 y:_liveBlocks[0].y] != nil) return;

		// Cannot swap if the block below the block on the left of the top block
		// is populated if we've dropped a half block
		if ([self blockAtCoordinatesX:_liveBlocks[0].x y:_liveBlocks[0].y].hasDroppedHalfBlock) {
			if ([self blockAtCoordinatesX:_liveBlocks[0].x - 1 y:_liveBlocks[0].y + 1] != nil) return;
		}

		// Perform the rotation

		// Move the bottom block up and left
		[self moveBlockFromSourceX:_liveBlocks[1].x sourceY:_liveBlocks[1].y toDestinationX:_liveBlocks[0].x - 1 destinationY:_liveBlocks[0].y];

		// 0 block should always be on the left
		_liveBlocks[1].x = _liveBlocks[0].x;
		_liveBlocks[1].y = _liveBlocks[0].y;

		--_liveBlocks[0].x;
	}

	if (_onBlockRotate != nil) _onBlockRotate(self);
}

- (void)rotateLiveBlocksAntiClockwise {
	if (!_hasLiveBlocks) return;

	// Determine whether the blocks swap to a vertical or horizontal arrangement
	if (_liveBlocks[0].y == _liveBlocks[1].y) {

		// Swapping to vertical

		// Cannot swap if the blocks are at the bottom of the well or they have
		// dropped half a block
		if (_liveBlocks[0].y == GRID_HEIGHT - 1) return;
		if (_liveBlocks[0].y == GRID_HEIGHT - 2 && [self blockAtCoordinatesX:_liveBlocks[0].x y:_liveBlocks[0].y].hasDroppedHalfBlock) return;

		// Cannot swap if the block below the block on the right is populated
		if ([self blockAtCoordinatesX:_liveBlocks[1].x y:_liveBlocks[1].y + 1] != nil) return;

		// Cannot swap if the block 2 below the block on the right is populated
		// if we've dropped a half block
		if ([self blockAtCoordinatesX:_liveBlocks[1].x y:_liveBlocks[1].y].hasDroppedHalfBlock) {
			if ([self blockAtCoordinatesX:_liveBlocks[1].x y:_liveBlocks[1].y + 2] != nil) return;
		}

		// Perform the rotation

		// Move the left block down and right
		[self moveBlockFromSourceX:_liveBlocks[0].x sourceY:_liveBlocks[0].y toDestinationX:_liveBlocks[1].x destinationY:_liveBlocks[1].y + 1];

		// 0 block should always be at the top
		_liveBlocks[0].x = _liveBlocks[1].x;
		_liveBlocks[0].y = _liveBlocks[1].y;
		++_liveBlocks[1].y;

	} else {

		// Swapping to horizontal

		// Cannot swap if the blocks are at the left edge of the well
		if (_liveBlocks[0].x == 0) return;

		// Cannot swap if the block to the left of the block at the top is populated
		if ([self blockAtCoordinatesX:_liveBlocks[0].x - 1 y:_liveBlocks[0].y] != nil) return;

		// Cannot swap if the block below the block on the left of the top block
		// is populated if we've dropped a half block
		if ([self blockAtCoordinatesX:_liveBlocks[0].x y:_liveBlocks[0].y].hasDroppedHalfBlock) {
			if ([self blockAtCoordinatesX:_liveBlocks[0].x - 1 y:_liveBlocks[0].y + 1] != nil) return;
		}

		// Perform the rotation

		// Move the top block left
		[self moveBlockFromSourceX:_liveBlocks[0].x sourceY:_liveBlocks[0].y toDestinationX:_liveBlocks[0].x - 1 destinationY:_liveBlocks[0].y];
		--_liveBlocks[0].x;

		// Move the bottom block up
		[self moveBlockFromSourceX:_liveBlocks[1].x sourceY:_liveBlocks[1].y toDestinationX:_liveBlocks[1].x destinationY:_liveBlocks[1].y - 1];
		--_liveBlocks[1].y;
	}

	if (_onBlockRotate != nil) _onBlockRotate(self);
}

- (BOOL)addLiveBlocks:(BlockBase*)block1 block2:(BlockBase*)block2 {

	// Do not add more live blocks if we have blocks already.  However, return
	// true because we don't want to treat this as a special case; as far as
	// any other code is concerned it did its job - live blocks are in play
	if (_hasLiveBlocks) return YES;

	// Cannot add live blocks if the grid positions already contain blocks
	if ([self blockAtCoordinatesX:2 y:0] != nil) return NO;
	if ([self blockAtCoordinatesX:3 y:0] != nil) return NO;

	[block1 retain];
	[block2 retain];
	
	[block1 fall];
	[block2 fall];

	// Live blocks always appear at the same co-ordinates
	[self setBlockAtCoordinatesX:2 y:0 block:block1];
	[self setBlockAtCoordinatesX:3 y:0 block:block2];

	_liveBlocks[0].x = 2;
	_liveBlocks[0].y = 0;

	_liveBlocks[1].x = 3;
	_liveBlocks[1].y = 0;

	_hasLiveBlocks = YES;

	return YES;
}

- (void)connectBlocks {
	
	BlockBase* block = nil;
	
	for (int y = 0; y < GRID_HEIGHT; ++y) {
		for (int x = 0; x < GRID_WIDTH; ++x) {
			block = [self blockAtCoordinatesX:x y:y];
			
			if (block == nil) continue;
			
			[block connect:[self blockAtCoordinatesX:x y:y - 1]
					right:[self blockAtCoordinatesX:x + 1 y:y]
					bottom:[self blockAtCoordinatesX:x y:y + 1]
					left:[self blockAtCoordinatesX:x - 1 y:y]];
		}
	}
}

- (BOOL)animate {

	BOOL result = NO;

	for (int i = 0; i < GRID_WIDTH * GRID_HEIGHT; ++i) {
		
		if (_data[i] == nil) continue;
		
		if ([_data[i] isExploded]) {
			[_data[i] release];
			_data[i] = nil;
			result = YES;
		} else if (_data[i].isExploding) {
			result = YES;
		} else if (_data[i].isLanding) {
			result = YES;
		}

		if (_data[i] != nil) [_data[i] animate];
	}

	for (int i = 0; i < GRID_WIDTH; ++i) {
		if (_columnOffsets[i] > 0) {
			--_columnOffsets[i];
			result = YES;
		}
	}

	return result;
}

- (int)heightOfColumnAtIndex:(int)column {
	int height = 0;

	for (int y = GRID_HEIGHT - 1; y >= 0; --y) {
		
		// Ignore live blocks
		if (_hasLiveBlocks) {
			if (column == _liveBlocks[0].x && y == _liveBlocks[0].y) {
				break;
			}
			if (column == _liveBlocks[1].x && y == _liveBlocks[1].y) {
				break;
			}
		}
		
		if ([self blockAtCoordinatesX:column y:y] != nil) {
			++height;
		} else {
			break;
		}
	}

	return height;
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
			if (height < columnHeights[j]) {

				// Shuffle all items back one space to create a gap for the new
				// value
				for (int k = items; k > j; --k) {
					columnHeights[k] = columnHeights[k - 1];
					columns[k] = columns[k - 1];
				}
				break;
			}

			insertPoint++;
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
			while ([self blockAtCoordinatesX:columns[i] y:garbageY] != nil && garbageY < GRID_HEIGHT) {
				garbageY++;
			}

			// If we couldn't find a free block we'll try it in the next column
			// instead
			if (garbageY == GRID_HEIGHT) continue;

			[self setBlockAtCoordinatesX:columns[i] y:garbageY block:[[GarbageBlock alloc] init]];

			--count;

			if (count == 0) break;
		}

		// If we failed to place the block the grid must be full
		if (oldCount == count) return;

		++y;
	}
}

@end
