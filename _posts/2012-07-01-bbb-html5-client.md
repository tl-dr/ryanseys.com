---
layout: post
title: BigBlueButton HTML5 Client
category: projects
tags: sidebar
name: bbb-html5-client
---

BigBlueButton web conferencing (rooms, whiteboard/slides, chat) all real-time in HTML5!

[details](/projects/bbb-html5-client) &mdash; [code](https://github.com/bigbluebutton/bigbluebutton/tree/master/labs/bbb-html5-client)

<!-- truncate_here -->

In the summer of 2012, I had the pleasure of working at Blindside Networks, an Ottawa-based startup driving the BigBlueButton project. <a href="http://bigbluebutton.org" target="_blank">BigBlueButton</a> is an open-source web conferencing system designed for distance education. It helps educators and students connect and communicate using voice & video, whiteboard/slides, and text chat, all real-time in the browser.

During my stay, I worked on a brand spankin' new client for them in HTML5 to replace their current Flash implementation. Created from the ground up using Node.js, Socket.io, Redis, and lots of javascript I built out the existing features of their client into a brand new, HTML5 version (yes, it works on your phone)!

![BigBlueButton HTML5 Demo](/img/bbb-html5.png "BigBlueButton HTML5 Demo")

Features include meeting rooms with meeting-wide chat, custom uploadable slides with whiteboard functionality (lines/shapes/text annotations, clears/undos, pan/zoom) with real-time syncronization between every member of the meeting simultaneously, all using standard-compliant HTML5 and JavaScript.

