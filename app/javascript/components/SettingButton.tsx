import React, { useState } from 'react'
import styled from 'styled-components'
import {useTranslation} from "next-export-i18n";

import {
  DialogBase,
  ActionDialog,
  SecondaryButton,
  FaCogIcon,
  Input,
  RadioButton,
  FormGroup,
  Text,
  ThemeProvider
} from 'smarthr-ui'
import createdTheme from "./Constants";

interface Props {
  visible: boolean
  form: SubmitForm
}

interface SubmitForm {
  action: string
  method: string
  authenticityToken: string
}

export const SettingButton: React.VFC<Props> = (props) => {
  const { visible, form } = props

  const [isDialogOpen, setIsDialogOpen] = useState(false)
  const [isVisibleSelected, setIsVisibleSelected] = useState(visible)
  const [password, setPassword] = useState("")

  const { t } = useTranslation()

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
    <ThemeProvider theme={createdTheme}>
      <SecondaryButton size="s" prefix={<FaCogIcon size={11} />} onClick={() => setIsDialogOpen(true)}>
        {t("button.settings")}
      </SecondaryButton>

      <ActionDialog
        title={t("settings.title")}
        actionText={t("button.save")}
        closeText={t("button.close")}
        isOpen={isDialogOpen}
        onClickOverlay={() => setIsDialogOpen(false)}
        onPressEscape={() => setIsDialogOpen(false)}
        onClickAction={() => handleAction()}
        onClickClose={() => handleClose()}
      >
        <DialogBody>
          <Forms
            title={t("settings.setPassword")}
            titleType="subBlockTitle"
            helpMessage={t("settings.passwordExpression")}
            labelId="password"
            innerMargin="XS"
          >
            <PWD type="password" onChange={e => setPassword(e.target.value)} />
          </Forms>

          <Forms
            title={t("settings.changeVisibility")}
            titleType="subBlockTitle"
            helpMessage={t("settings.visibilityDescription", {current: t(visible ? ".settings.visible" : "settings.invisible")})}
            labelId="visibility"
            innerMargin="XS"
          >
            <RadioButtons>
            <RadioBtn name="visibility" value="visible" onChange={(e) => handleVisibilityChange(e.target.value)} checked={isVisibleSelected}>
              <Text as="p">
                <Text weight="bold">{t("settings.visibleText")}</Text><br />
                {t("settings.visibleDescription")}
              </Text>
            </RadioBtn>

              <RadioBtn name="visibility" value="invisible" onChange={(e) => handleVisibilityChange(e.target.value)} checked={!isVisibleSelected}>
                <Text as="p">
                  <Text weight="bold">{t("settings.visibleText")}</Text><br />
                  {t("settings.visibleDescription")}
                </Text>
              </RadioBtn>
            </RadioButtons>
          </Forms>
        </DialogBody>
      </ActionDialog>
    </ThemeProvider>
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

const RadioBtn = styled(RadioButton)`
  margin: 8px;
`

const RadioButtons = styled.div`
  display: flex;
  flex-direction: column;
  padding: 16px 0;
`

export default SettingButton