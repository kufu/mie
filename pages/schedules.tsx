import React from 'react'
import { GetStaticProps } from "next";

import ScheduleTable from '../app/javascript/components/ScheduleTable'

export default function Schedule(props: React.ComponentProps<typeof ScheduleTable>) {
  return (
    <div>
      <ScheduleTable {...props} />
    </div>
  )
}

export const getStaticProps: GetStaticProps = async (context) => {
  const response = await fetch('http://localhost:3000/2022/api/schedules')
  const body = await response.json()
  return {
    props: {
      ...body.schedules
    }
  }
}