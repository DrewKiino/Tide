
![GitHub Logo](tide-logo.png)

An image downloading and processing framework powered by [Gavin Bunney](https://github.com/gavinbunney)'s [Toucan](https://github.com/gavinbunney/Toucan), [Olivier Poitrey](https://github.com/rs)'s [SDWebImage](https://github.com/rs/SDWebImage), and [Due Munk](https://github.com/duemunk)'s [AsyncSwift](https://github.com/duemunk/Async) all wrapped in an efficient yet powerful wrapper.

## Downloading Images

```Swift

let profileImageView: UIImageView = UIImageView()


```

Image downloading and processing framework, everything occurs in the background and is non-invasive to the main-thread. Supports rounding of images and fitted clipping. Perfect for user profile pictures, item images, etc.

# Credits
Credit goes to [Gavin Bunney](https://github.com/gavinbunney) for his [Toucan](https://github.com/gavinbunney/Toucan) framework. Tide is simply a wrapper over Toucan's core methods with added background processing, leak fixes, and convenience methods.

``` Swift
pod 'Tide'
```

# Author
Andrew Aquino, [TotemV.LLC](http://totemv.com/)
