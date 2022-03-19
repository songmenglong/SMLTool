# SMLTool

[![CI Status](https://img.shields.io/travis/songmenglong/SMLTool.svg?style=flat)](https://travis-ci.org/songmenglong/SMLTool)
[![Version](https://img.shields.io/cocoapods/v/SMLTool.svg?style=flat)](https://cocoapods.org/pods/SMLTool)
[![License](https://img.shields.io/cocoapods/l/SMLTool.svg?style=flat)](https://cocoapods.org/pods/SMLTool)
[![Platform](https://img.shields.io/cocoapods/p/SMLTool.svg?style=flat)](https://cocoapods.org/pods/SMLTool)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

SMLTool is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SMLTool'
```

## 使用说明
### swift字典与model转换
```swift
// Model转字典
let model = People(name: "张三", sex: 0, age: 30)
guard let dict = ModelEncoder.encoder(toDictionary: model) else {
    return
}
debugPrint("", dict)

// 字典转Model
let dict: [String: Any] = ["sex": 1, "age": 32, "name": "李四"]
guard let model = try? ModelDecoder.decode(People.self, param: dict) else {
    return
}
debugPrint("", model)
```

### json字符串与字典转换
```swift
// JSON转字典
let json = "{\"name\":\"刘大\",\"age\":25,\"sex\":1}"
guard let dict = JSONTool.translationJsonToDic(from: json) else {
    return
}
debugPrint("", dict)

// 字典转JSON
let dict: [String: Any] = ["sex": 1, "age": 27, "name": "王五"]
guard let json = JSONTool.translationObjToJson(from: dict) else {
    return
}
debugPrint("", json)
```


## Author

songmenglong, 983174628@qq.com

## License

SMLTool is available under the MIT license. See the LICENSE file for more info.
