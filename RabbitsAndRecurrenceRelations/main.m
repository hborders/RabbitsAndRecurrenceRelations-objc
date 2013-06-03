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

typedef struct Generation {
    NSUInteger matureCount;
    NSUInteger youngCount;
} Generation;

Generation nextGenerationWithGenerationAndLitterSize(Generation generation, NSUInteger litterSize) {
    Generation nextGeneration = {
        .matureCount = generation.matureCount + generation.youngCount,
        .youngCount = generation.matureCount * litterSize,
    };
    return nextGeneration;
}

int main(int argc, const char * argv[])
{
    int returnVal;
    @autoreleasepool {
        if (argc == 3) {
            NSUInteger generationCount = unsignedIntegerFromASCIICString(argv[1]);
            if (NSLocationInRange(generationCount, GenerationCountRange)) {
                NSUInteger litterSize = unsignedIntegerFromASCIICString(argv[2]);
                if (NSLocationInRange(litterSize, LitterSizeRange)) {
                    Generation generation = {
                        .matureCount = 0,
                        .youngCount = 1,
                    };
                    for (NSUInteger nextGenerationIndex = 1; nextGenerationIndex < generationCount; nextGenerationIndex++) {
                        generation = nextGenerationWithGenerationAndLitterSize(generation,
                                                                               litterSize);
                    }
                    
                    printf("%s\n", [[@(generation.matureCount + generation.youngCount) stringValue] cStringUsingEncoding:NSASCIIStringEncoding]);
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

