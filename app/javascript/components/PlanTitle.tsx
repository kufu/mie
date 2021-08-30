import React, {useState} from 'react'
import styled from 'styled-components'

import { Text, FaPencilAltIcon, Heading, SecondaryButton, StatusLabel } from 'smarthr-ui'
import UpdateDialog from "./Shared/UpdateDialog";

interface Props {
  title: string
  maxLength: number
  visible: boolean
  form?: SubmitForm
  i18n: {
    label: string
    edit: string
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

export const PlanTitle: React.VFC<Props> = (props) => {
  const { title, maxLength, visible, form, i18n } = props

  const [isEditing, setIsEditing] = useState(false)

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
      <StatusLabel skeleton={true} type={visible ? "success" : "required"}>{i18n.label}</StatusLabel>
      <MarginWrapper><Heading>{title}</Heading></MarginWrapper>
      {form ?
        <MarginWrapper>
          <SecondaryButton size="s" prefix={<FaPencilAltIcon/>} onClick={() => setIsEditing(true)}>
            <Text size="S" weight="bold" color="TEXT_BLACK">{i18n.edit}</Text>
          </SecondaryButton>
          <UpdateDialog isOpen={isEditing} handleClose={() => setIsEditing(false)} handleAction={handleSave}
                        maxLength={maxLength} value={title} i18n={form.i18n}/>
        </MarginWrapper>
        : null
      }
    </Container>
  )
}

const Container = styled.div`
  display: flex;
  align-items: center;
  gap: 8px;
`

const MarginWrapper = styled.div`
  margin-left: 8px;
`

export default PlanTitle