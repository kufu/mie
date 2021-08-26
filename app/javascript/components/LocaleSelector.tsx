import React, { useState } from 'react'
import styled from 'styled-components'
import { Select } from 'smarthr-ui'


export interface Props {
  i18n: { label: string }
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
      {props.i18n.label}
      <ResizedSelect
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

const ResizedSelect = styled(Select)`
  height: 30px !important;
  select {
    padding: 3px 8px;
  }
`

export default LocaleSelector