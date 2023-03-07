import React from 'react'
import styled from 'styled-components'

import { MessageDialog, DefinitionList } from 'smarthr-ui'
import { LanguageMap } from "./Shared"

export interface Props {
  isOpen: boolean
  handleOnClickClose: () => void
  body: BodyProps
  i18n: {
    title: string
    close: string
  }
}

interface BodyProps {
  speakers: {
    thumbnailUrl: string
    speaker: string
    username: string
    aboutSpeaker: string
    github: string | null
    twitter: string | null
  }[]
  startEndTime: string
  language: string
  description: string
  i18n: {
    speaker: string
    username: string
    aboutSpeaker: string
    startEndTime: string
    language: string
    description: string
  }
}

export const ScheduleDetail: React.VFC<Props> = (props) => {
  const { isOpen, handleOnClickClose, body, i18n } = props
  return (
    <MaxWidthMessageDialog
      title={i18n.title}
      closeText={i18n.close}
      onPressEscape={handleOnClickClose}
      onClickOverlay={handleOnClickClose}
      onClickClose={handleOnClickClose}
      isOpen={isOpen}
      description={<DialogBody {...body} />}
    />
  )
}

const MaxWidthMessageDialog = styled(MessageDialog)`
  max-width: 100%;
`

const DialogBody: React.VFC<BodyProps> = (props) => {
  const { speakers, startEndTime, language, description, i18n } = props

  return (
    <Body>
      {speakers.map((speaker, index) =>
        <React.Fragment key={index}>
          <Row>
            <FlexBox>
              <ImageBox thumbnailUrl={speaker.thumbnailUrl} />
              <Profile>
                <DefinitionList layout="double" items={[
                  {
                    term: i18n.speaker,
                    description: speaker.speaker
                  },
                  {
                    term: i18n.username,
                    description: speaker.username
                  }
                  ]} />
              </Profile>
              <Icons>
                { speaker.github ? <IconBox><a href={"https://github.com/" + speaker.github} target="_blank"><GitHubIcon /></a></IconBox> : null }
                { speaker.twitter ? <IconBox><a href={"https://twitter.com/" + speaker.twitter} target="_blank"><TwitterIcon /></a></IconBox> : null }
              </Icons>
            </FlexBox>
          </Row>
          <Row>
            <DefinitionList layout="single" items={[
              {
                term: i18n.aboutSpeaker,
                description: speaker.aboutSpeaker
              }
            ]} />
          </Row>
        </React.Fragment>
      )}
      <Row>
        <DefinitionList layout="double" items={[
          {
            term: i18n.startEndTime,
            description: startEndTime
          },
          {
            term: i18n.language,
            description: LanguageMap[language]
          },
        ]} />
      </Row>
      <Row>
        <DefinitionList layout="single" items={[
          {
            term: i18n.description,
            description: description
          }
        ]} />
      </Row>
    </Body>
  )
}

const Body = styled.div`
  width: 848px;
`

const FlexBox = styled.div`
  display: flex;
  align-items: flex-end;
  width: 100%;
`

const Row = styled.div`
  margin: 24px 0;
`

const Profile = styled.div`
  margin: 0 16px;
  width: 528px;
`

const Icons = styled.div`
  display: flex;
  align-items: center;
  width: 246px;
`

const ImageBox = styled.div`
  width: 59px;
  height: 59px;
  background-image: url("${props => props.thumbnailUrl}");
  background-size: cover;
  border-radius: 2px;
`

const IconBox = styled.div`
  margin-right: 8px;
`

const GitHubIcon: React.VFC<{}> = () => {
  return (
    <svg width="24" height="25" viewBox="0 0 24 25" fill="none" xmlns="http://www.w3.org/2000/svg">
      <path
        d="M21.4286 0.5H2.57143C1.15179 0.5 0 1.65179 0 3.07143V21.9286C0 23.3482 1.15179 24.5 2.57143 24.5H21.4286C22.8482 24.5 24 23.3482 24 21.9286V3.07143C24 1.65179 22.8482 0.5 21.4286 0.5ZM14.8554 21.0554C14.4054 21.1357 14.2393 20.8571 14.2393 20.6268C14.2393 20.3375 14.25 18.8589 14.25 17.6643C14.25 16.8286 13.9714 16.2982 13.6446 16.0196C15.6268 15.8 17.7161 15.5268 17.7161 12.1036C17.7161 11.1286 17.3679 10.6411 16.8 10.0143C16.8911 9.78393 17.1964 8.83571 16.7089 7.60357C15.9643 7.37321 14.2607 8.5625 14.2607 8.5625C13.5536 8.36429 12.7875 8.2625 12.0321 8.2625C11.2768 8.2625 10.5107 8.36429 9.80357 8.5625C9.80357 8.5625 8.1 7.37321 7.35536 7.60357C6.86786 8.83036 7.16786 9.77857 7.26429 10.0143C6.69643 10.6411 6.42857 11.1286 6.42857 12.1036C6.42857 15.5107 8.42679 15.8 10.4089 16.0196C10.1518 16.25 9.92143 16.6464 9.84107 17.2143C9.33214 17.4446 8.03036 17.8411 7.25357 16.4696C6.76607 15.6232 5.8875 15.5536 5.8875 15.5536C5.01964 15.5429 5.82857 16.1 5.82857 16.1C6.40714 16.3679 6.81429 17.3964 6.81429 17.3964C7.33393 18.9875 9.81964 18.4518 9.81964 18.4518C9.81964 19.1964 9.83036 20.4071 9.83036 20.6268C9.83036 20.8571 9.66964 21.1357 9.21429 21.0554C5.67857 19.8714 3.20357 16.5071 3.20357 12.575C3.20357 7.65714 6.96429 3.92321 11.8821 3.92321C16.8 3.92321 20.7857 7.65714 20.7857 12.575C20.7911 16.5071 18.3911 19.8768 14.8554 21.0554ZM9.6 17.7821C9.49821 17.8036 9.40179 17.7607 9.39107 17.6911C9.38036 17.6107 9.45 17.5411 9.55179 17.5196C9.65357 17.5089 9.75 17.5518 9.76071 17.6214C9.77679 17.6911 9.70714 17.7607 9.6 17.7821ZM9.09107 17.7339C9.09107 17.8036 9.01071 17.8625 8.90357 17.8625C8.78571 17.8732 8.70536 17.8143 8.70536 17.7339C8.70536 17.6643 8.78571 17.6054 8.89286 17.6054C8.99464 17.5946 9.09107 17.6536 9.09107 17.7339ZM8.35714 17.675C8.33571 17.7446 8.22857 17.7768 8.1375 17.7446C8.03571 17.7232 7.96607 17.6429 7.9875 17.5732C8.00893 17.5036 8.11607 17.4714 8.20714 17.4929C8.31429 17.525 8.38393 17.6054 8.35714 17.675ZM7.69821 17.3857C7.65 17.4446 7.54821 17.4339 7.46786 17.3536C7.3875 17.2839 7.36607 17.1821 7.41964 17.1339C7.46786 17.075 7.56964 17.0857 7.65 17.1661C7.71964 17.2357 7.74643 17.3429 7.69821 17.3857ZM7.21071 16.8982C7.1625 16.9304 7.07143 16.8982 7.0125 16.8179C6.95357 16.7375 6.95357 16.6464 7.0125 16.6089C7.07143 16.5607 7.1625 16.5982 7.21071 16.6786C7.26964 16.7589 7.26964 16.8554 7.21071 16.8982ZM6.8625 16.3786C6.81429 16.4268 6.73393 16.4 6.675 16.3464C6.61607 16.2768 6.60536 16.1964 6.65357 16.1589C6.70179 16.1107 6.78214 16.1375 6.84107 16.1911C6.9 16.2607 6.91071 16.3411 6.8625 16.3786ZM6.50357 15.9821C6.48214 16.0304 6.4125 16.0411 6.35357 16.0036C6.28393 15.9714 6.25179 15.9125 6.27321 15.8643C6.29464 15.8321 6.35357 15.8161 6.42321 15.8429C6.49286 15.8804 6.525 15.9393 6.50357 15.9821Z"
        fill="#4183C4"/>
    </svg>
  )
}

const TwitterIcon: React.VFC<{}> = () => {
  return (
    <svg width="24" height="25" viewBox="0 0 24 25" fill="none" xmlns="http://www.w3.org/2000/svg">
      <path d="M21.4286 0.5H2.57143C1.15179 0.5 0 1.65179 0 3.07143V21.9286C0 23.3482 1.15179 24.5 2.57143 24.5H21.4286C22.8482 24.5 24 23.3482 24 21.9286V3.07143C24 1.65179 22.8482 0.5 21.4286 0.5ZM18.8089 9.00714C18.8196 9.15714 18.8196 9.3125 18.8196 9.4625C18.8196 14.1071 15.2839 19.4589 8.82321 19.4589C6.83036 19.4589 4.98214 18.8804 3.42857 17.8839C3.7125 17.9161 3.98571 17.9268 4.275 17.9268C5.91964 17.9268 7.43036 17.3696 8.63571 16.4268C7.09286 16.3946 5.79643 15.3821 5.35179 13.9893C5.89286 14.0696 6.38036 14.0696 6.9375 13.925C5.33036 13.5982 4.125 12.1839 4.125 10.475V10.4321C4.59107 10.6946 5.1375 10.8554 5.71071 10.8768C5.2288 10.5562 4.83374 10.1214 4.56079 9.61098C4.28784 9.10059 4.14548 8.53057 4.14643 7.95179C4.14643 7.29821 4.31786 6.69821 4.62321 6.17857C6.35357 8.31071 8.95179 9.70357 11.8661 9.85357C11.3679 7.46964 13.1518 5.53571 15.2946 5.53571C16.3071 5.53571 17.2179 5.95893 17.8607 6.64464C18.6536 6.49464 19.4143 6.2 20.0893 5.79821C19.8268 6.6125 19.275 7.29821 18.5464 7.73214C19.2536 7.65714 19.9393 7.45893 20.5714 7.18571C20.0946 7.8875 19.4946 8.50893 18.8089 9.00714Z" fill="#55ACEE"/>
    </svg>
  )
}

export default ScheduleDetail
