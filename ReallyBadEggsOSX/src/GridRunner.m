#import "GridRunner.h"

@implementation GridRunner

@synthesize outgoingGarbageCount = _outgoingGarbageCount;
@synthesize incomingGarbageCount = _incomingGarbageCount;
@synthesize score = _score;
@synthesize chains = _chains;
@synthesize playerNumber = _playerNumber;
@synthesize grid = _grid;

@synthesize controller = _controller;

@synthesize onLiveBlockMove = _onLiveBlockMove;
@synthesize onLiveBlockRotate = _onLiveBlockRotate;
@synthesize onLiveBlockDropStart = _onLiveBlockDropStart;
@synthesize onLiveBlockAdd = _onLiveBlockAdd;

- (id)initWithController:(id <ControllerProtocol>)controller
					grid:(Grid*)grid
					blockFactory:(BlockFactory*)blockFactory
					playerNumber:(int)playerNumber
					gameType:(GameType)gameType
					speed:(int)speed {

	if ((self = [super init])) {
		_state = GridRunnerDropState;
		_timer = 0;
		_controller = controller;
		_grid = grid;
		_blockFactory = blockFactory;
		_playerNumber = playerNumber;
		_gameType = gameType;

		_score = 0;
		_speed = speed;
		_chains = 0;
		_scoreMultiplier = 0;
		_outgoingGarbageCount = 0;
		_incomingGarbageCount = 0;
		_accumulatingGarbageCount = 0;

		_droppingLiveBlocks = NO;

		// Ensure we have some initial blocks to add to the grid
		for (int i = 0; i < LIVE_BLOCK_COUNT; ++i) {
			_nextBlocks[i] = [_blockFactory newBlockForGrid:_grid];
		}
	}
	
	return self;
}

- (void)dealloc {
	for (int i = 0; i < LIVE_BLOCK_COUNT; ++i) {
		[_nextBlocks[i] release];
	}
	[super dealloc];
}

- (void)drop {

	// Blocks are dropping down the screen automatically

	if (_timer < AUTO_DROP_TIME) return;

	_timer = 0;

	if (![_grid dropBlocks]) {

		// Blocks have stopped dropping, so we need to run the landing
		// animations
		_state = GridRunnerLandingState;
	}
}

- (void)land {

	// All animations have finished, so establish connections between blocks now
	// that they have landed
	[_grid connectBlocks];

	int score = 0;
	int chains = 0;
	int blocks = 0;

	// Attempt to explode any chains that exist in the grid
	if ([_grid explodeChains:&score chainCount:&chains blocks:&blocks]) {

		//SoundPlayer::playChain(_playerNumber, _scoreMultiplier);
		
		++_scoreMultiplier;
		_score += score * _scoreMultiplier;

		_chains += chains;

		if (_gameType == GameTypeTwoPlayer) {
			int garbage = 0;

			if (_scoreMultiplier == 1) {

				// One block for the chain and one block for each block on
				// top of the required minimum number
				garbage = blocks - (CHAIN_LENGTH - 1);
			} else {

				// If we're in a sequence of chains, we add 6 blocks each
				// sequence
				garbage = CHAIN_SEQUENCE_GARBAGE_BONUS;

				// Add any additional blocks on top of the standard
				// chain length
				garbage += blocks - CHAIN_LENGTH;
			}

			_accumulatingGarbageCount += garbage;
		}

		// TODO: Render all score/chain/level displays here
		
		// We need to run the explosion animations next
		_state = GridRunnerExplodingState;

	} else if (_incomingGarbageCount > 0) {

		// Add any incoming garbage blocks
		[_grid addGarbage:_incomingGarbageCount];

		// Switch back to the drop state
		_state = GridRunnerDropState;

		_incomingGarbageCount = 0;
		//renderIncomingGarbage();
	} else {

		// Nothing exploded, so we can put a new live block into
		// the grid
		BOOL addedBlocks = [_grid addLiveBlocks:_nextBlocks[0] block2:_nextBlocks[1]];

		[_nextBlocks[0] release];
		[_nextBlocks[1] release];

		_nextBlocks[0] = nil;
		_nextBlocks[1] = nil;

		if (!addedBlocks) {

			// Cannot add more blocks - game is over
			_state = GridRunnerDeadState;
		} else {

			// Fetch the next blocks from the block factory and remember
			// them
			for (int i = 0; i < LIVE_BLOCK_COUNT; ++i) {
				_nextBlocks[i] = [_blockFactory newBlockForGrid:_grid];
			}

			//renderNextBlocks();

			//if (_scoreMultiplier > 1) SoundPlayer::playMultichain(_playerNumber);

			_scoreMultiplier = 0;

			// Queue up outgoing blocks for the other player
			_outgoingGarbageCount += _accumulatingGarbageCount;
			_accumulatingGarbageCount = 0;

			if (_onLiveBlockAdd != nil) _onLiveBlockAdd(self);

			_state = GridRunnerLiveState;
		}
	}
}

- (void)live {

	// Player-controllable blocks are in the grid

	if ([_grid hasLiveBlocks]) {

		// Work out how many frames we need to wait until the blocks drop
		// automatically
		int timeToDrop = MINIMUM_DROP_SPEED - (DROP_SPEED_MULTIPLIER * _speed);

		if (timeToDrop < MAXIMUM_DROP_SPEED) timeToDrop = MAXIMUM_DROP_SPEED;

		// Process user input
		if ([_controller isLeftHeld]) {
			if ([_grid moveLiveBlocksLeft]) {
				if (_onLiveBlockMove != nil) _onLiveBlockMove(self);
            }
		} else if ([_controller isRightHeld]) {
			if ([_grid moveLiveBlocksRight]) {
				if (_onLiveBlockMove != nil) _onLiveBlockMove(self);
			}
		}

		if ([_controller isDownHeld] && (_timer % 2 == 0)) {

			// Force blocks to drop
			_timer = timeToDrop;

			if (!_droppingLiveBlocks) {
				_droppingLiveBlocks = true;

				if (_onLiveBlockDropStart != nil) _onLiveBlockDropStart(self);
			}
		} else if (![_controller isDownHeld]) {
			_droppingLiveBlocks = false;
		}
		
		if ([_controller isRotateClockwiseHeld]) {
			if ([_grid rotateLiveBlocksClockwise]) {
				if (_onLiveBlockRotate != nil) _onLiveBlockRotate(self);
			}
		} else if ([_controller isRotateAntiClockwiseHeld]) {
			if ([_grid rotateLiveBlocksAntiClockwise]) {
				if (_onLiveBlockRotate != nil) _onLiveBlockRotate(self);
			}
		}

		// Drop live blocks if the timer has expired
		if (_timer >= timeToDrop) {
			_timer = 0;
			[_grid dropLiveBlocks];
		}
	} else {

		// At least one of the blocks in the live pair has touched down.
		// We need to drop the other block automatically
		_droppingLiveBlocks = false;
		_state = GridRunnerDropState;
	}
}

- (void)iterate {

	// Returns true if any blocks have an animation still in progress
	BOOL animated = [_grid animate];

	++_timer;

	switch (_state) {
		case GridRunnerDropState:
			[self drop];
			break;
		
		case GridRunnerLandingState:
			
			// Wait until animations stop
			if (!animated) {
				[self land];
			}

			break;

		case GridRunnerExplodingState:

			// Wait until animations stop
			if (!animated) {

				// All animations have finished - we need to drop any blocks
				// that are now sat on holes in the grid
				_state = GridRunnerDropState;
			}

			break;

		case GridRunnerLiveState:
			[self live];
			break;	

		case GridRunnerDeadState:
			break;
	}
}

- (BOOL)addIncomingGarbage:(int)count {
	if (![self canReceiveGarbage]) return NO;
	if (count < 1) return NO;

	_incomingGarbageCount += count;

	//renderIncomingGarbage();

	return YES;
}

- (void)clearOutgoingGarbageCount {
	_outgoingGarbageCount = 0;
}

- (BOOL)canReceiveGarbage {
	return _state == GridRunnerLiveState;
}

- (BOOL)isDead {
	return _state == GridRunnerDeadState;
}

@end
