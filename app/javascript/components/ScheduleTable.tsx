import React, { useState } from 'react'
import styled from 'styled-components'

import { Base, TabBar, TabItem, Table, Body, Head, Row, Cell } from 'smarthr-ui'
import { ScheduleCard, Props as CardProps } from './ScheduleCard'

type GroupedSchedules = { [key: string]: ScheduleTable}
type ScheduleTable = {trackList: TrackList, rows: Row[]}
type TrackList = string[]
type Row = { time: string, schedules: Array<CardProps | null> }

interface Props {
  dates: string[]
  current: string
  groupedSchedules: GroupedSchedules
}

export const ScheduleTable: React.VFC<{Props}> = (props) => {
  const { groupedSchedules, current } = props

  const [currentKey, setCurrentDate] = useState(current)

  return (
    <Container>
      <TabBar>
        {Object.keys(groupedSchedules).map(date => {
          return <TabItem id={date} onClick={() => {setCurrentDate(date)}} selected={date === currentKey}>{date}</TabItem>
        })}
      </TabBar>
      <Table>
        <Head>
          <Row>
            <Cell>start ... end</Cell>
          {groupedSchedules[currentKey].trackList.map(track => <Cell>{track}</Cell>)}
          </Row>
        </Head>
        <Body>
          {groupedSchedules[currentKey].rows.map(row => {
            return (
              <Row>
                <Cell>{row.time}</Cell>
                {row.schedules.map(row => row === null ? <Cell /> : <Cell><ScheduleCard {...row} /></Cell>)}
              </Row>
            )
          })}
        </Body>
      </Table>
    </Container>
  )
}

const Container = styled(Base)`
  margin: 48px 80px;
`

export default ScheduleTable
