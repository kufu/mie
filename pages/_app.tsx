import React, {useEffect, useState} from 'react'
import type { AppProps } from 'next/app'
import dayjs from 'dayjs'
import timezone from 'dayjs/plugin/timezone'

dayjs.extend(timezone)

import '../app/assets/stylesheets/reset.css'
import '../app/assets/stylesheets/application.css'
import '../app/assets/stylesheets/plans.scss'
import '../app/assets/stylesheets/schedules.scss'
import '../app/assets/stylesheets/static.scss'
import Navigation from "../app/javascript/components/Navigation";

const MyApp = ({ Component, pageProps }: AppProps) => {
  const [currentPath, setCurrentPath] = useState("")
  const [me, setMe] = useState<React.ComponentProps<typeof Navigation>>({
    current: '',
    rootLink: '',
    schedulesLink: '',
    locales: {current: undefined, options: [] }
  })

  useEffect(() => {
    setCurrentPath(document.location.pathname)
    fetch('/2022/api/me')
      .then(response => response.json())
      .then(data => setMe(data.me))
  }, [])

  if (me.locales.current && me.locales.current === "Etc/UTC") {
    const guessed = dayjs.tz.guess()
    fetch('/2022/api/me?locale=' + guessed)
      .then(response => response.json())
      .then(data => {
        setMe(data.me)
      })
  }

  return(
    <>
      <Navigation current={currentPath} {...me} />
      <div style={{padding: '32px'}}>
        <Component {...pageProps} />
      </div>
    </>
  )
}

export default MyApp