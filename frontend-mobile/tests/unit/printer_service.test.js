const { splitData } = require('../../src/services/bluetooth_service')

describe('Bluetooth Chunking', () => {
  test('splits large data into 20-byte chunks', () => {
    const data = new ArrayBuffer(50)
    const chunks = splitData(data)
    expect(chunks.length).toBe(3)
    expect(chunks[0].byteLength).toBe(20)
    expect(chunks[2].byteLength).toBe(10)
  })
})
