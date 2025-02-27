//
//  TXChorusIMJsonHandle.m
//  TUIChorus
//
//  Created by adams on 2021/7/15.
//

#import "TXChorusIMJsonHandle.h"
#import <MJExtension/MJExtension.h>

@implementation TXChorusIMJsonHandle
+ (NSDictionary<NSString *, NSString *> *)getInitRoomDicWithRoomInfo:(TXChorusRoomInfo *)roominfo seatInfoList:(NSArray<TXChorusSeatInfo *> *)seatInfoList {
    NSMutableDictionary *result = [[NSMutableDictionary alloc] initWithCapacity:2];
    [result setValue:[NSString stringWithFormat:@"%ld.0",(long)CHORUS_VALUE_VERSION] forKey:CHORUS_KEY_VERSION];
    NSString *jsonRoomInfo = [roominfo mj_JSONString];
    [result setValue:jsonRoomInfo forKey:CHORUS_KEY_ROOM_INFO];
    
    for (int index = 0; index < seatInfoList.count; index += 1) {
        NSString *jsonInfo = [seatInfoList[index] mj_JSONString];
        NSString *key = [NSString stringWithFormat:@"%@%d", CHORUS_KEY_SEAT, index];
        [result setValue:jsonInfo forKey:key];
    }
    return result;
}

+ (NSString *)getRoomdestroyMsg {
    NSMutableDictionary *result = [[NSMutableDictionary alloc] initWithCapacity:2];
    [result setValue:[NSString stringWithFormat:@"%ld.0",CHORUS_VALUE_VERSION] forKey:CHORUS_KEY_VERSION];
    [result setValue:@(kChorusCodeDestroy) forKey:CHORUS_KEY_ACTION];
    return [result mj_JSONString];
}

+ (TXChorusRoomInfo * _Nullable)getRoomInfoFromAttr:(NSDictionary<NSString *, NSString *> *)attr {
    NSString *jsonStr = [attr objectForKey:CHORUS_KEY_ROOM_INFO];
    return [TXChorusRoomInfo mj_objectWithKeyValues:jsonStr];
}


+ (NSArray<TXChorusSeatInfo *> * _Nullable)getSeatListFromAttr:(NSDictionary<NSString *, NSString *> *)attr seatSize:(NSUInteger)seatSize {
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:2];
    for (int index = 0; index < seatSize; index += 1) {
        NSString *key = [NSString stringWithFormat:@"%@%d", CHORUS_KEY_SEAT, index];
        NSString *jsonStr = [attr objectForKey:key];
        if (jsonStr) {
            TXChorusSeatInfo *seatInfo = [TXChorusSeatInfo mj_objectWithKeyValues:jsonStr];
            [result addObject:seatInfo];
        } else {
            TXChorusSeatInfo *seatInfo = [[TXChorusSeatInfo alloc] init];
            [result addObject:seatInfo];
        }
    }
    return result;
}

+ (NSDictionary<NSString *, NSString *> *)getSeatInfoJsonStrWithIndex:(NSInteger)index info:(TXChorusSeatInfo *)info {
    NSMutableDictionary *result = [[NSMutableDictionary alloc] initWithCapacity:2];
    NSString *json = [info mj_JSONString];
    NSString *key = [NSString stringWithFormat:@"%@%ld", CHORUS_KEY_SEAT, (long)index];
    [result setValue:json forKey:key];
    return result;
}

+ (NSString *)getCusMsgJsonStrWithCmd:(NSString *)cmd msg:(NSString *)msg {
    NSMutableDictionary *result = [[NSMutableDictionary alloc] initWithCapacity:2];
    [result setValue:[NSString stringWithFormat:@"%ld.0",CHORUS_VALUE_VERSION] forKey:CHORUS_KEY_VERSION];
    [result setValue:@(kChorusCodeCustomMsg) forKey:CHORUS_KEY_ACTION];
    [result setValue:cmd forKey:CHORUS_KEY_INVITATION_CMD];
    [result setValue:msg forKey:CHORUS_KEY_MESSAGE];
    return [result mj_JSONString];
}

+ (NSDictionary<NSString *,NSString *> *)parseCusMsgWithJsonDic:(NSDictionary *)jsonDic {
    NSMutableDictionary *result = [[NSMutableDictionary alloc] initWithCapacity:2];
    result[CHORUS_KEY_CMD] = [jsonDic objectForKey:CHORUS_KEY_INVITATION_CMD] ?: @"";
    result[CHORUS_KEY_MESSAGE] = [jsonDic objectForKey:CHORUS_KEY_MESSAGE] ?: @"";
    return result;
}

@end
