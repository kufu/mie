import React, {useEffect, useState} from 'react'
import { GetStaticProps } from "next";

import ScheduleTable from '../../app/javascript/components/ScheduleTable'

export default function Schedule() {
  const [schedules, setSchedules] = useState<React.ComponentProps<typeof ScheduleTable>>()
  const [lastMod, setLastMod] = useState(Date.now())
  useEffect(() => {
    fetch('http://localhost:4000/2022/api/schedules')
      .then((res) => res.json())
      .then((data) => setSchedules(data.schedules))
  }, [lastMod])
  return (
    <div>
      { schedules ? <ScheduleTable {...schedules} handleUpdate={() => setLastMod(Date.now())} /> : null }
    </div>
  )
}