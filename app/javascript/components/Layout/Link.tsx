
import React, { ReactNode } from 'react'
import styled, { css } from 'styled-components'

import { palette } from '../Constants'
const { TEXT_LINK, hoverColor: createHoverColor } = palette

type Target = '_blank' | '_self' | '_new'

interface Props {
  onClick?: (e?: any) => void
  url?: string
  color?: string
  hoverColor?: string
  children: string | ReactNode
  target?: Target
  textDecoration?: string
}

export const Link: React.FC<Props> = ({
                                        children,
                                        onClick,
                                        url,
                                        color = TEXT_LINK,
                                        hoverColor = createHoverColor(TEXT_LINK),
                                        target = '_self',
                                        textDecoration = '',
                                      }: Props) => {
  return (
    <StyledNativeLink
      onClick={onClick}
      href={url}
      color={color}
      hovercolor={hoverColor}
      textDecoration={textDecoration}
      target={target}
      rel="noopener noreferer"
    >
      {children}
    </StyledNativeLink>
  )
}

interface StyledLinkProps {
  color?: string
  hovercolor?: string
  textDecoration?: string
}

const linkStyle = ({ color, hovercolor, textDecoration }: StyledLinkProps) => css`
  text-decoration: ${textDecoration};
  color: ${color};
  &:active,
  &:hover {
    color: ${hovercolor};
    text-decoration: ${textDecoration !== '' ? textDecoration : 'underline'};
  }
`

const StyledNativeLink = styled.a`
  ${({ color, hovercolor, textDecoration }: StyledLinkProps) => linkStyle({ color, hovercolor, textDecoration })}
`