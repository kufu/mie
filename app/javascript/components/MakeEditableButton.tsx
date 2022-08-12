import React, { useState } from 'react'
import { useTranslation } from 'next-export-i18n';
import styled from 'styled-components'

import {
  DialogBase,
  ActionDialog,
  SecondaryButton,
  FaCogIcon,
  Input,
  FormGroup,
} from 'smarthr-ui'

interface Props {
  form: SubmitForm
}

interface SubmitForm {
  action: string
  method: string
  authenticityToken: string
}

export const MakeEditableButton: React.VFC<Props> = (props) => {
  const { form } = props
  const { t } = useTranslation()

  const [isDialogOpen, setIsDialogOpen] = useState(false)
  const [password, setPassword] = useState("")

  const handleAction = () => {
    const body = {
      _method: form.method,
      authenticity_token: form.authenticityToken,
      password: password,
    }

    fetch(form.action, {
      method: 'post',
      credentials: 'same-origin',
      body: Object.keys(body).reduce((o,key)=>(o.set(key, body[key]), o), new FormData())
    }).then(r => {
      document.location.reload()
    })
  }

  const handleClose = () => {
    setIsDialogOpen(false)
  }

  return (
    <>
      <SecondaryButton size="s" prefix={<FaCogIcon size={11} />} onClick={() => setIsDialogOpen(true)}>
        {t("button.makeEditable")}
      </SecondaryButton>

      <ActionDialog
        title={t("button.makeEditable")}
        actionText={t("button.checkPassword")}
        closeText={t("button.close")}
        isOpen={isDialogOpen}
        onClickOverlay={() => setIsDialogOpen(false)}
        onPressEscape={() => setIsDialogOpen(false)}
        onClickAction={() => handleAction()}
        onClickClose={() => handleClose()}
      >
        <DialogBody>
          <Forms
            title={t("dialog.inputPassword")}
            titleType="subBlockTitle"
            labelId="password"
            innerMargin="XS"
          >
            <PWD type="password" onChange={e => setPassword(e.target.value)} />
          </Forms>
        </DialogBody>
      </ActionDialog>
    </>
  )
}

const Forms = styled(FormGroup)`
  margin: 8px;
  width: 100%;
`

const PWD = styled(Input)`
  width: 100%;
`

const DialogBody = styled(DialogBase)`
  width: 656px;
  padding: 24px;
`

export default MakeEditableButton