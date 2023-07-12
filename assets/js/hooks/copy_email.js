export default {
  mounted() {
    this.el.addEventListener('click', (e) => {
      const email = e.target.textContent;
      navigator.clipboard.writeText(email);
    });
  },
};
