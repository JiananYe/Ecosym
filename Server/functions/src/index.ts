import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin'
admin.initializeApp()

export const getCredits = functions.https.onRequest((request, response) => {
  admin.firestore().doc("users/IxX1TjnIMZT9Nxd786XKrAUNJBA2").get()
  .then(snapshot => {
    const data = snapshot.data()
    response.send(data)
  })
  .catch(error => {
    console.log(error)
    response.status(500).send(error)
  })
});
