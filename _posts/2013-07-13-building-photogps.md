---
layout: blogpost
title: Building PhotoGPS
category: blog
tags: sidebar
name: building-photogps
---

[PhotoGPS][app] is a simple and fast web app you can use to instantly plot your photos on Google Maps, based on where they were taken.

It does this by extracting the GPS location (latitude & longitude) from the Exif metadata within the photo itself, and then using Google Maps API to display exactly where this is in the world.<!-- truncate_here --> In modern browsers, there exists an API for reading files directly in the browser. This API is called [FileReader][api] and it is what PhotoGPS uses to read your images directly, without first uploading them to the cloud. This keeps your data completely private from any server, while speeding up the extraction and plotting process significantly. You can plot literally 1000 photos in less than a minute.

![PhotoGPS][pic]

#### Building it out!

The initial PhotoGPS app showed markers on the Google Maps for every GPS-embedded photo it processed, but how can you even reflect on the memories taken at that point without a preview of the image. So a more recent version of PhotoGPS included thumbnail previews of your images (as shown in the screenshot above). Getting the thumbnails without using a server side is not too complicated in modern browsers. I just read the file in as a DataURL using the FileReader API, wrap that data in an image and voila!

{% highlight js %}
function drop_files(e) {
  var files = e.target.files || e.dataTransfer.files;
  var reader = new FileReader();
  reader.readAsDataURL(file[0]); // let's assume they drop only 1 file

  //wait until the whole file has been read
  reader.onloadend = function(event) {
    // you've got image data!
    var image_as_base64 = event.target.result;
    var img = new Image();
    img.src = image_as_base64;
    // now you've got an image to do whatever you want with!
  }
}
{% endhighlight %}

#### Scaling it up (or down)!

The above code is proof of concept, and would result in the entire full resolution file being processed and spat back out as a base64 string. When you start processing thousands of photos, each being stored as full resolution base64 strings, you're going to suck up a lot of memory pretty damn fast, so the obvious thing we can do is reduce the size of the image we store in the browser. We can use some fancy HTML5 Canvas elements to reduce the image by creating a canvas element of a particular size (let's say 100x100), calculating the proper dimensions of the image that would fit in such a box, and rendering the image in the canvas from our base64 string, then immediately asking for the rendered copy back (at 100x100 size), and throw out the original.

{% highlight js %}
// ...continue from previous code snippet
img.src = event.target.result;
img.onload = function() { // image loaded in img?
  var canvas = document.createElement('canvas');
  canvas.width = imageWidth; //calculated new image width of thumbnail
  canvas.height = imageHeight; //calculated new image height of thumbnail

  var ctx = canvas.getContext("2d");
  // redraw smaller
  ctx.drawImage(this, 0, 0, imageWidth, imageHeight);
  var thumbnail_data = canvas.toDataURL("image/jpeg");
  // use the thumbnail_data now as your base64 string
};
{% endhighlight %}

#### Speeding it up!

In the initial versions of PhotoGPS outlined previously, the speed at which files were processing relied on the size of the file itself. This was because initial techniques for reading and extracting the GPS location from the files were inefficient. It involved reading in the entire file including all of the image data to extract the GPS location and image data and then proceeding to extract the data. With [a little research][flickrblogpost], I was able to determine that the Exif data is limited to a certain section of the file (within the first 128 kilobytes of the file). This meant that we can reduce the extraction time from O(n) where n is the filesize, to O(1). Awesome!

{% highlight js %}
var files = e.target.files || e.dataTransfer.files;
var reader = new FileReader();
// splicing the first file up to 128kb (saves reading entire file)
var filePart = files[0].slice(0, 131072); // 131072 bytes = 128 kilobytes
reader.readAsBinaryString(filePart); //read in as binary string

reader.onloadend = function (e) {
  //feed the resulting binary string into the EXIF reader!
  var exif_data = EXIF.readFromBinaryFile(new BinaryFile(e.target.result));
  // boom! exif data extracted!
}
{% endhighlight %}

EXIF.readFromBinaryFile is a function exposed by [a library][exifjsgithub] I discovered (and [contributed to][exifjshist]) which allows EXIF parsing in the browser. I added thumbnail extraction to this library by reading the [Exif spec][spec] and [blog posts][flickrblogpost] on the topic of client-side Exif extraction, and with a little bit of elbow grease I was able to get thumbnail extraction working!

{% highlight js %}
// If IFD1Offset exists in the Exif tags then thumbnail data exists!
if(oTags.IFD1Offset) {
  // this reads in the tags associated with the thumbnail
  // this includes the starting address (JPEGInterchangeFormat)
  // and length of the thumbnail data (JPEGInterchangeFormatLength)
  IFD1Tags = readTags(oFile, iTIFFOffset,
      oTags.IFD1Offset + iTIFFOffset, EXIF.TiffTags, bBigEnd);
  var JPEGstart = IFD1Tags.JPEGInterchangeFormat;
  if(JPEGstart) {
      // See function readThumbnail() below for details
      oTags['thumbnail'] = readThumbnail(oFile, JPEGstart,
          IFD1Tags.JPEGInterchangeFormatLength, iTIFFOffset);
  }
}
else {
  // no luck finding thumbnail data
}

// Reads the thumbnail data from an oFile given
function readThumbnail(oFile, ThumbStart, ThumbLength, TIFFOffset) {
  // if the end of the file occurs before end of thumbnail
  if (oFile.length < ThumbStart+TIFFOffset+ThumbLength) {
    return; // no luck finding thumbnail data
  }
  var data = oFile.getStringAt(ThumbStart+TIFFOffset,ThumbLength);
  return 'data:image/jpeg;base64,' + btoa(data);
  // image data is returned here! :D
}
{% endhighlight %}

This allowed me to get previews for images without reading in the entire file, unless the Exif thumbnail was not present in which case I didn't have much choice but to read the whole file in to generate a thumbnail using HTML5 Canvas like discussed earlier.

## Conclusion

This little project was great for a lot of reasons. I learned a lot when it comes to the FileReader API and how much you can really do completely on the client-side. It challenged my low-level skills (reading specs can be a bitch) and pushed me to implement something which I knew was possible but had not yet been documented well. PhotoGPS is a nice little app I use from time to time to plot my photos and see how much I have explored, and what is still left to be discovered!

Keep on discovering!

![Pin][pinpic]

- - -

[app][app] &mdash; [code][code] &mdash; [discuss][hn]

[app]: https://ryanseys.com/photogps/
[code]: https://github.com/ryanseys/photogps
[api]: https://developer.mozilla.org/en-US/docs/Web/API/FileReader
[dnd]: http://www.html5rocks.com/en/tutorials/dnd/basics/
[exifjs]: https://github.com/ryanseys/photogps/blob/master/js/exif.js
[exifjsgithub]: https://github.com/jseidelin/exif-js
[exifjshist]: https://github.com/ryanseys/photogps/commits/master/js/exif.js
[spec]: http://www.exif.org/Exif2-2.PDF
[flickrblogpost]: http://code.flickr.net/2012/06/01/parsing-exif-client-side-using-javascript-2/
[pic]: /img/photogps.png
[pinpic]: /img/pin.png
[hn]: https://news.ycombinator.com/item?id=6039888
