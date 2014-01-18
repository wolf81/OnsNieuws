//
//  Constants+Macros.h
//  Politiek
//
//  Created by Wolfgang Schreurs on 11/12/11.
//  Copyright (c) 2011 Sound of Data. All rights reserved.
//

#ifndef Politiek_Constants_Macros_h
#define Politiek_Constants_Macros_h


#define TIMEOUT_INTERVAL            10.0f
#define LIVE_STREAM_URL             @"http://download.omroep.nl/nos/iphone-live-streaming/p24/p24_Layer1.m3u8"
#define NEWS_DATE_FORMAT            @"EEE, d MMM yyyy HH:mm:ss Z"


#define NEWS_FEED_INTERIOR_URL      @"http://feeds.nos.nl/nosnieuwsbinnenland?format=xml"
#define NEWS_FEED_ABROAD_URL        @"http://feeds.nos.nl/nosnieuwsbuitenland?format=xml"
#define NEWS_FEED_POLITICS_URL      @"http://feeds.nos.nl/nosnieuwspolitiek?format=xml"
#define NEWS_FEED_ECONOMY_URL       @"http://feeds.nos.nl/economisch-nieuws?format=xml"
#define NEWS_FEED_SPORTS_URL        @"http://feeds.nos.nl/nossport?format=xml"
#define NEWS_FEED_ROYALTY_URL       @"http://feeds.nos.nl/nosnieuwskoningshuis?format=xml"
#define NEWS_FEED_HEADLINES_URL     @"http://feeds.nos.nl/nosmyheadlines?format=xml"
#define NEWS_FEED_NEWS_BULLETIN_URL @"http://feeds.nos.nl/nosjournaalvideo?format=xml"
#define HOST                        @"nos.nl"


#define FACEBOOK_APP_ID             @"303019633055392"

#ifdef DEBUG
#	define DLog(fmt, ...)         NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#	define DLog(...)              /* no logging  */
#endif /* DEBUG */


#endif /* Politiek_Constants_Macros_h */
