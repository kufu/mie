import React, {useState} from 'react'
import { useTranslation } from "next-export-i18n"
import styled from 'styled-components'

import { Text, FaPencilAltIcon, Heading, SecondaryButton, StatusLabel } from 'smarthr-ui'
import UpdateDialog from "./Shared/UpdateDialog";

interface Props {
  title: string
  maxLength: number
  visible: boolean
  form?: SubmitForm
}

interface SubmitForm {
  action: string
  method: string
  authenticityToken: string
}

export const PlanTitle: React.VFC<Props> = (props) => {
  const { title, maxLength, visible, form } = props

  const [isEditing, setIsEditing] = useState(false)

  const { t } = useTranslation()

  const handleSave = (updateString: string) => {
    const body = {
      _method: form.method,
      authenticity_token: form.authenticityToken,
      title: updateString
    }

    fetch(form.action, {
      method: 'post',
      credentials: 'same-origin',
      body: Object.keys(body).reduce((o,key)=>(o.set(key, body[key]), o), new FormData())
    }).then(r => {
      document.location.reload()
    })
  }

  return (
    <Container>
      <StatusLabel type={visible ? "blue" : "red"}>{visible ? t("settings.visible") : t("settings.invisible")}</StatusLabel>
      <MarginWrapper><Heading>{title}</Heading></MarginWrapper>
      {form ?
        <MarginWrapper>
          <SecondaryButton size="s" prefix={<FaPencilAltIcon/>} onClick={() => setIsEditing(true)}>
            <Text size="S" weight="bold" color="TEXT_BLACK">{t("button.edit")}</Text>
          </SecondaryButton>
          <UpdateDialog title={t("dialog.editTitle")} isOpen={isEditing} handleClose={() => setIsEditing(false)} handleAction={handleSave}
                        maxLength={maxLength} value={title} />
        </MarginWrapper>
        : null
      }
    </Container>
  )
}

const Container = styled.div`
  display: flex;
  align-items: center;
  gap: 4px;
`

const MarginWrapper = styled.div`
  margin-left: 8px;
`

export default PlanTitle