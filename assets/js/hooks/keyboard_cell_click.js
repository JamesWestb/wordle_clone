export default {
  mounted () {
    const isKeyboardCell = element => {
      return (
        element.innerText &&
        element.innerText.length === 1 &&
        element.classList.contains('kbd')
      )
    }

    addEventListener('mousedown', event => {
      if (isKeyboardCell(event.target)) {
        this.pushEvent('keydown', { key: event.target.innerText.toLowerCase() })
      }
    })
  }
}
