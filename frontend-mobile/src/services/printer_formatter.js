/**
 * Simple ESC/POS formatter for thermal printers
 */
export const formatReceipt = (order) => {
  const esc = '\x1B'
  const gs = '\x1D'
  const init = esc + '@'
  const boldOn = esc + 'E\x01'
  const boldOff = esc + 'E\x00'
  const center = esc + 'a\x01'
  const left = esc + 'a\x00'
  
  let lines = []
  lines.push(init)
  lines.push(center + boldOn + 'Xiao Mian Store' + boldOff)
  lines.push('
')
  lines.push(left + 'Date: ' + new Date(order.createdAt).toLocaleString())
  lines.push('Customer: ' + order.customerName)
  lines.push('-'.repeat(32))
  
  order.items.forEach(item => {
    const name = item.snapshotName.padEnd(20)
    const price = item.snapshotPrice.toFixed(2).padStart(12)
    lines.push(name + price)
    lines.push(`  Qty: ${item.quantity}
`)
  })
  
  lines.push('-'.repeat(32))
  lines.push(boldOn + 'TOTAL: ' + order.totalAmount.toFixed(2).padStart(25) + boldOff)
  lines.push('



') // Cut space
  
  return lines.join('
')
}
