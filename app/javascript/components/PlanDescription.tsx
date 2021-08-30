import React, { useState } from 'react'
import styled from 'styled-components'

import {Base, Heading, SecondaryButton, FaPencilAltIcon, Text} from 'smarthr-ui'
import UpdateDialog from "./Shared/UpdateDialog";

interface Props {
  description: string
  maxLength?: number
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
  const { description, maxLength, form, i18n } = props
  const [isDialogOpen, setIsDialogOpen] = useState(false)

  const handleAction = (desc) => {
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

  return (
    <Container>
          <LineUp>
            <Stack>
              <Heading type="blockTitle" tag="h1">{i18n.title}</Heading>
              <Text size="S" color="TEXT_GREY">{i18n.notice}</Text>
            </Stack>

            {form ?
              <SecondaryButton size="s" prefix={<FaPencilAltIcon size={11}/>} onClick={() => setIsDialogOpen(true)}>
                <Text size="S" weight="bold">{i18n.button}</Text>
              </SecondaryButton>
              : null
            }
           </LineUp>
         <DescriptionBase>
          <Text>{description}</Text>
        </DescriptionBase>
      {form ?
        <UpdateDialog isOpen={isDialogOpen} handleClose={() => setIsDialogOpen(false)} handleAction={handleAction}
                      maxLength={maxLength} value={description} i18n={form.i18n}/>
        : null
      }
    </Container>
  )
}

const Container = styled.div`
  margin: 8px auto 0;
  max-width: 1120px;
  display: flex;
  flex-direction: column;
  gap: 12px;

`

const Stack = styled.div`
  display: flex;
  flex-direction: column;
  gap: 4px;
`

const LineUp = styled.div`
  display: flex;
  justify-content: space-between;
  align-items: flex-end;
`

const DescriptionBase = styled(Base)`
  padding: 16px;
`

export default PlanDescription