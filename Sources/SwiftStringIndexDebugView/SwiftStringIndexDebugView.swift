extension String.Index {
  public var debugView: StringIndexDebugView {
    let children = Mirror(reflecting: self).children
    let child = children.first { $0.label == "_rawBits" }
    return StringIndexDebugView(_rawBits: child?.value as? UInt64 ?? 0)
  }
}

// See swiftlang/swift/stdlib/public/core/StringIndex.swift
//
// It's also possible to use an LLDB formatter, see
// - https://github.com/anpol/lldb-swift-string-index
// - https://github.com/apple/swift-lldb/pull/1769
public struct StringIndexDebugView : CustomDebugStringConvertible {
  let _rawBits : UInt64

  // A combination of encodedOffset and transcodedOffset, used for ordering.
  public var orderingValue: UInt64 { return _rawBits &>> 14 }

  // Scalar offset, measured in units of internal encoding.
  // Since Swift 5, internal encoding is UTF-8, so units here are UInt8.
  public var encodedOffset: Int {
    return Int(truncatingIfNeeded: _rawBits &>> 16)
  }

  // Sub-scalar offset, measured in units of external encoding.
  // E.g. if external encoding is UTF-16, then the units here are UInt16.
  public var transcodedOffset: Int {
    return Int(truncatingIfNeeded: orderingValue & 0x3)
  }

  // True if the index is known to be scalar aligned, false if it's not;
  // `nil` if the index needs to be checked for the alignment.
  public var isScalarAligned: Bool? {
    let value = (_rawBits & 0x01) != 0
    if !value && transcodedOffset == 0 {
      return nil
    }
    return value
  }

  // The cached distance to the next extended grapheme cluster boundary; or
  // `nil` if the boundary needs to be determined.
  public var characterStride: Int? {
    let value = (_rawBits & 0x3F00) &>> 8
    return value != 0 ? Int(truncatingIfNeeded: value) : nil
  }

  public var reserved: Int? {
    let value = (_rawBits & 0xFE) &>> 1
    return value != 0 ? Int(truncatingIfNeeded: value) : nil
  }

  public var debugDescription: String {
    var result = """
      StringIndexDebugView(\
      encodedOffset: \(encodedOffset), \
      transcodedOffset: \(transcodedOffset)
      """
    if let isScalarAligned = isScalarAligned {
      result += ", scalarAligned: \(isScalarAligned)"
    }
    if let characterStride = characterStride {
      result += ", characterStride: \(characterStride)"
    }
    if let reserved = reserved {
      result += ", reserved: \(reserved)"
    }
    result += ")"
    return result
  }
}
