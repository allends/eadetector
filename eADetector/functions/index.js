const functions = require("firebase-functions");
// console.log(functions);

// Create and Deploy Your First Cloud Functions
// https://firebase.google.com/docs/functions/write-firebase-functions

exports.helloWorld = functions.https.onRequest((request, response) => {
  // Request:
  // uid
  functions.logger.info("Hello logs!", {structuredData: true});
  response.send("Hello from Firebase!");
});