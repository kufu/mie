import React from 'react'
import { useTranslation } from "next-export-i18n";

import Top from '../../app/javascript/components/Top'

function IndexPage() {
  const { t } = useTranslation()

  return (
    <>
      <title>RubyKaigi 2022 Schedule.select</title>
      <div>
        <Top intro={t("application.intro")} />
      </div>
    </>
  )
}

export default IndexPage
