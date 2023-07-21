export default {
  mounted() {
    this.handleEvent('animate-guess-submit', (data) => {
      const currentRow = document.getElementById(`row_${data.row}`);

      if (data.validation === 'correct' || !data.validation) {
        const childElements = Array.from(currentRow.children).filter(
          (child) => child.id !== 'info_text_box'
        );

        const cellCount = childElements.length;
        let completedFlipAnimations = 0;
        const resultObject = {};

        document.addEventListener('keydown', disableKeyboardEvents);

        function disableKeyboardEvents(event) {
          event.preventDefault();
          event.stopPropagation();
        }

        Array.from(childElements).forEach((childElement, index) => {
          setTimeout(() => {
            childElement.classList.add('flip-cell');

            const animationDuration =
              parseFloat(getComputedStyle(childElement).animationDuration) *
              1000;
            const delay = animationDuration - 200;

            function permanentBackground(parentElement, answer, index) {
              const inputCell = parentElement.firstElementChild;

              inputCell.classList.add('border-none');

              if (inputCell.value.toLowerCase() === answer[index]) {
                return 'bg-correct-index';
              } else if (answer.includes(inputCell.value.toLowerCase())) {
                return 'bg-incorrect-index';
              } else {
                return 'bg-incorrect-guess';
              }
            }

            const endFlipAnimation = () => {
              childElement.classList.remove('flip-cell');

              const key = `${data.row}-${index}`;

              resultObject[key] = permanentBackground(
                childElement,
                data.answer,
                index
              );
              completedFlipAnimations++;

              if (completedFlipAnimations === cellCount) {
                this.pushEvent('background-change', resultObject);
                document.removeEventListener('keydown', disableKeyboardEvents);
              }
            };

            childElement.addEventListener('animationend', endFlipAnimation);

            setTimeout(() => {
              childElement.classList.add(
                permanentBackground(childElement, data.answer, index)
              );
            }, delay);
          }, index * 350);
        });
      } else {
        currentRow.classList.add('shake-element');

        currentRow.addEventListener('animationend', removeShake);

        function removeShake() {
          currentRow.classList.remove('shake-element');
        }
      }
    });
  },
};
