# galgen

Galgen can generate html into your image directory structure.

## usage

Create a `.env` file next to `galgen.rb` and put the following inside it:
```
GALLERY=<full path to your gallery>
```

Now you you can run it and get `index.html` files generated into the directory
given and all it's children.
Ina addition to this, each directory might contain a `desc.html` file containing
additional text to be put before the images.
You can also put a `style.css` file into any directory and it will be used by
it and all it's children.
