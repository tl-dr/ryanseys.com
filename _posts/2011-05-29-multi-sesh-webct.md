---
layout: post
title: Multi-Session WebCT
category: projects
tags: sidebar
name: multi-sesh-webct
thumb: /img/webct-thumb.png
---

A [Firefox][addon]/[Chrome][extension] extension that enables multiple login sessions for Carleton U's (now deprecated) LMS, WebCT.

[firefox][addon]/[chrome][extension] &mdash; [details][details] &mdash; [code][code]

<!-- truncate_here -->

Multi-Session WebCT is a Firefox [addon][addon]/Chrome [extension][extension] that "enables" multiple sessions for Carleton U's WebCT.

- - -

**Note:** WebCT at Carleton University is now **retired**, rendering these extensions useless in their current form. If you would like to modify them for your own use with your school (or otherwise), you can find the code [here][code]! Fork away!

- - -

I use the word "enables" with caution as it is not so much creating a feature as it is destroying a restriction. The (now retired) LMS for Carleton, [WebCT][webct], did not allow you to have multiple sessions open **within the same browser**. This restriction was likely created as a security precaution so in theory it was created in good faith, though in reality it was executed rather poorly in my opinion.

## Silly WebCT

To start, it only restricted additional sessions **within the same browser**. If you opened two tabs, and attempted to log into WebCT on them both, one would throw this error:

![Multi-Session Denied Issue](/img/multi-sesh-webct.png "Multi-Session Denied Issue")

If you instead opened two browsers and attempted to log into WebCT on them both, everything would go dandy and both sessions would be allowed. So clearly this wasn't hard to get around, it was just annoying, so why restrict things in the first place? Silly WebCT.

## The Investigation

In my (rather short-lived) investigation of the culprit for this restriction, I discovered a cookie was being created when the session was created. So delete the cookie => delete the session => logout, right? Not exactly. It was a tattle-tale cookie, it only told WebCT that you had opened a session *sometime* in the past and that it was *probably* still open. I say probably because this cookie was supposed to commit suicide when you closed all your sessions, but sometimes he simply wimped out and hung around. Silly WebCT.

So not only did it not allow 2+ sessions of WebCT at a time, but it also didn't allow *a single* session open when its own cookie couldn't do the deed of destroying itself when asked, even politely. It was now telling a lie, and you know what we do to liars? We eliminate them.

So that's what I did, and that's all Multi-Session WebCT does. Destroys a cowardly cookie.

When you want to start a second (or more) WebCT session, just press the Multi-Session WebCT button and the coward cookie will be detroyed and a beautiful new tab with a login screen will be waiting there for you to login to WebCT.

Fix'd (but with a few limitations):

1. The coward cookie is a tattle-tale beyond the grave: if you refresh your browser after he dies, your session will also die and you will be immediately logged out. Just don't refresh and your session should stay alive, even between page-to-page navigations.

2. You cannot just block cookies from the Carleton WebCT (sub)domain. Other cookies from WebCT (including possibly the coward cookie) are required for initial login procedures to create the session. For this reason I made it only destroy the coward when it was sure that you wanted an additional session open (when you click the addon button).

3. WebCT at Carleton is now **RETIRED!** Carleton's next LMS, [Moodle](http://moodle.org), is next up on the cutting block and with it comes its own discrepancies and outright blatant issues. You can just never win. The addon/extension and its [code][code] is still freely available for download. If you wish to modify these extensions for use with your own school's WebCT, go for it!

## Conclusion

This was a great weekend project, taught me a bunch about building browser addon/extensions, though a cookies should only be delicious and rewarding, not tattling cowards. That is all.

- - -

[Firefox][addon] &mdash; [Chrome][extension]

[addon]: https://addons.mozilla.org/en-US/firefox/addon/carleton-university-webct-m/
[extension]: https://chrome.google.com/webstore/detail/carleton-university-webct/kfdfjhjbablhaahkolidaghphifjeaig?hl=en
[details]: /projects/multi-sesh-webct
[webct]: http://en.wikipedia.org/wiki/WebCT
[code]: https://github.com/ryanseys/multi-sesh-webct
