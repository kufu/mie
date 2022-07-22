import React from 'react'
import type { AppProps } from 'next/app'
import { appWithTranslation } from "next-i18next";

import '../app/assets/stylesheets/reset.css'
import '../app/assets/stylesheets/application.css'
import '../app/assets/stylesheets/plans.scss'
import '../app/assets/stylesheets/schedules.scss'
import '../app/assets/stylesheets/static.scss'

const MyApp = ({ Component, pageProps }: AppProps) => {
  return(
    <>
      <head></head>
      <Component {...pageProps} />
    </>
  )
}

export default appWithTranslation(MyApp)