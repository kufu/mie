import { Html, Head, Main, NextScript } from 'next/document'

export default function Document() {
  return (
    <Html>
      <Head>
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossOrigin="crossorigin" />
        <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500&family=Roboto:wght@400;500&display=swap" rel="stylesheet" />
      </Head>
      <body style={{fontFamily: "'Roboto', 'Noto Sans JP', 'sans-serif'"}}>
      <Main />
      <NextScript />
      </body>
    </Html>
  )
}