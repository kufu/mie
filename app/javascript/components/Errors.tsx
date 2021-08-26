import React, { useState } from 'react'
import styled from 'styled-components'
import Oops from "./Oops";

interface Props {
  title: string
  description: string
}

export const Errors: React.VFC<Props> = (props) => {
  return (
    <Container>
      <Oops title={props.title} description={props.description} noBorder={true} />
    </Container>
  )
}

const Container = styled.div`
  width: 100%;
  height: 90vh;
  display: flex;
  align-items: center;
  justify-content: center;
`

export default Errors