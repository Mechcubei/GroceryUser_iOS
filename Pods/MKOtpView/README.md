# MKOtpView

[![CI Status](https://i.imgur.com/wM3sUrW.png)](https://travis-ci.org/mohit5189/MKOtpView)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

iOS 8.0 or greater.

## Installation

MKOtpView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'MKOtpView'
```

## Implementation steps

1. Create MKOtpView Object by passing frame:
```
var otpView:MKOtpView!
otpView = MKOtpView(frame: CGRect(x: 10, y: 100, width: 350, height: 50))
```
2. Now you can set different properties as given below:

```
otpView = MKOtpView(frame: CGRect(x: 10, y: 100, width: 350, height: 50))
otpView.setVerticalPedding(pedding: 5)
otpView.setHorizontalPedding(pedding: 5)
otpView.setNumberOfDigits(numberOfDigits: 6)
otpView.setBorderWidth(borderWidth: 2.0)
otpView.setBorderColor(borderColor: UIColor.green)
otpView.setCornerRadius(radius: 2)
otpView.setInputBackgroundColor(inputBackgroundColor: UIColor.white)
otpView.backgroundColor = UIColor.lightGray
otpView.enableSecureEntries()
self.view.addSubview(otpView)
```
3. Set closure to get the response as soon as all otp fields are filled, Here you can write your own logic to use the number filled.

```
otpView.onFillDigits = { number in
print("input number is \(number)")
}

```
4. Finally call render method once everything is set.

```
otpView.render()
```

## Author

Mohit Kumar

## License

MKOtpView is available under the MIT license. See the LICENSE file for more info.
