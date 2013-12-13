//
//  RSSParser.m
//  RSSReader
//
//  Created by Eric Lin on 11/10/11.
//  Copyright (c) 2011年 EraSoft. All rights reserved.
//

#import "XMLParser.h"

@implementation XMLParser
@synthesize result;

// 建構子
- (id) initWithData:(NSData *) data {
	if( (self = [super init]) ){
        // 初始化用來儲存結果的陣列
        self.result = [[NSMutableArray alloc] init];
        // 初始化 NSXMLParser
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
        parser.delegate = self;
        // 開始解析
        [parser parse];
        return self;
    }
    return self;
}

#pragma mark - NSXMLParserDelegate

// 找到某個標籤的開始
-(void) parser:(NSXMLParser *) parser didStartElement:(NSString *) elementName 
        namespaceURI:(NSString *) namespaceURI 
        qualifiedName:(NSString *) qName 
        attributes:(NSDictionary *) attributeDict{
        
        // 設定目前在解析的標籤
        // <item>
        //   <title></title>
        //   <link></link>
        //   <description></description>
        // </item>
    
        if( [elementName isEqualToString:@"user"] ){
            startItem = YES;
             item = [NSMutableDictionary new];
        }
        // 發現 item 後才開始解析
        if (startItem) {
            if( [elementName isEqualToString:@"uid"] ){
                currentTag = uid;
            }else if( [elementName isEqualToString:@"name"] ){
                currentTag = name;
            }else if( [elementName isEqualToString:@"lat"] ){
                currentTag = lat;
            }else if( [elementName isEqualToString:@"lon"] ){
                currentTag = lon;
            }
            else{
                currentTag = Unknown;
            }
        }
}

//  找到某個標籤的結尾
-(void) parser:(NSXMLParser *) parser didEndElement:(NSString *) elementName 
  namespaceURI:(NSString *) namespaceURI 
 qualifiedName:(NSString  *) qName{
    if ( [elementName isEqualToString:@"user"] ) {
        NSDictionary *parsedItem = [[NSDictionary alloc] initWithDictionary:item];
        [self.result addObject:parsedItem];
        // 釋放目前解析的資料
        item = nil;
        startItem = NO;
    }
}

// XML 的內文
-(void) parser:(NSXMLParser *) parser foundCharacters:(NSString *) string {
		// 將空白字元去除
		NSString *value = [string stringByTrimmingCharactersInSet:[NSCharacterSet 
                                                          whitespaceAndNewlineCharacterSet]];
		// 若沒有任何內容則不處理
		if( [value length]==0 || currentTag==Unknown){
			return;
		}
        
        // 比對目前正在解析的標籤，並儲存該標籤內的文字於 item 內
        switch (currentTag) {
            case uid:
                [item setValue:value forKey:@"uid"];
                break;
            case name:
                [item setValue:value forKey:@"name"];
                break;
            case lat:
                [item setValue:value forKey:@"lat"];
                break;
            case lon:
                [item setValue:value forKey:@"lon"];
                break;
            default:
                break;
        }
}
@end
