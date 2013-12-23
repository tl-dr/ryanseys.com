(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
})(window,document,'script','//www.google-analytics.com/analytics.js','ga');

ga('create', 'UA-39341257-1', 'ryanseys.com');
ga('send', 'pageview');

function toggleMenu() {
  var links = document.getElementById('links');
  if(links.className == 'show-phone') {
    links.className = 'hidden-phone';
  }
  else {
    links.className = 'show-phone';
  }
}
