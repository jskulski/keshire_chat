// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/web/endpoint.ex":
import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})

// When you connect, you'll often need to authenticate the client.
// For example, imagine you have an authentication plug, `MyAuth`,
// which authenticates the session and assigns a `:current_user`.
// If the current user exists you can assign the user's token in
// the connection for use in the layout.
//
// In your "lib/web/router.ex":
//
//     pipeline :browser do
//       ...
//       plug MyAuth
//       plug :put_user_token
//     end
//
//     defp put_user_token(conn, _) do
//       if current_user = conn.assigns[:current_user] do
//         token = Phoenix.Token.sign(conn, "user socket", current_user.id)
//         assign(conn, :user_token, token)
//       else
//         conn
//       end
//     end
//
// Now you need to pass this token to JavaScript. You can do so
// inside a script tag in "lib/web/templates/layout/app.html.eex":
//
//     <script>window.userToken = "<%= assigns[:user_token] %>";</script>
//
// You will need to verify the user token in the "connect/2" function
// in "lib/web/channels/user_socket.ex":
//
//     def connect(%{"token" => token}, socket) do
//       # max_age: 1209600 is equivalent to two weeks in seconds
//       case Phoenix.Token.verify(socket, "user socket", token, max_age: 1209600) do
//         {:ok, user_id} ->
//           {:ok, assign(socket, :user, user_id)}
//         {:error, reason} ->
//           :error
//       end
//     end
//
// Finally, pass the token on connect as below. Or remove it
// from connect if you don't care about authentication.

socket.connect()

// Now that you are connected, you can join channels with a topic:
let channel = socket.channel("rooms:lobby", {})
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

export default socket


// UI stuff
let usernameInput = $('#username-input');

let appInput = $("#app-input");
let smsInput = $("#sms-input");
let pnInput = $("#pn-input");

let appSend = $("#app-send");
let smsSend = $("#sms-send");
let pnSend = $("#pn-send");

let appContainer = $("#app-container");
let smsContainer = $("#sms-container")
let pnContainer = $("#pn-container")

// DISABLED - let appNotify = $('#app-notify')
let smsNotify = $('#sms-notify')
let pnNotify = $('#pn-notify')


function makeRoomToggle(from) {
  return function makeRoomToggleFn(event) {
    if ($(event.target).is(':checked')) {
      channel.push(`join:${from}`, {})
    }
    else {
      channel.push(`leave:${from}`, {})
    }
  }
}

smsNotify.on('change', makeRoomToggle('sms'))
pnNotify.on('change', makeRoomToggle('pn'))

function makePresenter(container) {
  return function makePresenterFn(payload) {
    const date = new Date();
    const time = date.toLocaleTimeString()
    container.append(`<br/>[${time} - ${payload.username}] ${payload.body}`)
  }
}

const appPresenter = makePresenter(appContainer)
const smsPresenter = makePresenter(smsContainer)
const pnPresenter = makePresenter(pnContainer)

function makeSendHandler(from, usernameInput, bodyInput) {
  return function makeSendHandlerFn(event) {
    if (event.keyCode === 13) {
      console.info("Trying to send")
      channel.push(`${from}:new_message`, {
        body: bodyInput.val(),
        username: usernameInput.val(),
        from: from,
      })
      appInput.val("")
    }
  }
}

const appSendHandler = makeSendHandler('app', usernameInput, appInput)
const smsSendHandler = makeSendHandler('sms', usernameInput, smsInput)
const pnSendHandler = makeSendHandler('pn', usernameInput, pnInput)

// Subscriptions
appInput.on("keypress", appSendHandler);
smsInput.on("keypress", smsSendHandler);
pnInput.on("keypress", pnSendHandler);

appSend.on("click", appSendHandler);
smsSend.on("click", smsSendHandler);
pnSend.on("click", pnSendHandler);

channel.on("app:new_message", appPresenter);
channel.on("sms:new_message", smsPresenter);
channel.on("pn:new_message", pnPresenter);