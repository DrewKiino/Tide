
![GitHub Logo](tide-logo.png)

# A powerful wrapper

An image downloading and processing framework powered by [Gavin Bunney](https://github.com/gavinbunney)'s [Toucan](https://github.com/gavinbunney/Toucan), [Olivier Poitrey](https://github.com/rs)'s [SDWebImage](https://github.com/rs/SDWebImage), and [Due Munk](https://github.com/duemunk)'s [AsyncSwift](https://github.com/duemunk/Async) all wrapped in an efficient yet powerful wrapper.

With a single fully-featured extension, you can perfrom image downloads, image processing, and image handling all in one go just with a single line of code. All of these processes happen in the background-thread and is never invasive, is performant, and clean.

## Installation

``` Swift
pod 'Tide'
```

## Downloading Images

```Swift
profileImageView.imageFromSource("https://i.ytimg.com/vi/tntOCGkgt98/maxresdefault.jpg")
```

## Processing Images

These are all the options:

```Swift
profileImageView.imageFromSource(
  URL: "https://i.ytimg.com/vi/tntOCGkgt98/maxresdefault.jpg",
  placeholder: UIImage(named: "default-placeholder"),
  fitMode: .Clip,
  mask: .Squared,
  cornerRadius: 8.0,
  borderWidth: 1.0,
  borderColor: .redColor(),
  animated: true,
  forced: false,
  progress: { progress in

  	// do something with progress

}) { image in

  // do something with image
}
```

## Wrapper Features

- **URL**:	*String?*

	* The url string the image will be downloaded from the web.

- **placeholder**: *UIImage?*

	* The placeholder image that will be used if the image downloaded returns **nil**.

- **fitMode**: *Tide.fitMode*

	* **.Clip** Resizes the image to fit its container without distorting the image. **(default)**
	* **.Crop** Resizes the image to fit its container by cropping excess parts.
	* **.Scale** Resizes the image to fit its container by scaling the image to fit.
	* **.None** Retains the original image size.

- **mask**: *Tide.Mask*

	* **.Rounded** Clips the image with a round cookie cutter, *perfect for profile pictures*.
	* **.Squared** Clips the image with a rounded-edge square cookie cutter.
	* **.None** Leaves the image as is. **(default)**

- **cornerRadius**: *CGFloat*

	* The corner radius for the **.Squared** mask to go off on.
	* 0.0 **(default)**

- **borderWidth**: *CGFloat*

	* The border width of the image after a *mask* is applied.
	* 0.0 **(default)**

- **borderColor**: *UIColor*

	* The border color of the image after a *mask* is applied.
	* .whiteColor() **(default)**

- **animated**: *Bool*

	* If set to *true*, the image will *fade-in* after being set from either the url or placeholder.
	* true **(default)**

- **forced**: *Bool*

	* If set to *true*, if the image downloaded from the web or the image returned from the placeholder is **nil**, then the image set will be nil.
	* This is good if you want to image seen in the app to be dictated by whether or not the url exists.
	* false **(default)**

- **progress**: *(Float -> Void)?*

	* This block gives the progress of the image downloaded from *0 - 100*.

- **block**: *(image: UIImage?) -> Void)?*

	* This block returns the image set from either the image downloaded from the web, the placeholder, the original image set if none are returned from the former two, or **nil** if there were no images returned from any.

## Convenience Functions

* ```.imageFromSource()``` extends to **UIButtons** as well! It comes with all the features along with a *UIControlState* parameter.

* The methods listed below also extend from both **UIImageView** and **UIButton**:

	* ```.fitClip(image: UIImage?, fitMode: .Clip, completionHandler: ((image: UIImage?) -> Void)?)```

	* ```.rounded(image: UIImage?, cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: UIColor, completionHandler: ((image: UIImage?) -> Void)?)```

	* ```.squared(image: UIImage?, cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: UIColor, completionHandler: ((image: UIImage?) -> Void)?)```

## Credits

Credit goes to [Gavin Bunney](https://github.com/gavinbunney), [Olivier Poitrey](https://github.com/rs), and [Due Munk](https://github.com/duemunk) for helping me build this awesome wrapper.

## Copyright

*If your work is presented in this framework and you do not want it to be, please let me know at:*

 ```
 andrew@totemv.com
 ```

## License

Copyright (c) 2016 by [Andrew Aquino](http://totemv.com/drewkiino/), [TotemV.LLC](http://totemv.com/)

License MIT (Pacific)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
Status API Training Shop Blog About

