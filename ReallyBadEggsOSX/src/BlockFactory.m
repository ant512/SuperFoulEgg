#import "BlockFactory.h"
#import "RedBlock.h"
#import "BlueBlock.h"
#import "GreenBlock.h"
#import "YellowBlock.h"
#import "OrangeBlock.h"
#import "PurpleBlock.h"

@implementation BlockFactory

- (id)initWithPlayerCount:(int)playerCount blockColourCount:(int)blockColourCount {
	if ((self = [super init])) {
		_playerCount = playerCount;
		_blockColourCount = blockColourCount;
		
		_blockList = [[NSMutableArray alloc] init];
		_playerBlockListIndices = malloc(sizeof(int) * playerCount);
		
		[self clear];
	}
	
	return self;
}

- (void)dealloc {
	free(_playerBlockListIndices);
	
	[_blockList release];
	[super dealloc];
}

- (void)clear {
	for (int i = 0; i < _playerCount; ++i) {
		_playerBlockListIndices[i] = 0;
	}
	
	[_blockList removeAllObjects];
}

- (void)addRandomBlockClass {
	[_blockList addObject:[self randomBlockClass]];
}

- (void)expireUsedBlockClasses {
	int minimumBlock = INT_MAX;
	
	// Locate the earliest-used block in the list
	for (int i = 0; i < _playerCount; ++i) {
		if (_playerBlockListIndices[i] < minimumBlock) minimumBlock = _playerBlockListIndices[i];
	}
	
	// Reduce the indices of all players as we are going to trash everything
	// before the earliest-used block
	for (int i = 0; i < _playerCount; ++i) {
		_playerBlockListIndices[i] -= minimumBlock;
	}
	
	// Trash the unused blocks from the start of the array
	while (minimumBlock > 0) {
		[_blockList removeObjectAtIndex:0];
		--minimumBlock;
	}
}

- (Class)randomBlockClass {
	int type = rand() % _blockColourCount;

	switch (type) {
		case 0:
			return [RedBlock class];
		case 1:
			return [BlueBlock class];
		case 2:
			return [YellowBlock class];
		case 3:
			return [PurpleBlock class];
		case 4:
			return [GreenBlock class];
		case 5:
			return [OrangeBlock class];
	}
	
	// Included to silence compiler warning
	return [RedBlock class];
}

- (BlockBase*)newBlockForPlayerNumber:(int)playerNumber {
	int index = _playerBlockListIndices[playerNumber]++;

	// If the player is requesting a block past the end of the block list,
	// we need to append a new pair before we can return it
	if (index == [_blockList count]) {
		[self addRandomBlockClass];
	}

	// Initialise a new block instance from the class at the current blocklist
	// index that this player is using
	BlockBase* block = [[[_blockList objectAtIndex:index] alloc] init];

	// We can try to expire any old blocks in the list now
	[self expireUsedBlockClasses];

	return block;
}

@end
