import React, { useState } from 'react'
import styled from 'styled-components'

import { Base, TabBar, TabItem, Table, Body, Head, Row, Cell, Textarea, PrimaryButton } from 'smarthr-ui'
import { ScheduleCard, Props as CardProps, SubmitFormProps } from './ScheduleCard'

type GroupedPlans = { [key: string]: Row[]}
type Row = { time: string, schedule: CardProps, memo: string }

interface Props {
  groupedPlans: GroupedPlans
  i18n: {
    startEnd: string
    track: string
    memo: string
    updateMemo: string
  }
}

interface SubmitFormWithChildrenProps {
  memo: string
  i18n: {
    updateMemo: string
  }
  form?: SubmitFormProps
}

export const PlanTable: React.VFC<{Props}> = (props) => {
  const { groupedPlans, i18n } = props
  const current = window.location.hash === "" ? Object.keys(groupedPlans)[0] : window.location.hash.replace('#', '')

  const [currentKey, setCurrentDate] = useState(current)

  const handleTabClick = (date) =>  {
    window.location.hash = '#' + date
    setCurrentDate(date)
  }

  return (
    <Container>
      <TabBar>
        {Object.keys(groupedPlans).map(date => {
          return <TabItem id={date} onClick={() => {handleTabClick(date)}} selected={date === currentKey}>{date}</TabItem>
        })}
      </TabBar>
      <Table>
        <Head>
          <Row>
            <Cell>{i18n.startEnd}</Cell>
            <Cell>{i18n.track}</Cell>
            <Cell>{i18n.memo}</Cell>
          </Row>
        </Head>
        <Body>
          {groupedPlans[currentKey].map(row => {
            return (
              <Row>
                <Cell>{row.time}</Cell>
                <Cell><ScheduleCard {...row.schedule} /></Cell>
                <Cell>
                  <MemoArea>
                    { row.schedule.form ?
                      <SubmitForm memo={row.memo} i18n={{updateMemo: i18n.updateMemo}} {...row.schedule} />
                      : row.memo
                    }
                  </MemoArea>
                </Cell>
              </Row>
            )
          })}
        </Body>
      </Table>
    </Container>
  )
}

const SubmitForm: React.VFC<SubmitFormWithChildrenProps> = (props) => {
  const { form, memo, i18n } = props
  const { action, method, authenticityToken, targetKey } = form
  const [currentMemo, setCurrentMemo] = useState(memo)

  const textChangeHandler = (str) => {
    setCurrentMemo(str)
  }

  return (
    action ? (
        <form action={action} accept-charset="UTF-8" method="post">
          {method ? <input type="hidden" name="_method" value={method} /> : null}
          <input type="hidden" name="authenticity_token" value={authenticityToken} />
          <input type="hidden" name="edit_memo_schedule_id" id="edit_memo_schedule_id" value={targetKey} />
          <Note value={currentMemo} name="memo" onChange={(e) => textChangeHandler(e.value)} />
          <PrimaryButton type="submit" name="commit" data-disable-with="Update memo">
            {i18n.updateMemo}
          </PrimaryButton>
        </form> )
      : null
  )
}

const Container = styled(Base)`
  margin: 48px 80px;
`

const Note = styled(Textarea)`
  height: 100%;
  width: 312px;
`

const MemoArea = styled.div`
  width: 320px;
`

export default PlanTable
