const infoTextAnimation = (guessSubmitAnimation) => ({
  mounted () {
    this.handleEvent('show-text-box', data => {
      validation = data.validation
      const textBox = document.createElement('div')
      textBox.textContent = window.validationMessageKey[validation]
      textBox.classList.add(
        'py-3',
        'px-3',
        'rounded-md',
        'absolute',
        'transition-opacity',
        'duration-500',
        'opacity-0',
        'bg-secondary-content',
        'text-base-100',
        'font-bold',
        'text-sm',
        'mx-auto',
        '-translate-y-7',
        'animate-none'
      )
      textBox.id = 'info_text_box'

      const topRow = document.getElementById('row_0')

      if (data.validation) {
        topRow.appendChild(textBox)
      }

      guessSubmitAnimation(data.row, data.validation, this, data.answer)

      setTimeout(() => {
        textBox.style.opacity = '1'
      }, 0.8)

      setTimeout(() => {
        textBox.style.opacity = '0'
        setTimeout(() => {
          textBox.remove()
        }, 250)
      }, 1500)
    })
  }
})

export default infoTextAnimation
