import React, { useState } from 'react'
import styled from 'styled-components'

import { Base, TabBar, TabItem, Table, Body, Head, Row, Cell } from 'smarthr-ui'
import { ScheduleCard, Props as CardProps } from './ScheduleCard'

type GroupedPlans = { [key: string]: Row[]}
type Row = { time: string, schedule: CardProps }

interface Props {
  current: string
  groupedPlans: GroupedPlans
}

export const PlanTable: React.VFC<{Props}> = (props) => {
  const { groupedPlans, current } = props

  const [currentKey, setCurrentDate] = useState(current)

  return (
    <Container>
      <TabBar>
        {Object.keys(groupedPlans).map(date => {
          return <TabItem id={date} onClick={() => {setCurrentDate(date)}} selected={date === currentKey}>{date}</TabItem>
        })}
      </TabBar>
      <Table>
        <Head>
          <Row>
            <Cell>start ... end</Cell>
            <Cell>Track</Cell>
          </Row>
        </Head>
        <Body>
          {groupedPlans[currentKey].map(row => {
            return (
              <Row>
                <Cell>{row.time}</Cell>
                <Cell><ScheduleCard {...row.schedule} /></Cell>
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

export default PlanTable
