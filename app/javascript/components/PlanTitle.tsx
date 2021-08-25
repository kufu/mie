import React, {useState} from 'react'
import styled from 'styled-components'

import { FaPencilAltIcon, Heading, SecondaryButton, StatusLabel } from 'smarthr-ui'
import UpdateDialog from "./Shared/UpdateDialog";

interface Props {
  title: string
  visible: boolean
  form?: SubmitForm
  i18n: {
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
  const { title, visible, form, i18n } = props

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
      <StatusLabel skeleton={true} type={visible ? "success" : "required"}>{visible ? "public" : "private"}</StatusLabel>
      <MarginWrapper><Heading>{title}</Heading></MarginWrapper>
      {form ?
        <MarginWrapper>
          <SecondaryButton prefix={<FaPencilAltIcon/>} onClick={() => setIsEditing(true)}>Edit</SecondaryButton>
          <UpdateDialog isOpen={isEditing} handleClose={() => setIsEditing(false)} handleAction={handleSave}
                        value={title} i18n={form.i18n}/>
        </MarginWrapper>
        : null
      }
    </Container>
  )
}

const Container = styled.div`
  display: flex;
  align-items: center;
`

const MarginWrapper = styled.div`
  margin-left: 8px;
`

export default PlanTitle