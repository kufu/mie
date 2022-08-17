import React from 'react'
import styled from 'styled-components'

import {SmartHRLogo as shrSmartHRLogo, Text, TextLink, Heading, LineUp} from 'smarthr-ui'

interface Props {
  intro: string
}

export const Top: React.VFC<Props> = (props) => {
  const { intro } = props
  return (
    <Container>
      <TitleBox>
        <div><Title /></div>
        <LineUp gap={1} vAlign="center">
          Schedule.select
          <PoweredBy>
            <Text>powered by</Text>
            <SmartHRLogo width={95} height={16} fill="brand" />
          </PoweredBy>
        </LineUp>
      </TitleBox>
      <ColorLines>
        <ColorLine color="#BF4545" />
        <ColorLine color="#B8A562" />
        <ColorLine color="#755B8E" />
      </ColorLines>
      <IntroArea>
        { intro.split("\n").map(line => <TopText>{line}</TopText> )}
      </IntroArea>
      <LinkArea>
        <p><TextLink href={"https://rubykaigi.org/2021-takeout"} target="_blank">The official website of RubyKaigi 2021</TextLink></p>
        <p><TextLink href={"https://twitter.com/rubykaigi"} target="_blank"><TwitterLogo /> Twitter</TextLink></p>
        <p><TextLink href={"https://smarthr.co.jp/"} target="_blank">SmartHR</TextLink></p>
      </LinkArea>
      <SmartHRUIArea>
        <Text>This website is </Text><SmartHRUIButton>(almost) Made with <TextLink href={"https://www.figma.com/community/file/978607227374353992"} target="_blank">SmartHR UI</TextLink></SmartHRUIButton>
      </SmartHRUIArea>
    </Container>
  )
}

const Container = styled.div`
  margin 80px 0 0 140px;
  display: flex;
  flex-direction: column;
  gap: 16px;
`

const TitleBox = styled.div`
  color: #2C2C31;
  font-style: normal;
  font-weight: normal;
  font-size: 24px;
  line-height: 24px;
  display: flex;
  flex-direction: column;
  gap: 8px;
`

const ColorLines = styled.div`
  display: flex;
  margin: 16px 0;
`

const ColorLine = styled.div`
  background-color: ${props => props.color};
  width: 100px;
  height: 4px;
`

const PoweredBy = styled.div`
  display: flex;
  flex-direction: row;
  align-items: center;
  gap: 2px;
`

const SmartHRLogo = styled(shrSmartHRLogo)`
  margin-bottom: 12px;
`

const IntroArea = styled.div`
  width: 600px;
  word-break: keep-all;
  line-break: strict;
  word-wrap: break-word;
  overflow-wrap: break-word;
  margin-top: 24px;
  margin-bottom: 24px;
`

const Intro = styled(Text)`
`

const LinkArea = styled.div`
  margin-bottom: 16px;
  line-height: 200%;
`

const SmartHRUIArea = styled.div`
  display: flex;
  align-items: center;
`

const SmartHRUIButton = styled.div`
  margin-left: 8px;
  padding: 12px;
  background: #FFFFFF;
  box-shadow: 0px 1px 2px rgba(0, 0, 0, 0.24);
  border-radius: 6px;
`

const Title = styled.div`
  background-image: url('/static/rubykaigi2022_large.svg');
  width: 232px;
  height: 32px;
`

const TwitterLogo: React.VFC<{}> = () => {
  return (
    <svg width="19" height="17" viewBox="0 0 19 17" fill="none" xmlns="http://www.w3.org/2000/svg">
      <path d="M16.4061 5.34405C16.4177 5.50648 16.4177 5.66894 16.4177 5.83137C16.4177 10.7857 12.6469 16.4942 5.75492 16.4942C3.63162 16.4942 1.65919 15.8792 0 14.8118C0.30168 14.8466 0.591717 14.8582 0.905004 14.8582C2.65698 14.8582 4.26977 14.2665 5.55766 13.2571C3.91009 13.2223 2.52937 12.1432 2.05365 10.6581C2.28572 10.6929 2.51776 10.7161 2.76144 10.7161C3.09791 10.7161 3.43441 10.6696 3.74766 10.5885C2.03047 10.2404 0.742539 8.73203 0.742539 6.91041V6.86402C1.24143 7.14249 1.82161 7.31652 2.43651 7.3397C1.42708 6.66673 0.765753 5.51809 0.765753 4.21858C0.765753 3.52244 0.951361 2.88429 1.27626 2.32736C3.12108 4.60148 5.89413 6.08659 9.00361 6.24905C8.94561 5.97059 8.91079 5.68055 8.91079 5.39048C8.91079 3.32519 10.5816 1.64282 12.6584 1.64282C13.7375 1.64282 14.7121 2.09532 15.3967 2.82629C16.2436 2.66386 17.0558 2.35058 17.7752 1.92129C17.4967 2.79151 16.905 3.52247 16.1276 3.98655C16.8818 3.90537 17.6128 3.69647 18.2857 3.40644C17.7753 4.14897 17.1371 4.8103 16.4061 5.34405Z" fill="#0071C1"/>
    </svg>
  )
}

const TopText = styled(Text)`
  color: #2C2C31;
  line-height: 200%;
`
export default Top