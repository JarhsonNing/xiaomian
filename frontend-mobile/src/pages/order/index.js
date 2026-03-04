Page({
  data: {
    customers: [],
    selectedCustomer: null,
    cart: []
  },
  onLoad() {
    // Fetch customers logic
  },
  selectCustomer(e) {
    const customer = e.currentTarget.dataset.customer
    this.setData({ selectedCustomer: customer })
  },
  confirmOrder() {
    // API call to backend/v1/orders
  }
})
