//
//  NetworkResult.swift
//  Done
////
////  Created by 안현정 on 2022/03/06.
////
//
import Foundation

enum NetworkResult<T> {
    case success(T)
    case requestErr(T)
    case pathErr
    case serverErr
    case networkFail
}
