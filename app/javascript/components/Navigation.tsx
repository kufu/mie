import React from 'react'
import styled from 'styled-components'

import {AppNavi, Text, SmartHRLogo, FaBullhornIcon, FaCalendarAltIcon} from 'smarthr-ui'

import LocaleSelector, { Props as LocaleSelectorProps } from './LocaleSelector'

interface Props {
  current: string
  rootLink: string
  schedulesLink: string
  plansLink?: string
  locales: LocaleSelectorProps
  i18n: {
    label: string
    rootButton: string
    scheduleButton: string
    plansButton: string
    help: string
  }
}

export const Navigation: React.FC<Props> = (props) => {
  const { current, locales, i18n } = props
  return (
    <>
      <Nav>
        <Container>
          <Text weight="bold" size="L">RubyKaigi Takeout 2021</Text>
          <MarginWrapper>
            <Text>Schedule.select powerd by</Text>
          </MarginWrapper>
          <MarginWrapper>
            <SmartHRLogo width="95" height="16" fill="#00C4CC" />
          </MarginWrapper>
        </Container>
      </Nav>
      <AppNavi
        label={i18n.label}
        buttons={generateNaviButton(props, current)}
      >
        <Child><LocaleSelector {...locales} /></Child>
      </AppNavi>
    </>
  )
}

const generateNaviButton = (props: Props, current: string) => {
  const buttons = []

  buttons.push({
    children: props.i18n.rootButton,
    current: current === "",
    href: props.rootLink,
  })

  buttons.push({
    children: props.i18n.scheduleButton,
    current: current === "schedules",
    icon: FaBullhornIcon,
    href: props.schedulesLink,
  })

  if(!!props.plansLink) {
    buttons.push(
      {
        children: props.i18n.plansButton,
        current: current === "plans",
        icon: FaCalendarAltIcon,
        href: props.plansLink
      }
    )
  }

  return buttons
}

export default Navigation

const Nav = styled.nav`
  display: flex;
  align-items: center;
  flex-direction: row;
  background: #0B374D;
  height: 50px;
`

const Container = styled.div`
  display: flex;
  align-items: center;
  flex-direction: row;
  margin: 0 16px;
  color: #FFF;
`

const MarginWrapper = styled.div`
  margin-left: 8px;
`

const Child = styled.div`
  margin: 0 0 0 auto;
`