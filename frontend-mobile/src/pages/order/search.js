Page({
  data: {
    query: '',
    results: []
  },
  onInput(e) {
    const query = e.detail.value
    // Trigger backend search and handle results
  },
  selectProduct(e) {
    const product = e.currentTarget.dataset.product
    // Navigate back or add to cart
  }
})
