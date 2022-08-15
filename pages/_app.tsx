import React from 'react'
import type { AppProps } from 'next/app'

import '../app/assets/stylesheets/reset.css'
import '../app/assets/stylesheets/application.css'
import '../app/assets/stylesheets/plans.scss'
import '../app/assets/stylesheets/schedules.scss'
import '../app/assets/stylesheets/static.scss'

const MyApp = ({ Component, pageProps }: AppProps) => {
  return(
      <Component {...pageProps} />
  )
}

export default MyApp