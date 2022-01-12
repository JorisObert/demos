
const functions = require("firebase-functions");
const admin = require("firebase-admin");
const request = require("graphql-request");

const client = new request.GraphQLClient('https://steady-bedbug-43.hasura.app/v1/graphql', {
    headers: {
        "content-type": "application/json",
        "x-hasura-admin-secret": "Ru95VbD0AtZMPCcn7MstigAOjYfNfrfhpVf4TmcB3Pa44oTytW5X3GvIEdoNZHeW"
    }
})
admin.initializeApp(functions.config().firebase);

exports.setUserClaims = functions.https.onCall(async (data, context) => {
    try{
        const id = data.uid
        const customClaims = {
                    "https://hasura.io/jwt/claims": {
                        "x-hasura-default-role": "user",
                        "x-hasura-allowed-roles": ["user"],
                        "x-hasura-user-id": id
                    }
                };

        const result = await admin.auth().setCustomUserClaims(id, customClaims);
        return result;
    }catch(e){
        console.log(e);
        throw new functions.https.HttpsError('unknown', 'ERROR3', e.message );
    }
});

exports.processSignUp = functions.auth.user().onCreate(async user => {

    const id = user.uid;
    const email = user.email;
    const displayName = user.displayName || "No Name";
    const profilePicUrl = user.profilePicUrl;

    const mutation = `mutation($id: String!, $email: String, $displayName: String, $profilePicUrl: String) {
    insert_users(objects: [{
        id: $id,
        email: $email,
        displayName: $displayName,
        profilePicUrl: $profilePicUrl
      }]) {
        affected_rows
      }
    }`;

    admin.auth().setCustomUserClaims(user.uid, {
        'https://hasura.io/jwt/claims': {
        'x-hasura-default-role': 'user',
        'x-hasura-allowed-roles': ['user'],
        'x-hasura-user-id': user.uid
    }})

    try {
        const data = await client.request(mutation, {
            id: id,
            email: email,
            displayName: displayName,
            profilePicUrl: profilePicUrl
        })
        return data;
    } catch (e) {
        console.log(e);
        throw new functions.https.HttpsError('sync-failed', e.message);
    }
});

exports.verifyAuth = functions.https.onCall(async (data, context) => {
        admin.auth()
          .verifyIdToken(data.token)
          .then((decodedToken) => {
            const uid = decodedToken.uid;
            console.log(uid);
            return uid;
          })
          .catch((error) => {
            console.log(error);
          });
});

// SYNC WITH HASURA ON USER DELETE
exports.processDelete = functions.auth.user().onDelete(async (user) => {
    const mutation = `mutation($id: String!) {
        delete_users(where: {id: {_eq: $id}}) {
          affected_rows
        }
    }`;
    const id = user.uid;
    try {
        const data = await client.request(mutation, {
            id: id,
        })
        return data;
    } catch (e) {
        throw new functions.https.HttpsError('sync-failed');

    }
});
