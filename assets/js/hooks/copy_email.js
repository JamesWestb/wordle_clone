export default {
  mounted() {
    this.el.addEventListener('click', (_) => {
      const email = this.el.dataset.contactEmail;
      navigator.clipboard.writeText(email);
    });
  },
};
