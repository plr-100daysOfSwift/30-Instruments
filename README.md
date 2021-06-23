# Instruments

[Hacking with Swift: 100 Days of Swift - Project 30][1]

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Challenge

1. Go through project 30 and remove all the force unwraps. Note: implicitly unwrapped optionals are not the same thing as force unwraps – you’re welcome to fix the implicitly unwrapped optionals too, but that’s a bonus task.
2. Pick any of the previous 29 projects that interests you, and try exploring it using the Allocations instrument. Can you find any objects that are persistent when they should have been destroyed?
3. For a tougher challenge, take the image generation code out of cellForRowAt: generate all images when the app first launches, and use those smaller versions instead. For bonus points, combine the getDocumentsDirectory() method I introduced in project 10 so that you save the resulting cache to make sure it never happens again.

As a reminder, here’s the code for getDocumentsDirectory():

``` 
func getDocumentsDirectory() -> URL {
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		return paths[0]
}
```
[1]: https://www.hackingwithswift.com/100/98
