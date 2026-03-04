/**
 * Bluetooth and ESC/POS chunking logic
 */
export const splitData = (data) => {
  const chunks = []
  const buffer = new Uint8Array(data)
  for (let i = 0; i < buffer.length; i += 20) {
    chunks.push(buffer.slice(i, i + 20).buffer)
  }
  return chunks
}

export const printReceipt = (deviceId, serviceId, characteristicId, data) => {
  const chunks = splitData(data)
  // Recursive function to write chunks sequentially
}
