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

type ResponseMessage = {
  status: 'success' | 'error' | 'processing',
  text: string
}

export const TermsOfServiceDialog: React.VFC<Props> = (props) => {
  const { actionHandler, closeHandler, isOpen, i18n } = props
  const [isActiveClicked, setIsActiveClicked] = useState(false)
  const [responseMessage, setResponseMessage] = useState<ResponseMessage | null>(null)

  const handleActiveClick = () => {
    setIsActiveClicked(true)
    setResponseMessage({ status: "processing", text: "" })
    actionHandler()
  }

  return (
    <ActionDialog
      title={i18n.title}
      closeText={i18n.close}
      actionText={i18n.accept}
      onClickAction={handleActiveClick}
      onClickClose={closeHandler}
      isOpen={isOpen}
      actionDisabled={isActiveClicked}
      responseMessage={responseMessage}
    >
      <DialogBody>
        <Text>{i18n.description}</Text>
        <TermsOfService>
          <TermsOfServiceText>
          <Text size="S" leading="RELAXED"><span dangerouslySetInnerHTML={{__html: i18n.termsOfService}}></span></Text>
          </TermsOfServiceText>
        </TermsOfService>
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

const TermsOfService = styled.div`
  background-color: #F8F7F6;
  height: 400px;
  width: 100%;
  overflow: auto;
`

const TermsOfServiceText = styled.div`
  padding: 8px;
`

export default TermsOfServiceDialog