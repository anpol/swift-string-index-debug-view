# SwiftStringIndexDebugView

A class that displays contents of the Swift `String.Index` type.

## Installation

Use the Swift package manager to attach this package as a dependency.

Then import it as usual:
```swift
import SwiftStringIndexDebugView
```

## Quick Start

Assuming you have a variable `index` of type `String.Index`, you can print its
`debugView` property:
```swift
print(index.debugView)
```

The output is follows:
```
StringIndexDebugView(encodedOffset: 5, transcodedOffset: 0, scalarAligned: true, characterStride: 1)
```
