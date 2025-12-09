importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");

// Isikan konfigurasi Firebase Web kamu di sini
firebase.initializeApp({
  apiKey: "AIzaSyAWjbW0LMIMLvAUzfA7yr8g9wfacGXWyPA",
  authDomain: "cashmeup-a872c.firebaseapp.com",
  projectId: "Pcashmeup-a872c",
  storageBucket: "cashmeup-a872c.firebasestorage.app",
  messagingSenderId: "330795856822",
  appId: "1:330795856822:web:ac628af89b446736748717",
  measurementId: "G-ZDTBRFFR1L" // Opsional
});

const messaging = firebase.messaging();

// Opsional: Handle background messages
messaging.onBackgroundMessage(function(payload) {
  console.log('[firebase-messaging-sw.js] Received background message ', payload);
  
  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: '/icons/Icon-192.png' // Pastikan icon ini ada atau ganti path-nya
  };

  return self.registration.showNotification(notificationTitle, notificationOptions);
});