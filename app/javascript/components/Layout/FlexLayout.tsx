import React from 'react'
import styled, { css } from 'styled-components'

type Direction = 'row' | 'row-reverse' | 'column' | 'column-reverse'
type Wrap = 'nowrap' | 'wrap' | 'wrap-reverse'
type JustifyContent = 'flex-start' | 'flex-end' | 'center' | 'space-between' | 'space-around'
type AlignItems = 'flex-start' | 'flex-end' | 'center' | 'baseline' | 'stretch'
type AlignContent = 'flex-start' | 'flex-end' | 'center' | 'stretch' | 'space-between' | 'space-around'

interface ContainerProps extends React.Props<HTMLDivElement> {
  inline?: boolean
  alignItems?: AlignItems
  alignContent?: AlignContent
  flexDirection?: Direction
  flexWrap?: Wrap
  justifyContent?: JustifyContent
  className?: string
}

interface LayoutProps extends React.Props<HTMLDivElement> {
  order?: number
  alignSelf?: AlignItems
  flexGrow?: number
  flexShrink?: number
  flexBasis?: number | string
  width?: number | string
  height?: number | string
  className?: string
}

const containerStyle = (props: ContainerProps) => css`
  display: ${props.inline ? 'inline-flex' : 'flex'};
  align-items: ${props.alignItems};
  align-content: ${props.alignContent};
  flex-direction: ${props.flexDirection};
  flex-wrap: ${props.flexWrap};
  justify-content: ${props.justifyContent};
`

const ContainerComponent = styled.div`
  ${containerStyle};
`

export const Container: React.FC<ContainerProps> = (props: ContainerProps) => (
  <ContainerComponent
    inline={props.inline || false}
    alignItems={props.alignItems || 'stretch'}
    alignContent={props.alignContent || 'stretch'}
    flexDirection={props.flexDirection || 'row'}
    flexWrap={props.flexWrap || 'nowrap'}
    justifyContent={props.justifyContent || 'flex-start'}
    className={props.className}
  >
    {props.children}
  </ContainerComponent>
)

const layoutStyle = (props: LayoutProps) => css`
  order: ${props.order};
  flex-grow: ${props.flexGrow};
  flex-shrink: ${props.flexShrink};
  flex-basis: ${props.flexBasis};
  align-self: ${props.alignSelf};
  width: ${props.width};
  height: ${props.height};
`

const LayoutComponent = styled.div`
  ${layoutStyle};
`

export const Layout: React.FC<LayoutProps> = (props: LayoutProps) => (
  <LayoutComponent
    alignSelf={props.alignSelf || 'flex-start'}
    flexGrow={props.flexGrow || 0}
    flexShrink={props.flexShrink || 1}
    flexBasis={props.flexBasis || 'auto'}
    width={props.width}
    height={props.height}
    order={props.order || 0}
    className={props.className}
  >
    {props.children}
  </LayoutComponent>
)