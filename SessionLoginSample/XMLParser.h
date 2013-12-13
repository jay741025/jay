//
//  RSSParser.h
//  RSSReader
//
//  Created by Eric Lin on 11/10/11.
//  Copyright (c) 2011年 EraSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

// 用來定義標籤的自定義變數
// tagTitle = <title>
// tagLink = <link>
// tagDescription = <description>
// tagUnknown = 未知,不處理
typedef enum {uid,name,lat,lon,Unknown} XMLTag;

@interface XMLParser : NSObject <NSXMLParserDelegate> {
    // 存放每筆新聞資料
    NSMutableDictionary *item;
    // 目前正在解析的標籤
    XMLTag currentTag;
    // 是否開始解析
    BOOL startItem;
}
// 解析後所有的新聞
@property(nonatomic,retain) NSMutableArray *result;
- (id) initWithData:(NSData *) data;
@end
