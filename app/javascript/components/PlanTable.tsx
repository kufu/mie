import React, { useState } from 'react'
import styled from 'styled-components'

import { Base, TabBar, TabItem, Table, Body, Head, Row, Cell, Textarea, PrimaryButton } from 'smarthr-ui'
import { ScheduleCard, Props as CardProps, SubmitFormProps } from './ScheduleCard'

type GroupedPlans = { [key: string]: Row[]}
type Row = { time: string, schedule: CardProps, memo: string }

interface Props {
  current: string
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
  form: SubmitFormProps
}

export const PlanTable: React.VFC<{Props}> = (props) => {
  const { groupedPlans, current, i18n } = props

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
                  <SubmitForm memo={row.memo} i18n={{updateMemo: i18n.updateMemo}} {...row.schedule}>
                  </SubmitForm>
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
  width: 480px;
`

export default PlanTable
