import React, { useEffect, useState } from 'react'
import { ProductForm } from '../components/ProductForm'

export const ProductList: React.FC = () => {
  const [products, setProducts] = useState([])

  useEffect(() => {
    // Fetch products logic would go here
  }, [])

  return (
    <div>
      <h1>Product Management</h1>
      <ProductForm />
      <ul>
        {products.map((p: any) => (
          <li key={p.id}>{p.name} - {p.default_price}</li>
        ))}
      </ul>
    </div>
  )
}
