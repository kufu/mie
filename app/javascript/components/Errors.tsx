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

  const index = Math.floor(Math.random() * 5);
  const ninjas =  ["blackNinja.png", "blueNinja.png", "purpleNinja.png", "redNinja.png", "yellowNinja.png"]
  const [imagePath, setImagePath]  =  useState('/static/' + ninjas[index])



  const propsFor404 = {
    title: t("errors.notFound"),
    description: t("errors.notFoundDesc"),
    imagePath: imagePath
  }

  const propsFor500 = {
    title: t("errors.internalServerError"),
    imagePath: imagePath
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