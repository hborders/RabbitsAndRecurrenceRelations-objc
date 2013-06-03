//
//  main.m
//  RabbitsAndRecurrenceRelations
//
//  Created by Heath Borders on 6/2/13.
//  Copyright (c) 2013 Heath Borders. All rights reserved.
//

#import <Foundation/Foundation.h>

NSRange const GenerationCountRange = {.location=1, .length=40};
NSRange const LitterSizeRange = {.location=1, .length=5};

typedef NS_ENUM(int, RARRErrorCodes) {
    RARRErrorCodesValid,
    RARRErrorCodesInvalid,
    RARRErrorCodesGenerations,
    RARRErrorCodesLitterSize,
};

NSUInteger unsignedIntegerFromASCIICString(const char * ASCIICString) {
    return (NSUInteger) [[[NSString alloc] initWithCString:ASCIICString
                                                  encoding:NSASCIIStringEncoding] integerValue];
}

void printUsage() {
    NSLog(@"Usage: RabbitsAndRecurrenceRelations <generationCount [%@,%@]> <litterSize [%@,%@]>",
          @(GenerationCountRange.location),
          @(NSMaxRange(GenerationCountRange) - 1),
          @(LitterSizeRange.location),
          @(NSMaxRange(LitterSizeRange) - 1)
          );
}

@interface Generation : NSObject

@property (nonatomic, readonly) NSUInteger size;

- (id)initWithMatureCount:(NSUInteger)matureCount
               youngCount:(NSUInteger)youngCount
               litterSize:(NSUInteger)litterSize;

- (instancetype)nextGeneration;

+ (instancetype)firstGenerationWithLitterSize:(NSUInteger)litterSize;

@end

int main(int argc, const char * argv[])
{
    int returnVal;
    @autoreleasepool {
        if (argc == 3) {
            NSUInteger generationCount = unsignedIntegerFromASCIICString(argv[1]);
            if (NSLocationInRange(generationCount, GenerationCountRange)) {
                NSUInteger litterSize = unsignedIntegerFromASCIICString(argv[2]);
                if (NSLocationInRange(litterSize, LitterSizeRange)) {
                    Generation *generation = [Generation firstGenerationWithLitterSize:litterSize];
                    for (NSUInteger nextGenerationIndex = 1; nextGenerationIndex < generationCount; nextGenerationIndex++) {
                        generation = [generation nextGeneration];
                    }
                    
                    printf("%s\n", [[@(generation.size) stringValue] cStringUsingEncoding:NSASCIIStringEncoding]);
                    returnVal = RARRErrorCodesValid;
                } else {
                    returnVal = RARRErrorCodesLitterSize;
                }
            } else {
                returnVal = RARRErrorCodesGenerations;
            }
        } else {
            returnVal = RARRErrorCodesInvalid;
        }
    }
    
    if (returnVal != RARRErrorCodesValid) {
        printUsage();
    }
    
    return returnVal;
}

@interface Generation ()

@property (nonatomic) NSUInteger matureCount;
@property (nonatomic) NSUInteger youngCount;
@property (nonatomic) NSUInteger litterSize;

@end

@implementation Generation

- (id)initWithMatureCount:(NSUInteger)matureCount
               youngCount:(NSUInteger)youngCount
               litterSize:(NSUInteger)litterSize {
    self = [super init];
    if (self) {
        self.matureCount = matureCount;
        self.youngCount = youngCount;
        self.litterSize = litterSize;
    }
    
    return self;
}

- (NSUInteger)size {
    return self.matureCount + self.youngCount;
}

- (instancetype)nextGeneration {
    Generation *nextGeneration = [[[self class] alloc] initWithMatureCount:self.matureCount + self.youngCount
                                                                youngCount:self.matureCount * self.litterSize
                                                                litterSize:self.litterSize];
    return nextGeneration;
}

+ (instancetype)firstGenerationWithLitterSize:(NSUInteger)litterSize {
    return [[self alloc] initWithMatureCount:0
                                  youngCount:1
                                  litterSize:litterSize];
}

@end

