//
//  NSDictionary+LHAES256.m
//  LevelHelper API
//
//  Created by Rabih on 7/5/11.
//  Modified by Vladu Bogdan for LevelHelper usage
//

#import "NSDictionary+LHAES256.h"
#import "NSData+LHAES256.h"

@implementation NSDictionary (AES256)

+ (id)dictionaryWithContentsOfEncryptedFile:(NSString *)path withKey:(NSData *)key {
    return [[[self alloc] initWithContentsOfEncryptedFile:path withKey:key] autorelease];
}

- (id)initWithContentsOfEncryptedFile:(NSString *)path withKey:(NSData *)key {
    [self release];
    self = nil;
    
    NSData *data = [[NSData alloc] initWithContentsOfEncryptedFile:path withKey:key];
    if (!data) 
        return nil;
    
    id plist = nil;
    if ([NSPropertyListSerialization resolveClassMethod:@selector(propertyListWithData:options:format:error:)]) 
        plist = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:NULL error:NULL];
    else
        plist = [NSPropertyListSerialization propertyListFromData:data mutabilityOption:0 format:NULL errorDescription:NULL];
    [data release];
    
    if (plist && [plist isKindOfClass:[NSDictionary class]]) 
        self = [plist retain];
    
    return self;
}

@end
