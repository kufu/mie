import React from 'react'
import type { AppProps } from 'next/app'

import '../app/assets/stylesheets/reset.css'

// This default export is required in a new `pages/_app.js` file.
export default function MyApp({ Component, pageProps }: AppProps) {
  return(
    <>
      <head></head>
      <Component {...pageProps} />
    </>
  )
}
