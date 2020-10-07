import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin'


const FIELD_PRICE = 150
const BUILDING_PRICE = 100

admin.initializeApp()

export const addAccount2 = functions.firestore.document("/users/{userid}").onCreate((snap, context) => {
  const credits = snap.data().credits + 1000
  return snap.ref.update({credits: credits})
});

export const test = functions.https.onRequest((request, response) => {
  admin.database().ref("/game/world/map_data/" + request.body.x + "/" + request.body.y).update({owner: request.body.id})
  .catch(error => {
    console.log(error)
    response.status(500).send(error)
  })
});

export const getCredits = functions.https.onRequest((request, response) => {
  admin.firestore().doc("users/" + request.body.id).get()
  .then(snapshot => {
    const data = snapshot.data()
    response.send(data)
  })
  .catch(error => {
    console.log(error)
    response.status(500).send(error)
  })
});

export const addOwner = functions.https.onRequest((request, response) => {
  admin.firestore().doc("users/" + request.body.id).get()
  .then(snapshot => {
    const data: any = snapshot.data()
    if (data.credits >= FIELD_PRICE) {
      throw new Error("not enough credits");
    }
    // noch error werfen wenn feld bereits besetzt ist
    else {
      data.credits -= FIELD_PRICE
      const promises = []
      const cast: Promise<any> = admin.firestore().doc("users/" + request.body.id).update({credits: data.credits})
      promises.push(cast)
      promises.push(admin.database().ref("game/world/map_data/" + request.body.x + "/" + request.body.y).update({owner: request.body.id}))
      return Promise.all(promises)
    }
  })
  .then(() =>{
      response.send("owner ok")
  })
  .catch(error => {
    console.log(error)
    response.status(500).send(error)
  })
});

export const addBuilding = functions.https.onRequest((request, response) => {
  admin.firestore().doc("users/" + request.body.id).get()
  .then(snapshot => {
    const data: any = snapshot.data()
    if (data.credits >= BUILDING_PRICE) {
      throw new Error("not enough credits");
    }
    // noch error werfen wenn feld bereits besetzt ist
    // error werfen wenn das feld nicht von userID besetzt ist
    else {
      data.credits -= BUILDING_PRICE
      const promises = []
      const cast: Promise<any> = admin.firestore().doc("users/" + request.body.id).update({credits: data.credits})
      promises.push(cast)
      promises.push(admin.database().ref("game/world/map_data/" + request.body.x + "/" + request.body.y).update({building: request.body.building}))
      return Promise.all(promises)
    }
  })
  .then(() =>{
      response.send("building ok")
  })
  .catch(error => {
    console.log(error)
    response.status(500).send(error)
  })
});

export const addAccount = functions.firestore.document("/users/{userid}").onCreate((snap, context) => {
  const credits = snap.data().credits + 1000
  return snap.ref.update({credits: credits})
});