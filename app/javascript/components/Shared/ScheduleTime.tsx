import React from 'react'
import styled  from 'styled-components'

interface Props {
  time: string
}

export const ScheduleTime: React.VFC<Props> = ({ time }) => {
  const matched = time.match(/^(.+?)\s\((.+?)\)$/) // 「01:15 - 01:40 (UTC)」みたいな文字列を想定
  const timeText = matched[1] // 01:15 - 01:40
  const timeZone = matched[2] // UTC
  return (
    <Wrapper>
      <TimeRow>
        <TimeText>{timeText}</TimeText>
        <Hr />
      </TimeRow>
      <TimeZone>{timeZone}</TimeZone>
    </Wrapper>
  )
}

const Wrapper = styled.div`
  display: flex;
  flex-direction: column;
  gap: 4px;
`

const TimeRow = styled.div`
  display: flex;
  align-items: center;
`

const TimeText = styled.p`
  font-size: 19.2px;
  flex-shrink: 0;
  margin-right: 16px;
  font-weight: 400;
`

const Hr = styled.hr`
  width: 100%;
  height: 1px;
  margin-right: 16px;
  background-color: #D6D3D0;
  border: none;
`
const TimeZone = styled.p`
  font-size: 14px;
  font-weight: bold;
  color: #706D65;
  text-align: left;
`