#import <Foundation/Foundation.h>

#define DEFAULT_KEY_CODE_ONE_LEFT 0x64
#define DEFAULT_KEY_CODE_ONE_RIGHT 0x67
#define DEFAULT_KEY_CODE_ONE_UP 0x72
#define DEFAULT_KEY_CODE_ONE_DOWN 0x66
#define DEFAULT_KEY_CODE_ONE_A 0x73
#define DEFAULT_KEY_CODE_ONE_B 0x61
#define DEFAULT_KEY_CODE_ONE_START 0x20

#define DEFAULT_KEY_CODE_TWO_LEFT 0xF702
#define DEFAULT_KEY_CODE_TWO_RIGHT 0xF703
#define DEFAULT_KEY_CODE_TWO_UP 0xF700
#define DEFAULT_KEY_CODE_TWO_DOWN 0xF701
#define DEFAULT_KEY_CODE_TWO_A 0x2E
#define DEFAULT_KEY_CODE_TWO_B 0x2C
#define DEFAULT_KEY_CODE_TWO_START 0x0D

#define DEFAULT_KEY_CODE_QUIT 0x1B

typedef enum {
	AIInsaneType = 0,
	AIHardType = 2,
	AIMediumType = 3,
	AIEasyType = 6
} AIType;

typedef enum {
	GamePracticeType = 0,
	GameSinglePlayerType = 1,
	GameTwoPlayerType = 2,
} GameType;

@interface Settings : NSObject {
	AIType _aiType;
	GameType _gameType;
	int _height;
	int _speed;
	int _gamesPerMatch;
	int _blockColours;
	
	unichar _keyCodeOneLeft;
	unichar _keyCodeOneRight;
	unichar _keyCodeOneUp;
	unichar _keyCodeOneDown;
	unichar _keyCodeOneA;
	unichar _keyCodeOneB;
	unichar _keyCodeOneStart;
	
	unichar _keyCodeTwoLeft;
	unichar _keyCodeTwoRight;
	unichar _keyCodeTwoUp;
	unichar _keyCodeTwoDown;
	unichar _keyCodeTwoA;
	unichar _keyCodeTwoB;
	unichar _keyCodeTwoStart;
	
	unichar _keyCodeQuit;
}

@property(readwrite) AIType aiType;
@property(readwrite) GameType gameType;
@property(readwrite) int height;
@property(readwrite) int speed;
@property(readwrite) int gamesPerMatch;
@property(readwrite) int blockColours;

@property(readwrite) unichar keyCodeOneLeft;
@property(readwrite) unichar keyCodeOneRight;
@property(readwrite) unichar keyCodeOneUp;
@property(readwrite) unichar keyCodeOneDown;
@property(readwrite) unichar keyCodeOneA;
@property(readwrite) unichar keyCodeOneB;
@property(readwrite) unichar keyCodeOneStart;

@property(readwrite) unichar keyCodeTwoLeft;
@property(readwrite) unichar keyCodeTwoRight;
@property(readwrite) unichar keyCodeTwoUp;
@property(readwrite) unichar keyCodeTwoDown;
@property(readwrite) unichar keyCodeTwoA;
@property(readwrite) unichar keyCodeTwoB;
@property(readwrite) unichar keyCodeTwoStart;

@property(readwrite) unichar keyCodeQuit;

+ (Settings*)sharedSettings;
- (id)init;

@end
