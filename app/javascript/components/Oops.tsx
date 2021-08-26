import React from 'react'
import styled, {css} from 'styled-components'
import {Heading} from "smarthr-ui";

interface Props {
  title: string
  description?: string
  noBorder?: boolean
}

export const Oops: React.VFC<Props> = (props) => {
  const { title, description, children, noBorder } = props
  return (
    <Container noBorder={noBorder}>
      <Image />
      <TextArea>
        <MarginWrapper>
          <Heading type="screenTitle">{title}</Heading>
        </MarginWrapper>
        {description ?
          <MarginWrapper>
            {description}
          </MarginWrapper>
          : null }
        {children ?
          <MarginWrapper>
            {children}
          </MarginWrapper>
          : null }
      </TextArea>
    </Container>
  )
}

const Container = styled.div<{noBorder: boolean}>`
  display: flex;
  align-items: center;
  justify-content: center;
  
  width: 1120px;
  height: 275px;

  ${props => props.noBorder ? null : css`
    border: 1px solid #D6D3D0;
    box-sizing: border-box;
  `}
`

const Image = styled.div`
  height: 104px;
  width: 102px;
  background-image: url('/assets/2021/rubykaigi.png');
  background-size: cover;
`

const TextArea = styled.div`
  margin-left: 16px;
`

const MarginWrapper = styled.div`
  margin-bottom: 8px;
`

export default Oops