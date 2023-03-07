import React, { useState } from 'react'
import styled from 'styled-components'
import { LineUp, Select, Heading } from 'smarthr-ui'


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
    <LineUp as="label" gap={0.5} vAlign="center">
      <Heading type="subSubBlockTitle">{props.i18n.label}</Heading>
      <ResizedSelect
        value={current}
        options={props.options}
        onChange={changeLocaleHandler}
      />
    </LineUp>
  );
};

const ResizedSelect = styled(Select)`
  height: 30px !important;
  select {
    padding: 3px 8px;
    min-height: 30px;
  }
`

export default LocaleSelector
