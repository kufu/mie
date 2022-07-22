import React from 'react'
import { serverSideTranslations } from 'next-i18next/serverSideTranslations'

import Navigation from '../app/javascript/components/Navigation'
import Top from '../app/javascript/components/Top'

function IndexPage() {
  return (
    <div>
      <Navigation rootLink="" current="" schedulesLink="" locales={{i18n: { label: "test"}, options: []}}
              i18n={{label: 'test', rootButton: "test", scheduleButton: "test", plansButton: "test", help: "test"}}/>
      <Top intro={"test"} />
    </div>
  )
}

export const getStaticProps = async ({ locale }) => ({
  props: {
    ...await serverSideTranslations(locale, ['common']),
  },
})

export default IndexPage
