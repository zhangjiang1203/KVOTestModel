//
//  JSONDecoderImpl+SingleValueContainer.swift
//  SmartCodable
//
//  Created by qixin on 2024/5/17.
//

import Foundation

/** 进入Single的场景
 单容器的解析
 struct Model: SmartCodable {
     var models: [String] = ["one"]
 }
 */


extension JSONDecoderImpl {
    struct SingleValueContainer: SingleValueDecodingContainer {
        let impl: JSONDecoderImpl
        let value: JSONValue
        let codingPath: [CodingKey]

        init(impl: JSONDecoderImpl, codingPath: [CodingKey], json: JSONValue) {
            self.impl = impl
            self.codingPath = codingPath
            self.value = json
        }

        func decodeNil() -> Bool {
            self.value == .null
        }
    }
}

extension JSONDecoderImpl.SingleValueContainer {
    func decode(_: Bool.Type) throws -> Bool {
        guard case .bool(let bool) = self.value else {
            throw self.impl.createTypeMismatchError(type: Bool.self, value: self.value)
        }

        return bool
    }

    func decode(_: String.Type) throws -> String {
        guard case .string(let string) = self.value else {
            throw self.impl.createTypeMismatchError(type: String.self, value: self.value)
        }
        return string
    }

    func decode(_: Double.Type) throws -> Double {
        try decodeFloatingPoint()
    }

    func decode(_: Float.Type) throws -> Float {
        try decodeFloatingPoint()
    }

    func decode(_: Int.Type) throws -> Int {
        try decodeFixedWidthInteger()
    }

    func decode(_: Int8.Type) throws -> Int8 {
        try decodeFixedWidthInteger()
    }

    func decode(_: Int16.Type) throws -> Int16 {
        try decodeFixedWidthInteger()
    }

    func decode(_: Int32.Type) throws -> Int32 {
        try decodeFixedWidthInteger()
    }

    func decode(_: Int64.Type) throws -> Int64 {
        try decodeFixedWidthInteger()
    }

    func decode(_: UInt.Type) throws -> UInt {
        try decodeFixedWidthInteger()
    }

    func decode(_: UInt8.Type) throws -> UInt8 {
        try decodeFixedWidthInteger()
    }

    func decode(_: UInt16.Type) throws -> UInt16 {
        try decodeFixedWidthInteger()
    }

    func decode(_: UInt32.Type) throws -> UInt32 {
        try decodeFixedWidthInteger()
    }

    func decode(_: UInt64.Type) throws -> UInt64 {
        try decodeFixedWidthInteger()
    }

    func decode<T>(_ type: T.Type) throws -> T where T: Decodable {
        try self.impl.unwrap(as: type)
    }
    
    @inline(__always) private func decodeFixedWidthInteger<T: FixedWidthInteger>() throws -> T {
        try self.impl.unwrapFixedWidthInteger(from: self.value, as: T.self)
    }

    @inline(__always) private func decodeFloatingPoint<T: LosslessStringConvertible & BinaryFloatingPoint>() throws -> T {
        try self.impl.unwrapFloatingPoint(from: self.value, as: T.self)
    }
}


