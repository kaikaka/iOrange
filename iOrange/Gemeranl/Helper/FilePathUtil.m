//
//  FilePathUtil.m
//  DailyHeadlines
//
//  Created by David on 2011-12-19.
//  Copyright 2011年 com.veryapps. All rights reserved.
//

#import "FilePathUtil.h"
#import "NSStringEx.h"
#import "Common.h"

// 单个文件的大小
long long FileSizeAtPath(NSString *filePath) {
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]) {
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    
    return 0;
}

// 遍历文件夹获得文件夹大小，返回单位M
float FolderSizeAtPath(NSString *folderPath) {
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString *fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil) {
        NSString *fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += FileSizeAtPath(fileAbsolutePath);
    }
    
    return folderSize/(1024.0*1024.0);
}

NSString* GetDocumentDir() {
    NSArray *filePaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [filePaths objectAtIndex:0];
}

void CreateDirAtPath(NSString *dirPath) {
	NSFileManager *fileManage = [NSFileManager defaultManager];
	if (![fileManage fileExistsAtPath:dirPath]) {
		[fileManage createDirectoryAtPath:dirPath
              withIntermediateDirectories:YES
                               attributes:nil
                                    error:nil];
	}
}

NSString *GetDocumentDirAppend(NSString* dirName) {
    NSString *dirPath = [GetDocumentDir() stringByAppendingPathComponent:dirName];
    CreateDirAtPath(dirPath);
    
	return dirPath;
}

NSString *GetDBPathWithName(NSString *name) {
    return [GetDocumentDir() stringByAppendingPathComponent:name];
}

NSString * GetDBPath() {
    return GetDBPathWithName(DB_NAME);
}

NSString *GetCacheDir(){
    NSArray *filePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *dirPath = [filePaths objectAtIndex:0];

	return dirPath;
}

NSString *GetCacheImageDir() {
    NSString *dirPath = [GetCacheDir() stringByAppendingPathComponent:@"images"];
    CreateDirAtPath(dirPath);
    
	return dirPath;
}

NSString *GetCacheDataDir() {
    NSString *dirPath = [GetCacheDir() stringByAppendingPathComponent:@"data"];
    CreateDirAtPath(dirPath);
	
    return dirPath;
}

NSString *GetCacheDirAppend(NSString* dirName){
    NSString *dirPath = [GetCacheDir() stringByAppendingPathComponent:dirName];
    CreateDirAtPath(dirPath);
    
	return dirPath;
}
