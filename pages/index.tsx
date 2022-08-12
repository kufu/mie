import React from 'react'
import { useTranslation } from "next-export-i18n";

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

export default IndexPage
