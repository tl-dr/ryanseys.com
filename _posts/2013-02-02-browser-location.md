---
layout: blogpost
title: Getting browser location with tmprtr
categories: blog
name: browser-location
---

I very recently created an app called [tmprtr][tmprtr]. It is a very simple weather app that uses your location to get weather data. I created it using <code>navigator.geolocation</code> which in modern browsers requests the user to allow/deny the website from getting an accurate geolocation. This is great because I get a very accurate location for the user and they get the weather! But I wanted to do better.<!-- truncate_here -->

Immediately after visiting my site for the first time, a user will be greeted with a "GIVE ME YOUR LOCATION" request and to me that, from a user experience, raises a big red flag. I wanted a way to get the location using the most unintrusive way and considering I don't need exact location, I decided to attempt to get location based on IP address first. This location is less accurate than the previously mentioned method, but for the purposes of weather, it's close enough. I request IP location (all under the hood) and if that fails, fallback to a geolocation request, so I always ensure the user has the best experience possible. To get the IP location I embed a javascript library from [http://www.geoplugin.net/javascript.gp][geoplugin] into my page and request the latitude and longitude values through two requests:
<pre><code>geoplugin_latitude();
geoplugin_longitude();</code></pre>
From here I request the weather data from the server, just as I would had I got the coordinates from the more obtrusive (yet more accurate) request:

<pre><code>navigator.geolocation.getCurrentPosition();</code></pre>

Overall, switching to a default IP-based location has not affected my app in any negative direction. The user has their weather information nearly instantly after visiting and is less disrupted in the process.

[geoplugin]: http://www.geoplugin.net/javascript.gp
[tmprtr]: /projects/tmprtr
