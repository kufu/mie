import React, { useState } from 'react'
import { useTranslation } from "next-export-i18n";
import styled from 'styled-components'
import Oops from "./Oops";

type Status = 404 | 500

interface Props {
  status: Status
}

export const Errors: React.VFC<Props> = (props) => {
  const { t } = useTranslation()

  const propsFor404 = {
    title: t("errors.not_found"),
    description: t("errors.not_found_desc"),
    imagePath: "" // TODO
  }

  const propsFor500 = {
    title: t("errors.internal_server_error"),
    imagePath: "" // TODO
  }

  var oopsProps
  switch (props.status) {
    case 404:
      oopsProps = propsFor404
      break
    default:
      oopsProps = propsFor500
      break
  }

  return (
    <Container>
      <Oops {...oopsProps} noBorder={true} />
    </Container>
  )
}


const Container = styled.div`
  width: 100%;
  height: 90vh;
  display: flex;
  align-items: center;
  justify-content: center;
`

export default Errors