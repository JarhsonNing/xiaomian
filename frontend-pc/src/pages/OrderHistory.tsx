import React, { useEffect, useState } from 'react'

export const OrderHistory: React.FC = () => {
  const [orders, setOrders] = useState([])

  return (
    <div>
      <h1>Order History</h1>
      <table>
        <thead>
          <tr>
            <th>Order ID</th>
            <th>Customer</th>
            <th>Total</th>
            <th>Date</th>
          </tr>
        </thead>
        <tbody>
          {orders.map((o: any) => (
            <tr key={o.id}>
              <td>{o.id}</td>
              <td>{o.customer_id}</td>
              <td>{o.total_amount}</td>
              <td>{new Date(o.created_at).toLocaleDateString()}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  )
}
