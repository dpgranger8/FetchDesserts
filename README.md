
# Dave's Desserts

Fetch.com coding challenge solution in SwiftUI. It allows users to browse dessert recipes and learn how each dessert is made.


## Features

- Light/dark mode supported
- Smart image management using CacheAsyncImage
- Preview images on the home screen and full-size images on the detail view to save memory
- Easy to learn each recipe in app


## Lessons Learned

Implementing the zoom animation when tapping on a dessert card came with some various design challenges and drawbacks. I understood this was not required but I wanted to try it out of curiosity. On the home screen I was essentially forced to dispose of the usual navigation bar and accompanying code because it was causing the animation not to work properly.

## Acknowledgements

 - [Balaji Venkatesh - SwiftUI Pinterest Grid Animation.](https://www.youtube.com/watch?v=fBCu7rM5Vkw) Used for smooth zoom animation
 - [Damjan Dabo - BottomSearchBar.](https://github.com/dabodamjan/BottomSearchBar) Used to make dessert items searchable
  - [Pedro Rojas - CacheAsyncImage.](https://www.youtube.com/watch?v=KhGyiOk3Yzk) Used to display images efficiently by retrieving and caching only what is on screen
 - [SvenTiigi - YouTubePlayerKit.](https://github.com/SvenTiigi/YouTubePlayerKit?tab=MIT-1-ov-file) Used for in-app YouTube video player


## Endpoint

#### https://www.themealdb.com/

```http
  GET api/json/v1/1/filter.php?c=[CATEGORY]
  GET api/json/v1/1/lookup.php?i=[ID]
```

| Parameter | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `[CATEGORY]`      | `string` | **Required**. Fetches the list of meals in the chosen category |
 `[ID]`      | `string` | **Required**. Looks up a single meal's details using meal ID|


## Appendix

MIT License

Copyright (c) 2023 Damjan Dabo

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

MIT License

Copyright (c) 2023 Pedro Rojas and project authors.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

The MIT License (MIT)

Copyright (c) 2024 Sven Tiigi

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
