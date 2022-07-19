import React from 'react'
import type { AppProps } from 'next/app'

import '../app/assets/stylesheets/reset.css'
import '../app/assets/stylesheets/application.css'
import '../app/assets/stylesheets/plans.scss'
import '../app/assets/stylesheets/schedules.scss'
import '../app/assets/stylesheets/static.scss'

// This default export is required in a new `pages/_app.js` file.
export default function MyApp({ Component, pageProps }: AppProps) {
  return(
    <>
      <head></head>
      <Component {...pageProps} />
    </>
  )
}
