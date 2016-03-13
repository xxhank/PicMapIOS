//
//  Either.swift
//  PicMapIOS
//
//  Created by wangchaojs02 on 16/2/1.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//

import Foundation

enum Either<T1, T2> {
    case Left(T1)
    case Right(T2)
}

enum Response<T1> {
    case Result(T1)
    case Error(NSError)
}

enum ViewModel < T1 > {
    case Result(T1)
    case Error(NSError)
}

extension ErrorType {
    func toViewModel<T>(localizedDescription: String? = nil,
        underlyingError: NSError? = nil,
        extraInformation: [NSObject : AnyObject]? = nil) -> ViewModel<T> {
            return ViewModel.Error(self.toNSError(localizedDescription,
                underlyingError: underlyingError,
                extraInformation: extraInformation))
        }

    func toResponse<T>(localizedDescription: String? = nil,
        underlyingError: NSError? = nil,
        extraInformation: [NSObject : AnyObject]? = nil) -> Response<T> {
            return Response.Error(self.toNSError(localizedDescription,
                underlyingError: underlyingError,
                extraInformation: extraInformation))
        }
}