import { render, screen } from '@testing-library/react'
import { ProductForm } from '../ProductForm'
import { expect, test } from 'vitest'

test('renders product form', () => {
  render(<ProductForm />)
  expect(screen.getByLabelText(/Name/i)).toBeDefined()
  expect(screen.getByLabelText(/Price/i)).toBeDefined()
})
