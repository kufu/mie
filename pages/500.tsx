import React from 'react'

import Errors from '../app/javascript/components/Errors'

function InternalServerErrorPage() {
  return (
    <Errors status={500} />
  )
}

export default InternalServerErrorPage
