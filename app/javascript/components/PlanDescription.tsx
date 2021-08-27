import React, { useState } from 'react'
import styled from 'styled-components'

import {Base, Heading, TextButton, FaPencilAltIcon, DialogBase, ActionDialog, Textarea, Text} from 'smarthr-ui'

interface Props {
  description: string
  form?: SubmitForm
  i18n: {
    title: string
    notice: string
    button: string
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


export const PlanDescription: React.VFC<Props> = (props) => {
  const { description, form, i18n } = props

  const [isDialogOpen, setIsDialogOpen] = useState(false)
  const [desc, setDesc] = useState(description)

  const handleTextChange = (text) => {
    setDesc(text)
  }

  const handleAction = () => {
    const body = {
      _method: form.method,
      authenticity_token: form.authenticityToken,
      description: desc
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
    setDesc(description)
    setIsDialogOpen(false)
  }

  return (
    <Container>
      <DescriptionBase>
        <Heading type="subBlockTitle" tag="h1">{i18n.title}</Heading>
        <Text size="XS" color="TEXT_GREY">{i18n.notice}</Text>
        <TextContainer>
          {description}
          {form ?
            <TextButton size="s" prefix={<FaPencilAltIcon size={11}/>} onClick={() => setIsDialogOpen(true)}>
              {i18n.button}
            </TextButton>
            : null
          }
        </TextContainer>
      </DescriptionBase>
      {form ?
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
            <Textarea
              width="100%"
              onChange={(e) => handleTextChange(e.target.value)}
            >
              {desc}
            </Textarea>
          </DialogBody>
        </ActionDialog>
        : null
      }
    </Container>
  )
}

const Container = styled.div`
  margin: 8px auto 0;
  max-width: 1120px;
`

const TextContainer = styled.div`
  margin: 8px 0;
`

const DialogBody = styled(DialogBase)`
  width: 656px;
  padding: 24px;
`

const DescriptionBase = styled(Base)`
  padding: 16px;
`

export default PlanDescription