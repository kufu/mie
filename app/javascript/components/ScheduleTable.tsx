import React, { useState } from 'react'
import styled from 'styled-components'

import { TabBar, TabItem, ThemeProvider } from 'smarthr-ui'
import { ScheduleCard, Props as CardProps, InitialProps } from './ScheduleCard'
import { Table, TableHead, TableBody, TableRow, TableHeadCell, TableBodyCell } from './Shared/Table'
import { ScheduleTime } from './Shared/ScheduleTime';
import createdTheme from "./Constants";

type GroupedSchedules = { [key: string]: ScheduleTable}
type ScheduleTable = {trackList: TrackList, rows: Row[]}
type TrackList = string[]
type Row = { time: string, schedules: Array<CardProps | null> }

interface Props {
  groupedSchedules: GroupedSchedules
  initial?: InitialProps
  i18n: {
    startEnd: string
  }
}

export const ScheduleTable: React.VFC<Props> = (props) => {
  const { groupedSchedules, initial, i18n } = props
  const current = window.location.hash === "" ? Object.keys(groupedSchedules)[0] : window.location.hash.replace('#', '')


  const [currentKey, setCurrentDate] = useState(current)

  const handleTabClick = (date) =>  {
    window.location.hash = '#' + date
    setCurrentDate(date)
  }

  return (
    <ThemeProvider theme={createdTheme}>
      <Wrapper>
        <TabBar>
          {Object.keys(groupedSchedules).sort().map((date, index) => {
            return <TabItem key={index} id={date} onClick={() => {handleTabClick(date)}} selected={date === currentKey}>{date}</TabItem>
          })}
        </TabBar>
        <TableWrapper>
          <Table>
            <TableHead>
              <TableRow>
                <TableHeadCell minWidth={"150px"}>{i18n.startEnd}</TableHeadCell>
                {groupedSchedules[currentKey].trackList.map((track, index) => <TableHeadCell key={index} textCenter>{track}</TableHeadCell>)}
              </TableRow>
            </TableHead>
            <TableBody>
              {groupedSchedules[currentKey].rows.map((row, index) => {
                return (
                  <TableRow key={index}>
                    <TableBodyCell noSidePadding as="th">
                      <ScheduleTime time={row.time}/>
                    </TableBodyCell>
                    {row.schedules.map((schedule, index) =>
                      schedule === null ?
                        <TableBodyCell key={index} />
                        : <TableBodyCell key={index}>
                          <CellItemStretcher>
                            <ScheduleCard {...schedule} initial={initial} />
                          </CellItemStretcher>
                        </TableBodyCell>
                    )}
                  </TableRow>
                )
              })}
            </TableBody>
          </Table>
        </TableWrapper>
      </Wrapper>
    </ThemeProvider>
  )
}

const Wrapper = styled.div`
  max-width: 1120px;
  margin: 0 auto;
`
const TableWrapper = styled.div`
  margin-top: 16px;
  overflow-y: auto;
`
/* テーブルセル内の要素の幅高さ 100% にする */
const CellItemStretcher = styled.div`
  display: flex;
  height: 100%;
  > * {
    width: 100%;
    min-width: 400px;
  }
`

export default ScheduleTable
