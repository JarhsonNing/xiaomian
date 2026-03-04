Component({
  properties: {
    item: Object
  },
  methods: {
    updatePrice(e) {
      const newPrice = e.detail.value
      this.triggerEvent('change', { price: newPrice })
    }
  }
})
