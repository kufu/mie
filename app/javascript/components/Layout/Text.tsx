import React from 'react'
import styled, { css } from 'styled-components'

interface Props extends React.Props<HTMLParagraphElement> {
  height?: string | number
  size?: 'xs' | 's' | 'm' | 'l' | 'xl' | 'xxl'
  color?: string
  bold?: boolean
  inline?: boolean
  ellipsis?: boolean
  align?: string
  whiteSpace?: string
  children: React.ReactNode
}

const font = {
  xxl: '22px',
  xl: '20px',
  l: '16px',
  m: '14px',
  s: '12px',
  xs: '10px',
}

export const Text: React.FC<Props> = ({
                                        height = '100%',
                                        size = 'm',
                                        color,
                                        bold,
                                        inline,
                                        ellipsis,
                                        align,
                                        whiteSpace,
                                        children,
                                      }: Props) => (
  <StyledText
    height={height}
    size={size}
    color={color}
    bold={bold}
    inline={inline}
    ellipsis={ellipsis}
    align={align}
    whiteSpace={whiteSpace}
  >
    {children}
  </StyledText>
)

const StyledText = styled.div`
  margin: 0;
  ${({ height, size = 'm', bold, inline, color, ellipsis, align, whiteSpace }: Props) => css`
    height: ${typeof height === 'number' ? height + 'px' : height};
    font-size: ${font[size]};
    font-weight: ${bold ? 'bold' : 'normal'};
    text-align: ${align ? align : 'start'};
    display: ${inline ? 'inline' : 'block'};
    color: ${color ? color : "#000"};
    white-space: ${whiteSpace ? whiteSpace : 'normal'};
    ${ellipsis
  ? `
      display: inline-block;
      text-overflow: ellipsis;
      overflow: hidden;
      white-space: nowrap;
      width: 95%;
    `
  : ''}
  `};
`