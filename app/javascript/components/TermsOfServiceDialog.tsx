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
          <Text size="S" leading="RELAXED"><span dangerouslySetInnerHTML={{__html: i18n.termsOfService}}></span></Text>
        </ServiceOfTerms>
      </DialogBody>
    </ActionDialog>
  )
}

const DialogBody = styled(DialogBase)`
  width: 656px;
  padding: 24px;
  display: flex;
  flex-direction: column;
  gap: 24px;
`

const ServiceOfTerms = styled.div`    
  background-color: #F8F7F6;
  padding: 24px;
  height: 400px;
  width: 100%;
  overflow: auto;
`

export default TermsOfServiceDialog