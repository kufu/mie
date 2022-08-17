import React from 'react'
import styled from 'styled-components'
import { useTranslation } from "next-export-i18n"

import {AppNavi, Text, SmartHRLogo, FaBullhornIcon, FaCalendarAltIcon, ThemeProvider} from 'smarthr-ui'

import LocaleSelector, { Props as LocaleSelectorProps } from './LocaleSelector'
import createdTheme from './Constants'

interface Props {
  current: string
  rootLink: string
  schedulesLink: string
  plansLink?: string
  locales: LocaleSelectorProps
}

export const Navigation: React.FC<Props> = (props) => {
  const { t } =   useTranslation()
  const { current, locales } = props

  return (
    <ThemeProvider theme={createdTheme}>
      <Nav>
        <Container>
          <RubyKaigiLogo />
          <CenteredWrapper>
            <MarginWrapper>
              <Text>Schedule.select</Text>
            </MarginWrapper>
            <PoweredByWrapper>
              <Text size="S">powered by</Text>
              <Logo />
            </PoweredByWrapper>
          </CenteredWrapper>
        </Container>
      </Nav>
      <AppNavi
        buttons={generateNaviButton(props, current)}
      >
        <Child><LocaleSelector {...locales} /></Child>
      </AppNavi>
    </ThemeProvider>
  )
}

const generateNaviButton = (props: Props, current: string) => {
  const { t } = useTranslation()
  const buttons = []

  buttons.push({
    children: t("nav.root"),
    current: current === '/2022',
    href: props.rootLink,
  })

  buttons.push({
    children: t("nav.schedule"),
    current: current === "/2022/schedules",
    icon: FaBullhornIcon,
    href: props.schedulesLink,
  })

  if(!!props.plansLink) {
    buttons.push(
      {
        children: t("nav.plan"),
        current: current.startsWith("/2022/plans"),
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
  background: #BF4545;
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
`

const Logo = styled.div`
  background-image: url('/static/logo.svg');
  width: 94.83px;
  height: 17px;
  margin: 0 0 2px 8px;
`

const Child = styled.div`
  margin: 0 0 0 auto;
`

const RubyKaigiLogo = styled.div`
  background-image: url('/static/rubykaigi2022.svg');
  width: 138px;
  height: 19px;
`