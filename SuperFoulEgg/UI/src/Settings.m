#import "Settings.h"

@implementation Settings

@synthesize aiType = _aiType;
@synthesize gameType = _gameType;
@synthesize height = _height;
@synthesize speed = _speed;
@synthesize gamesPerMatch = _gamesPerMatch;
@synthesize blockColours = _blockColours;

@synthesize keyCodeOneLeft = _keyCodeOneLeft;
@synthesize keyCodeOneRight = _keyCodeOneRight;
@synthesize keyCodeOneUp = _keyCodeOneUp;
@synthesize keyCodeOneDown = _keyCodeOneDown;
@synthesize keyCodeOneA = _keyCodeOneA;
@synthesize keyCodeOneB = _keyCodeOneB;
@synthesize keyCodeOneStart = _keyCodeOneStart;

@synthesize keyCodeTwoLeft = _keyCodeTwoLeft;
@synthesize keyCodeTwoRight = _keyCodeTwoRight;
@synthesize keyCodeTwoUp = _keyCodeTwoUp;
@synthesize keyCodeTwoDown = _keyCodeTwoDown;
@synthesize keyCodeTwoA = _keyCodeTwoA;
@synthesize keyCodeTwoB = _keyCodeTwoB;
@synthesize keyCodeTwoStart = _keyCodeTwoStart;

@synthesize keyCodeQuit = _keyCodeQuit;

+ (Settings*)sharedSettings {
	static Settings* _sharedSettings;

	@synchronized(self) {
		if (!_sharedSettings) _sharedSettings = [[Settings alloc] init];

		return _sharedSettings;
	}
}

- (id)init {
	if ((self = [super init])) {
		_aiType = AIHardType;
		_gameType = GameSinglePlayerType;
		_height = 0;
		_speed = 0;
		_gamesPerMatch = 3;
		_blockColours = 4;

		_keyCodeOneLeft = DEFAULT_KEY_CODE_ONE_LEFT;
		_keyCodeOneRight = DEFAULT_KEY_CODE_ONE_RIGHT;
		_keyCodeOneUp = DEFAULT_KEY_CODE_ONE_UP;
		_keyCodeOneDown = DEFAULT_KEY_CODE_ONE_DOWN;
		_keyCodeOneA = DEFAULT_KEY_CODE_ONE_A;
		_keyCodeOneB = DEFAULT_KEY_CODE_ONE_B;
		_keyCodeOneStart = DEFAULT_KEY_CODE_ONE_START;
		
		_keyCodeTwoLeft = DEFAULT_KEY_CODE_TWO_LEFT;
		_keyCodeTwoRight = DEFAULT_KEY_CODE_TWO_RIGHT;
		_keyCodeTwoUp = DEFAULT_KEY_CODE_TWO_UP;
		_keyCodeTwoDown = DEFAULT_KEY_CODE_TWO_DOWN;
		_keyCodeTwoA = DEFAULT_KEY_CODE_TWO_A;
		_keyCodeTwoB = DEFAULT_KEY_CODE_TWO_B;
		_keyCodeTwoStart = DEFAULT_KEY_CODE_TWO_START;
		
		_keyCodeQuit = DEFAULT_KEY_CODE_QUIT;
	}
	return self;
}

@end
