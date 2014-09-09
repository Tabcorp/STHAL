//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
//  Copyright (c) 2014 Scott Talbot.

#import <STHAL/STHALResource.h>

#import "STHALTypeSafety.h"
#import "STHALLinks.h"
#import "STHALEmbeddedResources.h"


@implementation STHALResource {
@private
    STHALLinks *_links;
    NSDictionary *_payload;
    STHALEmbeddedResources *_embedded;
}

- (id)init {
    return [self initWithDictionary:nil baseURL:nil options:0];
}
- (id)initWithDictionary:(NSDictionary *)dict baseURL:(NSURL *)baseURL {
    return [self initWithDictionary:dict baseURL:baseURL options:0];
}
- (id)initWithDictionary:(NSDictionary *)dict baseURL:(NSURL *)baseURL options:(STHALResourceReadingOptions)options {
    NSParameterAssert(dict);
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return nil;
    }

    if ((self = [super init])) {
        NSMutableDictionary * const payload = [[NSMutableDictionary alloc] initWithDictionary:dict];

        NSDictionary * const linksDictionary = STHALEnsureNSDictionary(payload[@"_links"]);
        if (linksDictionary) {
            if ((_links = [[STHALLinks alloc] initWithDictionary:linksDictionary baseURL:baseURL options:options])) {
                [payload removeObjectForKey:@"_links"];
            }
        }

        NSDictionary * const embeddedResourceDictionary = STHALEnsureNSDictionary(payload[@"_embedded"]);
        if (embeddedResourceDictionary) {
            if ((_embedded = [[STHALEmbeddedResources alloc] initWithDictionary:embeddedResourceDictionary baseURL:baseURL options:options])) {
                [payload removeObjectForKey:@"_embedded"];
            }
        }

        _payload = payload.copy;
    }
    return self;
}


@synthesize links = _links;
@synthesize payload = _payload;
@synthesize embeddedResources = _embedded;

@end
