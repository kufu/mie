import React, { useState } from 'react'
import styled from 'styled-components'

import { Base, TabBar, TabItem, Table, Body, Head, Row, Cell } from 'smarthr-ui'
import { ScheduleCard, Props as CardProps } from './ScheduleCard'

type GroupedSchedules = { [key: string]: ScheduleTable}
type ScheduleTable = {trackList: TrackList, rows: Row[]}
type TrackList = string[]
type Row = { time: string, schedules: Array<CardProps | null> }

interface Props {
  groupedSchedules: GroupedSchedules
  i18n: {
    startEnd: string
  }
}

export const ScheduleTable: React.VFC<{Props}> = (props) => {
  const { groupedSchedules, i18n } = props
  const current = window.location.hash === "" ? Object.keys(groupedSchedules)[0] : window.location.hash.replace('#', '')


  const [currentKey, setCurrentDate] = useState(current)

  const handleTabClick = (date) =>  {
    window.location.hash = '#' + date
    setCurrentDate(date)
  }

  return (
    <>
      <TabBar>
        {Object.keys(groupedSchedules).map(date => {
          return <TabItem id={date} onClick={() => {handleTabClick(date)}} selected={date === currentKey}>{date}</TabItem>
        })}
      </TabBar>
      <Table>
        <Head>
          <Row>
            <Cell>{i18n.startEnd}</Cell>
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
    </>
  )
}

export default ScheduleTable
