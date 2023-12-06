const guessSubmitAnimation = (getBackgroundClass, disableKeydown) => ({
  mounted() {
    this.handleEvent('animate-guess-submit', (data) => {
      const currentRow = document.getElementById(`input_row_${data.row}`);
      const updateBackgroundDelay = 300;

      if (data.validation === 'correct' || !data.validation) {
        document.addEventListener('keydown', disableKeydown);

        const inputCells = Array.from(currentRow.children).filter((child) => child.id !== 'info_text_box');
        const cellCount = inputCells.length;
        const accumulatedBackgrounds = {};
        let completedFlipAnimations = 0;

        Array.from(inputCells).forEach((inputCell, index) => {
          setTimeout(() => {
            inputCell.classList.add('flip-cell');

            const updatedBackground = getBackgroundClass(inputCell, data.solution, index);

            setTimeout(() => {
              inputCell.classList.add('border-none');
              inputCell.classList.add(updatedBackground);

              const endFlipAnimation = () => {
                inputCell.classList.remove('flip-cell');

                accumulatedBackgrounds[inputCell.id] = updatedBackground;

                completedFlipAnimations++;

                if (completedFlipAnimations === cellCount) {
                  this.pushEvent('background-change', accumulatedBackgrounds);
                  document.removeEventListener('keydown', disableKeydown);
                }
              };

              inputCell.addEventListener('animationend', endFlipAnimation);

            }, updateBackgroundDelay);
          }, index * 350);
        });
      } else {
        currentRow.classList.add('shake-element');

        currentRow.addEventListener('animationend', () => {currentRow.classList.remove('shake-element')});
      }
    });
  },
})

export default guessSubmitAnimation;

