import React from 'react'
import { serverSideTranslations } from 'next-i18next/serverSideTranslations'

import Navigation from '../app/javascript/components/Navigation'
import Top from '../app/javascript/components/Top'

function IndexPage() {
  const { t } = useTranslation()

  return (
    <div>
      <Navigation rootLink="" current="" schedulesLink="" locales={{ options: [] }} />
      <Top intro={t("application.intro")} />
    </div>
  )
}

export const getStaticProps = async ({ locale }) => ({
  props: {
    ...await serverSideTranslations(locale, ['common']),
  },
})

export default IndexPage
