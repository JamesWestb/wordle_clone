export default {
  mounted() {
    this.handleEvent('show-text-box', (data) => {
      const textBox = document.createElement("div");
      textBox.textContent = "Not in word list";
      textBox.classList.add("py-3", "px-3", "rounded-md", "absolute", "transition-opacity", "duration-500", "opacity-0", "bg-secondary-content", "text-base-100", "font-bold", "text-sm", "mx-auto", "-translate-y-7");

      const existingElement = document.getElementById("row_0");

      console.log(existingElement)

  if (existingElement) {
    existingElement.appendChild(textBox);
  } else {
    document.body.appendChild(textBox);
  }


      setTimeout(() => {
        textBox.style.opacity = "1";
      }, 10);

      setTimeout(() => {
        textBox.style.opacity = "0";
        setTimeout(() => {
          textBox.remove();
        }, 500);
      }, 1500);
    });
  }
}

