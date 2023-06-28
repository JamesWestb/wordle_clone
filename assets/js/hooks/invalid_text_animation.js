export default {
  mounted () {
    this.handleEvent('show-text-box', data => {
      const textBox = document.createElement('div')
      textBox.textContent = data.message
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

      const topRow = document.getElementById('row_0')
      const currentRow = document.getElementById(`row_${data.row}`)

      topRow.appendChild(textBox)

      currentRow.classList.add('shake-element')
      textBox.classList.add('no-shake')

      currentRow.addEventListener('animationend', onAnimationEnd)

      function onAnimationEnd () {
        currentRow.classList.remove('shake-element')
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
