import React from 'react'
import styled from 'styled-components'
import { InformationPanel, PrimaryButton } from "smarthr-ui";

interface Props {
  form: SubmitFormProps
  i18n: {
    title: string
    information: string
    buttonText: string
    termsOfService: string
  }
}

export interface SubmitFormProps {
  action: string
  authenticityToken: string
}

export const CreatePlanPanel: React.VFC<{Props}> = (props) => {
  const { i18n } = props

  return (
    <InformationPanel
      title={i18n.title}
      togglable={false}
    >
      <TextArea>
        {i18n.information}<br />
        {i18n.termsOfService}
      </TextArea>
      <SubmitForm {...props} />
    </InformationPanel>
  )
}

const SubmitForm: React.VFC<{Props}> = (props) => {
  const { form, i18n } = props
  const { action, authenticityToken } = form

  return (
    <form action={action} acceptCharset="UTF-8" method="post">
      <input type="hidden" name="authenticity_token" value={authenticityToken} />
      <PrimaryButton type="submit">
        {i18n.buttonText}
      </PrimaryButton>
    </form>
  )
}

export default CreatePlanPanel

const TextArea = styled.div`
  margin: 8px;
  line-height: 1.5;
`