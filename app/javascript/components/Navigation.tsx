import React from 'react'
import styled from 'styled-components'

import { Container, Layout, Logo, Link, Text } from './Layout'
import { FaQuestionCircleIcon, AppNavi } from 'smarthr-ui'

import LocaleSelector, { Props as LocaleSelectorProps } from './LocaleSelector'
import { interaction, palette, size } from './Constants'
const { BRAND, WHITE, hoverColor } = palette
const { space } = size
const { hover } = interaction

interface Props {
  current: string
  schedulesLink: string
  plansLink: string
  locales: LocaleSelectorProps
  i18n: {
    label: string
    scheduleButton: string
    plansButton: string
    help: string
  }
}

export const Navigation: React.FC<Props> = (props) => {
  const { current, schedulesLink, plansLink, locales, i18n } = props
  return (
    <>
      <Nav>
        <Container alignItems="center" justifyContent="space-between">
          <Layout>
            <Inner alignContent="stretch" justifyContent="space-between">
              <LogoLayout alignSelf="center">
                <a href={"#"}>
                  <Logo />
                </a>
              </LogoLayout>
            </Inner>
          </Layout>
          <Layout>
            <Inner alignContent="stretch" alignItems="center">
              <Layout alignSelf="center" height="50px">
                <Link color={WHITE} url={"#"} textDecoration="none" target="_blank">
                  <HoverHeaderLabel>
                    <Container alignItems="center" justifyContent="space-between">
                      <FaQuestionCircleIcon size={16} color={WHITE} />
                      <TextLabel>{i18n.help}</TextLabel>
                    </Container>
                  </HoverHeaderLabel>
                </Link>
              </Layout>
            </Inner>
          </Layout>
        </Container>
      </Nav>
      <AppNavi
        label={i18n.label}
        buttons={
          [
            {
              children: i18n.scheduleButton,
              current: current === "schedules",
              href: schedulesLink,
            },
            {
              children: i18n.plansButton,
              current: current === "plans",
              href: plansLink
            },
          ]
        }
      >
        <Child><LocaleSelector {...locales} /></Child>
      </AppNavi>
    </>
  )
}

export default Navigation

const Nav = styled.nav`
  background-color: ${BRAND};
  padding: 0 ${space.S};
`

const Inner = styled(Container)`
  height: 50px;
`

const LogoLayout = styled(Layout)`
  margin-right: ${space.XS};
  height: 27px;
`

const HeaderLabel = styled.div`
  padding: ${space.XXS} ${space.XXS};
  height: 50px;
  width: 100%;
  background-color: ${BRAND};
  color: ${WHITE};
  box-sizing: border-box;
`

const HoverHeaderLabel = styled(HeaderLabel)`
  transition: all ${hover.animation};
  &:hover {
    background-color: ${hoverColor(BRAND)};
  }
`

const TextLabel = styled.span`
  margin: 0 0 0 ${space.XXS};
`

const Child = styled.p`
  margin: 0 0 0 auto;
`