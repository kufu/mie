import React, { useState } from 'react'
import styled from 'styled-components'

import {
  DialogBase,
  ActionDialog,
  SecondaryButton,
  FaCogIcon,
  Input,
  RadioButtonNew,
  FormGroup,
  Text
} from 'smarthr-ui'

interface Props {
  visible: boolean
  form: SubmitForm
  i18n: {
    settings: string
    setPassword: string
    changeVisibility: string
    visibilityDesc: string
    visibleText: string
    visibleDesc: string
    invisibleText: string
    invisibleDesc: string
  }
}

interface SubmitForm {
  action: string
  method: string
  authenticityToken: string
  i18n: {
    title: string
    save: string
    close: string
  }
}

export const SettingButton: React.VFC<Props> = (props) => {
  const { visible, i18n, form } = props

  const [isDialogOpen, setIsDialogOpen] = useState(false)
  const [isVisibleSelected, setIsVisibleSelected] = useState(visible)
  const [password, setPassword] = useState("")

  const handleVisibilityChange = (visibility) => {
    setIsVisibleSelected(visibility == "visible")
  }

  const handleAction = () => {
    const body = {
      _method: form.method,
      authenticity_token: form.authenticityToken,
      visibility: isVisibleSelected,
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
        {i18n.settings}
      </SecondaryButton>

      <ActionDialog
        title={form.i18n.title}
        actionText={form.i18n.save}
        closeText={form.i18n.close}
        isOpen={isDialogOpen}
        onClickOverlay={() => setIsDialogOpen(false)}
        onPressEscape={() => setIsDialogOpen(false)}
        onClickAction={() => handleAction()}
        onClickClose={() => handleClose()}
      >
        <DialogBody>
          <Forms
            title={i18n.setPassword}
            titleType="subBlockTitle"
            labelId="password"
            innerMargin="XS"
          >
            <PWD type="password" onChange={e => setPassword(e.target.value)} />
          </Forms>

          <Forms
            title={i18n.changeVisibility}
            titleType="subBlockTitle"
            helpMessage={i18n.visibilityDesc}
            labelId="visibility"
            innerMargin="XS"
          >
            <RadioButtons>
            <RadioBtn name="visibility" value="visible" onChange={(e) => handleVisibilityChange(e.target.value)} checked={isVisibleSelected}>
              <Text as="p">
                <Text weight="bold">{i18n.visibleText}</Text><br />
                {i18n.visibleDesc}
              </Text>
            </RadioBtn>

              <RadioBtn name="visibility" value="invisible" onChange={(e) => handleVisibilityChange(e.target.value)} checked={!isVisibleSelected}>
                <Text as="p">
                  <Text weight="bold">{i18n.invisibleText}</Text><br />
                  {i18n.invisibleDesc}
                </Text>
              </RadioBtn>
            </RadioButtons>
          </Forms>
        </DialogBody>
      </ActionDialog>
    </>
  )
}

const Forms = styled(FormGroup)`
  margin: 8px 0;
  width: 100%;
`

const PWD = styled(Input)`
  width: 100%;
`

const DialogBody = styled(DialogBase)`
  width: 656px;
  padding: 24px;
`

const RadioBtn = styled(RadioButtonNew)`
  margin: 8px;
`

const RadioButtons = styled.div`
  display: flex;
  flex-direction: column;
  padding: 16px 0;
`

export default SettingButton