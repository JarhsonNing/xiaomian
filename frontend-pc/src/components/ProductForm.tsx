import React from 'react'

export const ProductForm: React.FC = () => {
  return (
    <form>
      <div>
        <label htmlFor="name">Name</label>
        <input id="name" type="text" />
      </div>
      <div>
        <label htmlFor="price">Price</label>
        <input id="price" type="number" />
      </div>
      <button type="submit">Submit</button>
    </form>
  )
}
