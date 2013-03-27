//
//  UIImage+LHAES256.m
//  LevelHelper API
//
//  Created by Rabih on 7/5/11.
//  Modified by Vladu Bogdan for LevelHelper usage
//

#import "UIImage+LHAES256.h"
#import "NSData+LHAES256.h"


@implementation UIImage (AES256)

+ (UIImage *)imageWithContentsOfEncryptedFile:(NSString *)path withKey:(NSData *)key {
    return [[[self alloc] initWithContentsOfEncryptedFile:path withKey:key] autorelease];
}

- (id)initWithContentsOfEncryptedFile:(NSString *)path withKey:(NSData *)key {
    NSData *data = [[NSData alloc] initWithContentsOfEncryptedFile:path withKey:key];
    if (!data) {
        [self release];
        return nil;
    }
    self = [self initWithData:data];
    [data release];
    return self;
}

@end
