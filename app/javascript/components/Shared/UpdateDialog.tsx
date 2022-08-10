import React, {useState} from "react";
import styled from 'styled-components'
import { useTranslation } from "next-i18next";

import {ActionDialog, Textarea, ThemeProvider} from "smarthr-ui";
import createdTheme from "../Constants";

interface Props {
  title: string
  isOpen: boolean
  handleClose: () => void
  handleAction: (string) => void
  maxLength?: number
  value: string
  limit?: number
}

export const UpdateDialog: React.VFC<Props> = (props) => {
  const { title, isOpen, handleClose, handleAction, maxLength, value } = props
  const [current, setCurrent] = useState(value)
  const [isActive, setIsActive] = useState(value.length <= maxLength)

  const { t } = useTranslation()

  const handleOnChange = (e) => {
    setCurrent(e.target.value)
    setIsActive(e.target.value.length <= maxLength)
  }

  return (
    <ThemeProvider theme={createdTheme}>
      <ActionDialog
        title={title}
        actionText={t("button.save")}
        closeText={t("button.close")}
        isOpen={isOpen}
        onClickOverlay={handleClose}
        onPressEscape={handleClose}
        onClickAction={() => handleAction(current)}
        onClickClose={handleClose}
        actionDisabled={!isActive}
      >
        <DialogBody>
          <Textarea
            width="100%"
            onChange={e => handleOnChange(e)}
            defaultValue={value}
            maxLength={maxLength}
          />
        </DialogBody>
      </ActionDialog>
    </ThemeProvider>
  )
}

const DialogBody = styled.div`
  width: 656px;
  padding: 24px;
`
export default UpdateDialog