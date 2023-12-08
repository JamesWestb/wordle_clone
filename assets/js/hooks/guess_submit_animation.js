const guessSubmitAnimation = (getBackgroundClass, disableKeydown) => ({
  mounted() {
    const eventRelay = this;

    let completedFlipAnimations = 0;
    let accumulatedBackgrounds = {};

    function flipIndividualCell(inputCell, index, solution) {
      const updatedBackground = getBackgroundClass(inputCell, solution, index);
      const cellCount = 5;
      const updateBackgroundColorDelay = 300;

      setTimeout(() => {
        inputCell.classList.add('border-none');
        inputCell.classList.add(updatedBackground);

        const endFlipAnimation = () => {
          inputCell.classList.remove('flip-cell');

          accumulatedBackgrounds[inputCell.id] = updatedBackground;

          completedFlipAnimations++;

          if (completedFlipAnimations === cellCount) {
            completedFlipAnimations = 0;
            eventRelay.pushEvent('background-change', accumulatedBackgrounds);
            document.removeEventListener('keydown', disableKeydown);
          }
        };

        inputCell.addEventListener('animationend', endFlipAnimation);
      }, updateBackgroundColorDelay);
    }

    function flipAllCellsInRow(inputCells, solution) {
      Array.from(inputCells).forEach((inputCell, index) => {
        setTimeout(() => {
          inputCell.classList.add('flip-cell');


          flipIndividualCell(inputCell, index, solution);

        }, index * 350);
      });
    }

    eventRelay.handleEvent('animate-guess-submit', (data) => {
      const currentRow = document.getElementById(`input_row_${data.row}`);

      if (data.validation === 'correct' || !data.validation) {
        document.addEventListener('keydown', disableKeydown);

        const inputCells = Array.from(currentRow.children).filter((child) => child.id !== 'info_text_box');

        flipAllCellsInRow(inputCells, data.solution);
      } else {
        currentRow.classList.add('shake-element');

        currentRow.addEventListener('animationend', () => {currentRow.classList.remove('shake-element')});
      }
    });
  },
})

export default guessSubmitAnimation;
