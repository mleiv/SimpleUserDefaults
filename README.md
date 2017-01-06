# SimpleUserDefaults

A generally type-agnostic, highly simplified way to access/cache UserDefaults using Swift 3.

Before you try this type, I highly recommend looking at https://github.com/radex/SwiftyUserDefaults first. Since you probably want that instead. I just found that I preferred encapsulated object property access for my defaults-stored data. And it was a fun experiment.

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

1. I'd recommend extending SimpleUserDefaults.init() and get() to accept your own enum type, and use that to define the keys.

2. Improved access.
I just left it with get()/set() access, so I wouldn't have to create ExpressibleXXXXXXLiteral protocols for all my custom types and assign SimpleUserDefaults to use them.
But here is a way to improve access with a bit more declaration code. If you want to make them look exactly like regular properties or stuff.
```swift
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