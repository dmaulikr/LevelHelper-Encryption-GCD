//
//  NSData+LHAES256.h
//  LevelHelper API
//
//  Created by Rabih on 7/5/11.
//  Modified by Vladu Bogdan for LevelHelper usage
//

#import <Foundation/Foundation.h>


@interface NSData (LHAES256)

- (NSData*)encryptedWithKey:(NSData*)key;
- (NSData*)decryptedWithKey:(NSData*)key;

+ (id)dataWithContentsOfEncryptedFile:(NSString *)path withKey:(NSData *)key;
- (id)initWithContentsOfEncryptedFile:(NSString *)path withKey:(NSData *)key;

@end