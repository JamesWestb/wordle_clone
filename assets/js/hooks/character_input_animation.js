export default {
  mounted () {
    addEventListener("mousedown", (event) => {
      if (event.target.innerText) {
        if (event.target.innerText.length === 1) {
          if (event.target.classList.contains("kbd")) {
            this.pushEvent('keydown', {"key": event.target.innerText.toLowerCase()});
          }
        }
      }
    });


    this.handleEvent('animate-input-cell', data => {
      const inputCell = document.getElementById(`input_cell_${data.coordinates}`)

      inputCell.classList.add('pop-cell')

      inputCell.addEventListener('animationEnd', onAnimationEnd)

      function onAnimationEnd () {
        inputCell.classList.remove('pop-cell')
      }
    })
  }
}
