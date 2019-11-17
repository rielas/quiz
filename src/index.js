import './main.css';
import {
  Elm
} from './Main.elm';
import * as serviceWorker from './serviceWorker';

(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
})(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

ga('create', 'UA-151596008-1', 'auto');

var clientId = "anatol";

ga(function(tracker) {
  clientId = tracker.get('clientId');
  console.log(clientId);

  Elm.Main.init({
    node: document.getElementById('root'),
    flags: {
      quizAddr: "http://localhost:3000/quiz.json",
      clientId: clientId,
      trackingId: "UA-151596008-1"
    }
  });
});

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();