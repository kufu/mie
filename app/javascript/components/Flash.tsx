import React, { useState } from 'react'
import { FlashMessage } from 'smarthr-ui'

interface Props {
  message: string
  type: string
}

export const Flash: React.VFC<Props> = (props) => {
  console.log(props)
  const [visible, setVisible] = useState(true)

  return (
    <FlashMessage type={props.type} text={props.message} visible={visible} onClose={() => { setVisible(false) }} />
  )
}

export default Flash