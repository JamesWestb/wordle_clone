export default {
  mounted () {
    this.handleEvent('animate-validation-text', data => {
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
        'bg-slate-100',
        'text-gray-900',
        'font-bold',
        'text-sm',
        '-translate-y-7',
        'animate-none'
      )
      textBox.id = 'info_text_box'

      const topRow = document.getElementById('input_row_0')

      if (data.validation) {
        topRow.appendChild(textBox)
      }

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
}
