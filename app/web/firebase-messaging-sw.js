importScripts('https://www.gstatic.com/firebasejs/9.6.1/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.6.1/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: 'AIzaSyA2cnjoD-adcLXITY4qEWYnaaqIiBS-elY',
  appId: '1:421457527534:web:a6ad898f271095da6369ff',
  messagingSenderId: '421457527534',
  projectId: 'zae-fgv-coffee',
  authDomain: 'zae-fgv-coffee.firebaseapp.com',
  storageBucket: 'zae-fgv-coffee.appspot.com',
  measurementId: 'G-NQQM6LVTGG',
});

const messaging = firebase.messaging();
