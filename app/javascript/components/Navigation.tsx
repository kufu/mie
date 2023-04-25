import React from 'react'
import styled from 'styled-components'

import {AppNavi, Text, SmartHRLogo, FaBullhornIcon, FaCalendarAltIcon, ThemeProvider} from 'smarthr-ui'

import LocaleSelector, { Props as LocaleSelectorProps } from './LocaleSelector'
import createdTheme from './Constants'

interface Props {
  current: string
  rootLink: string
  schedulesLink: string
  plansLink?: string
  mainColor: string
  logoImage: string
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
  const { current, locales, mainColor, logoImage, i18n } = props

  const theme = createdTheme
  theme.color.MAIN = mainColor

  return (
    <ThemeProvider theme={theme}>
      <Nav theme={theme}>
        <Container>
          <img height={"24px"} src={logoImage} />
          <CenteredWrapper>
            <MarginWrapper>
              <Text>Schedule.select</Text>
            </MarginWrapper>
            <PoweredByWrapper>
              <Text size="S">powered by</Text>
              <SmartHRLogo width="110px" height="20px" fill="white" />
            </PoweredByWrapper>
          </CenteredWrapper>
        </Container>
      </Nav>
      <AppNavi
        label={i18n.label}
        buttons={generateNaviButton(props, current)}
      >
        <Child><LocaleSelector {...locales} /></Child>
      </AppNavi>
    </ThemeProvider>
  )
}

const generateNaviButton = (props: Props, current: string) => {
  const buttons = []

  buttons.push({
    children: props.i18n.rootButton,
    current: current === null,
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
  background: ${p => p.theme.color.MAIN};
  height: 50px;
`

const Container = styled.div`
  display: flex;
  align-items: center;
  flex-direction: row;
  margin: 0 16px;
  color: #FFF;
`

const CenteredWrapper = styled.div`
  display: flex;
  align-items: center;
`

const MarginWrapper = styled.div`
  display: flex;
  align-items: center;
  gap: 2px;
  margin-left: 8px;
`

const PoweredByWrapper = styled.div`
  display: flex;
  align-items: center;
  gap: 2px;
  margin-left: 12px;
  margin-bottom: 2px;
`

const Child = styled.div`
  margin: 0 0 0 auto;
`
