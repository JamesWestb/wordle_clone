export default {
  mounted () {
    this.handleEvent('animate-input-cell', data => {
      const inputCell = document.getElementById(`input_cell_${data.coordinates}`)

      inputCell.classList.add('pop-cell')

      inputCell.addEventListener('animationend', () => {inputCell.classList.remove('pop-cell')})
    })
  }
}
