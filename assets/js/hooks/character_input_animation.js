export default {
  mounted () {
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
