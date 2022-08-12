import React, { useState } from 'react'
import { useTranslation } from "next-export-i18n"
import styled from 'styled-components'

import {Base, Heading, SecondaryButton, FaPencilAltIcon, Text} from 'smarthr-ui'
import UpdateDialog from "./Shared/UpdateDialog";

interface Props {
  description: string
  maxLength?: number
  form?: SubmitForm
}

interface SubmitForm {
  action: string
  method: string
  authenticityToken: string
}


export const PlanDescription: React.VFC<Props> = (props) => {
  const { description, maxLength, form } = props
  const [isDialogOpen, setIsDialogOpen] = useState(false)

  const { t } = useTranslation()

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
              <Heading type="blockTitle" tag="h1">{t("description.title")}</Heading>
              <Text size="S" color="TEXT_GREY">{t("description.notice")}</Text>
            </Stack>

            {form ?
              <SecondaryButton size="s" prefix={<FaPencilAltIcon size={11}/>} onClick={() => setIsDialogOpen(true)}>
                <Text size="S" weight="bold">{t("button.edit")}</Text>
              </SecondaryButton>
              : null
            }
           </LineUp>
         <DescriptionBase>
          <Text>{description}</Text>
        </DescriptionBase>
      {form ?
        <UpdateDialog title={t("description.formTitme")} isOpen={isDialogOpen} handleClose={() => setIsDialogOpen(false)} handleAction={handleAction}
                      maxLength={maxLength} value={description} />
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