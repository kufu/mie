import React, { useState } from 'react'
import styled from 'styled-components'

import { Base, TabBar, TabItem, Textarea, PrimaryButton } from 'smarthr-ui'
import { ScheduleCard, Props as CardProps, SubmitFormProps } from './ScheduleCard'
import { Table, TableHead, TableBody, TableRow, TableHeadCell, TableBodyCell } from './Shared/Table'

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

export const PlanTable: React.VFC<Props> = (props) => {
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
      <TableWrapper>
        <Table>
          <TableHead>
            <TableRow>
              <TableHeadCell width="20%">{i18n.startEnd}</TableHeadCell>
              <TableHeadCell textCenter>{i18n.track}</TableHeadCell>
              <TableHeadCell>{i18n.memo}</TableHeadCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {groupedPlans[currentKey].map(row => {
              return (
                <TableRow>
                  <TableBodyCell noSidePadding>{row.time}</TableBodyCell>
                  <TableBodyCell noSidePadding><ScheduleCard {...row.schedule} /></TableBodyCell>
                  <TableBodyCell>
                    <MemoArea>
                      { row.schedule.form ?
                        <SubmitForm memo={row.memo} i18n={{updateMemo: i18n.updateMemo}} {...row.schedule} />
                        : row.memo
                      }
                    </MemoArea>
                  </TableBodyCell>
                </TableRow>
              )
            })}
          </TableBody>
        </Table>
      </TableWrapper>
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
        <form action={action} acceptCharset="UTF-8" method="post">
          {method ? <input type="hidden" name="_method" value={method} /> : null}
          <input type="hidden" name="authenticity_token" value={authenticityToken} />
          <input type="hidden" name="edit_memo_schedule_id" id={"edit_memo_schedule_id-" + targetKey} value={targetKey} />
          <Note value={currentMemo} name="memo" onChange={(e) => textChangeHandler(e.value)} />
          <PrimaryButton type="submit" name="commit" data-disable-with="Update memo">
            {i18n.updateMemo}
          </PrimaryButton>
        </form> )
      : null
  )
}

const Container = styled.div`
  margin: 48px 80px;
`

const Note = styled(Textarea)`
  height: 100%;
  width: 312px;
`

const MemoArea = styled.div`
  width: 320px;
`

const TableWrapper = styled.div`
  margin-top: 16px;
`

export default PlanTable
