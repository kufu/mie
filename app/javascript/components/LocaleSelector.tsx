import React, { useState } from 'react'
import styled from 'styled-components'
import { Select } from 'smarthr-ui'


export interface Props {
  current?: string
  options: Array<{ label: string, options: Option[] }>
}

type Option = {
  label: string,
  value: string,
}

export const LocaleSelector: React.VFC<Props> = (props) => {
  const [current, setCurrent] = useState<string>(props.current ? props.current : "")

  const changeLocaleHandler = (e) => {
    setCurrent(e.target.value)
    document.location.href = "?locale=" + escape(e.target.value)
  }

  return (
    <Container>
      Select Location
      <Select
        value={current}
        options={props.options}
        onChange={changeLocaleHandler}
      />
    </Container>
  )
}

const Container = styled.div`
  margin: 4px;
  display: flex;
  align-items: center;
`

export default LocaleSelector