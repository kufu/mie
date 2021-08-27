import React, { useState } from 'react'
import styled from 'styled-components'

import { Base, TabBar, TabItem, Text, PrimaryButton } from 'smarthr-ui'
import { ScheduleCard, Props as CardProps, SubmitFormProps } from './ScheduleCard'
import { Table, TableHead, TableBody, TableRow, TableHeadCell, TableBodyCell } from './Shared/Table'
import {ScheduleTime} from "./Shared/ScheduleTime";
import { Oops } from './Oops'

type GroupedPlans = { [key: string]: Row[]}
type Row = { time: string, schedule: CardProps, memo: string }

interface Props {
  groupedPlans: GroupedPlans
  uri: string
  i18n: {
    startEnd: string
    track: string
    memo: string
    updateMemo: string
    noPlans: string
    noPlansDesc: string
  }
}

export const PlanTable: React.VFC<Props> = (props) => {
  const { groupedPlans, uri, i18n } = props
  const current = window.location.hash === "" ? Object.keys(groupedPlans)[0] : window.location.hash.replace('#', '')

  const [currentKey, setCurrentDate] = useState(current)

  const handleTabClick = (date) =>  {
    window.location.hash = '#' + date
    setCurrentDate(date)
  }

  return (
    <Wrapper>
      <TabBar>
        {Object.keys(groupedPlans).sort().map((date, index) => {
          return <TabItem key={index} id={date} onClick={() => {handleTabClick(date)}} selected={date === currentKey}>{date}</TabItem>
        })}
      </TabBar>
      <TableWrapper>
        <Table>
          <TableHead>
            <TableRow>
              <TableHeadCell width="20%">{i18n.startEnd}</TableHeadCell>
              <TableHeadCell textCenter>{i18n.track}</TableHeadCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {
              groupedPlans[currentKey] ?
              groupedPlans[currentKey].map((row, index) => {
                return (
                  <TableRow key={index}>
                    <TableBodyCell noSidePadding as="th">
                      <ScheduleTime time={row.time}/>
                    </TableBodyCell>
                    <TableBodyCell noSidePadding><ScheduleCard {...row.schedule} /></TableBodyCell>
                  </TableRow>
                )
              })
                : <TableRow >
                  <TableBodyCell colSpan={2} noSidePadding>
                    <Oops title={i18n.noPlans} >
                      <Text color="TEXT_GREY">{i18n.noPlansDesc}</Text>
                    </Oops>
                  </TableBodyCell>
                </TableRow>
            }
          </TableBody>
        </Table>
      </TableWrapper>
      <SocialIcons>
        <a href={"https://twitter.com/intent/tweet?text=&url=" + uri + "&hashtags=rubykaigi"} rel="nofollow" target="_blank">
        <TwitterIcon />
        </a>
      </SocialIcons>
    </Wrapper>
  )
}

const Wrapper = styled.div`
  margin: 24px auto 0;
  max-width: 1120px;
`

const TableWrapper = styled.div`
  margin-top: 16px;
`

const SocialIcons = styled.div`
  position: fixed;
  width: 72px;
  left: 1312px;
  bottom: 16px;
`

const TwitterIcon: React.VFC<{}> = () => {
  return (
    <svg width="75" height="75" viewBox="0 0 75 75" fill="none" xmlns="http://www.w3.org/2000/svg">
      <g filter="url(#filter0_d)">
        <circle cx="37.5" cy="36.5" r="35.5" fill="#55ACEE"/>
        <path d="M49.1219 30.732C49.1397 30.9836 49.1397 31.2352 49.1397 31.4867C49.1397 39.1593 43.3656 48 32.8122 48C29.5609 48 26.5406 47.0476 24 45.3946C24.4619 45.4484 24.9061 45.4664 25.3858 45.4664C28.0685 45.4664 30.5381 44.55 32.5102 42.9867C29.9873 42.9328 27.8731 41.2617 27.1447 38.9617C27.5 39.0156 27.8553 39.0515 28.2285 39.0515C28.7437 39.0515 29.2589 38.9796 29.7386 38.8539C27.1092 38.3148 25.137 35.9789 25.137 33.1578V33.086C25.9009 33.5172 26.7893 33.7867 27.7309 33.8226C26.1852 32.7804 25.1726 31.0015 25.1726 28.989C25.1726 27.9109 25.4568 26.9226 25.9543 26.0601C28.7792 29.582 33.0254 31.882 37.7868 32.1336C37.698 31.7023 37.6446 31.2531 37.6446 30.8039C37.6446 27.6054 40.203 25 43.3832 25C45.0355 25 46.5279 25.7008 47.5761 26.8328C48.8731 26.5813 50.1167 26.0961 51.2183 25.4313C50.7918 26.7789 49.8858 27.911 48.6954 28.6297C49.8503 28.504 50.9696 28.1804 52 27.7313C51.2184 28.8812 50.2412 29.9054 49.1219 30.732Z" fill="white"/>
      </g>
      <defs>
        <filter id="filter0_d" x="0" y="-1" width="76" height="76" filterUnits="userSpaceOnUse" colorInterpolationFilters="sRGB">
          <feFlood floodOpacity="0" result="BackgroundImageFix"/>
          <feColorMatrix in="SourceAlpha" type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0" result="hardAlpha"/>
          <feOffset dy="1"/>
          <feGaussianBlur stdDeviation="1"/>
          <feColorMatrix type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.24 0"/>
          <feBlend mode="normal" in2="BackgroundImageFix" result="effect1_dropShadow"/>
          <feBlend mode="normal" in="SourceGraphic" in2="effect1_dropShadow" result="shape"/>
        </filter>
      </defs>
    </svg>
  )
}

export default PlanTable
