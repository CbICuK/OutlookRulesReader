//
//  ASCIIString.swift
//
//
//  Created by Hugh Bellamy on 14/08/2020.
//

import DataStream

internal struct ASCIIString {
    public var dataSize: UInt32 {
        return (value.count >= 256 ? 3 : 1) + UInt32(value.count)
    }
    
    public var value: String
    
    public init(value: String) {
        self.value = value
    }
    
    public init(dataStream: inout DataStream) throws {
        // Length (1 byte or 3 bytes if first byte is 0xFF)
        let length = try dataStream.readUInt8Length()
        
        // Value (variable)
        guard let value = try dataStream.readString(count: length, encoding: .ascii) else {
            throw OutlookRulesFileError.corrupted
        }
        
        self.value = value
    }
    
    public func write(to dataStream: inout OutputDataStream) {
        // Length (1 byte or 3 bytes if length >= 256)
        dataStream.writeUInt8Length(length: value.count)
        
        // Value (variable)
        dataStream.write(value, encoding: .ascii)
    }
}