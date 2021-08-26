import React, { useState } from 'react'
import styled from 'styled-components'

import {
  DialogBase,
  ActionDialog,
  Text
} from 'smarthr-ui'

interface Props {
  isOpen: boolean
  closeHandler: () => void
  actionHandler: () => void
  i18n: {
    title: string
    description: string
    termsOfService: string
    close: string
    accept: string
  }
}

export const TermsOfServiceDialog: React.VFC<Props> = (props) => {
  const { actionHandler, closeHandler, isOpen, i18n } = props

  return (
    <ActionDialog
      title={i18n.title}
      closeText={i18n.close}
      actionText={i18n.accept}
      onClickAction={actionHandler}
      onClickClose={closeHandler}
      isOpen={isOpen}
    >
      <DialogBody>
        <Text>{i18n.description}</Text>
        <ServiceOfTerms>
          <span dangerouslySetInnerHTML={{__html: i18n.termsOfService}}></span>
        </ServiceOfTerms>
      </DialogBody>
    </ActionDialog>
  )
}

const DialogBody = styled(DialogBase)`
  width: 656px;
  padding: 24px;
`

const ServiceOfTerms = styled.div`
  height: 400px;
  width: 100%;
  overflow: auto;
`

export default TermsOfServiceDialog