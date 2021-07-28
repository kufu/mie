import React from 'react'
import styled from 'styled-components'

import { Base, LineClamp } from 'smarthr-ui'
import { Text } from './Layout'
import {palette} from "./Constants";
const { BRAND, WHITE } = palette

type Language = "en" | "ja"

export interface Props {
  title: string
  description: string
  speakerName: string
  thumbnailUrl: string
  language: Language
}

export const ScheduleCard: React.VFC<Props> = (props) => {
  const { title, description, speakerName, thumbnailUrl, language} = props
  return (
    <Card>
      <Container>
        <Schedule>
          <h1>{title}</h1>
          <LineClamp maxLines={6} withTooltip>{description}</LineClamp>
        </Schedule>
        <Profile>
          <Thumbnail src={thumbnailUrl} />
          <Text>{speakerName}</Text>
          <Language>{language}</Language>
        </Profile>
      </Container>
    </Card>
  )
}

const Card = styled(Base)`
  width: 480px;
  padding: 16px;
`

const Container = styled.div`
  display: flex;
  justify-content: space-between;
`

const Schedule = styled.div`
`

const Profile = styled.div`
  padding: 8px;
  width: 78px;
  display: flex;
  flex-direction: column;
`

const Language = styled.div`
  padding: 2px;
  width: 100%;
  height: 32px;
  background-color: ${BRAND};
  font-color: ${WHITE}
  font-weight: bold;
  text-align: center;
`

const Thumbnail = styled.img`
  height: 64px;
  width: 64px;
  border-radius: 50%;
`

export default ScheduleCard
