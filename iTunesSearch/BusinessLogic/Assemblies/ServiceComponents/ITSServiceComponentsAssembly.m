//
// Created by Farid on 07.05.17.
// Copyright (c) 2017 Farid. All rights reserved.
//

#import "ITSServiceComponentsAssembly.h"
#import "ITSITunesSearchService.h"
#import "ITSNetworkClient.h"
#import "ITSITunesSearchServiceConstants.h"
#import "ITSCoreDataStore.h"
#import "ITSITunesSearchServiceImplementation.h"


@implementation ITSServiceComponentsAssembly

- (id <ITSNetworking>)networkClient {
	ITSNetworkClient *networkClient = [[ITSNetworkClient alloc] initWithBaseUrl:[NSURL URLWithString:kITunesApiBaseUrl]];
	return networkClient;
}

- (ITSCoreDataStore *)coreDataStore {
	ITSCoreDataStore *coreDataStore = [[ITSCoreDataStore alloc] init];
	return coreDataStore;
}

- (id <ITSITunesSearchService>)iTunesSearchService {
	ITSITunesSearchServiceImplementation *searchService = [[ITSITunesSearchServiceImplementation alloc] initWithNetworkClient:self.networkClient
																														store:self.coreDataStore];
	return searchService;
}

@end