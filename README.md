# SimpleUserDefaults

A type-agnostic, highly simplified way to get/set UserDefaults using Swift 3.

Before you try this type, I highly recommend looking at https://github.com/radex/SwiftyUserDefaults first. Since you probably want that instead. This was an experiment, and I just found that I preferred the encapsulated object property access for my defaults-stored data, rather than the more general Default[.property] access (which I understand most other people would choose).

### How It Works

1. Establish your property value type and name:
```swift
var myStoredPreference = SimpleUserDefaults<String>(name: "myStoredPreference",  defaultValue: "none")
```
(The **name** parameter should be unique across your application.)

2. Access your property:
```swift
if myStoredPreference.get() == "happy" {
    // do something
}
```

3. Store your property:
```swift
myStoredPreference.set("notHappy")
```

### Suggested Extensions

1. Here is a way to improve access with a bit more declaration code. If you want to make them look exactly like regular properties or stuff.
```swift
// Example of using getter/setter and private store to simplify access:
private var _myStoredPreference = SimpleUserDefaults<String>(name: "myStoredPreference",  defaultValue: "none")
var myStoredPreference: String {
    get{ return _myStoredPreference.get() } 
    set{ _myStoredPreference.set(newValue) }
}
//...
if myStoredPreference == "happy" {
    myStoredPreference = "stillhappy"
}
```