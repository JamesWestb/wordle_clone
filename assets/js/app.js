// We import the CSS which is extracted to its own file by esbuild.
// Remove this line if you add a your own CSS build pipeline (e.g postcss).

// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import 'phoenix_html'
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from 'phoenix'
import { LiveSocket } from 'phoenix_live_view'
import topbar from '../vendor/topbar'
import infoTextAnimation from './hooks/info_text_animation'
import characterInputAnimation from './hooks/character_input_animation'

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute('content')

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: '#29d' }, shadowColor: 'rgba(0, 0, 0, .3)' })
window.addEventListener('phx:page-loading-start', info => topbar.show())
window.addEventListener('phx:page-loading-stop', info => topbar.hide())

window.validationMessageKey = {
  invalid_length: 'Not enough letters',
  not_in_database: 'Not in word list',
  no_guesses: 'Not enough letters',
  correct: 'Genius'
}

function guessSubmitAnimation (row, validation, relay) {
  const currentRow = document.getElementById(`row_${row}`)

  if (validation == 'correct' || !validation) {
    const childElements = currentRow.children

    const animationCount = childElements.length
    let completedAnimations = 0
    const resultObject = {}

    document.addEventListener('keydown', disableKeyboardEvents)

    function disableKeyboardEvents (event) {
      event.preventDefault()
      event.stopPropagation()
    }

    Array.from(childElements).forEach((childElement, index) => {
      setTimeout(() => {
        childElement.classList.add('guess-submit')
        const animationDuration =
          parseFloat(getComputedStyle(childElement).animationDuration) * 1000
        const delay = animationDuration - 200

        let column = index

        let background = 'bg-base-300'
        const animationEndHandler = () => {
          childElement.classList.remove('guess-submit')
          const key = `${row}-${column}`
          resultObject[key] = background
          completedAnimations++

          if (completedAnimations === animationCount) {

            relay.pushEvent('background-change', resultObject)
            document.removeEventListener('keydown', disableKeyboardEvents)
          }
        }

        childElement.addEventListener('animationend', animationEndHandler)

        setTimeout(() => {
          childElement.classList.add(background)
        }, delay)
      }, index * 350)
    })
  } else {
    currentRow.classList.add('shake-element')

    currentRow.addEventListener('animationend', onAnimationEnd)

    function onAnimationEnd () {
      currentRow.classList.remove('shake-element')
    }
  }
}

const Hooks = {
  infoTextAnimation: infoTextAnimation(guessSubmitAnimation),
  characterInputAnimation
}

let liveSocket = new LiveSocket('/live', Socket, {
  params: { _csrf_token: csrfToken },
  hooks: Hooks
})

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// liveSocket.enableLatencySim(100)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket
