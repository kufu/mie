import React, {useState} from "react";
import styled from 'styled-components'
import {ActionDialog, Textarea, ThemeProvider} from "smarthr-ui";
import createdTheme from "../Constants";

interface Props {
  isOpen: boolean
  handleClose: () => void
  handleAction: (string) => void
  maxLength?: number
  value: string
  limit?: number
  i18n: {
    title: string
    save: string
    close: string
  }
}

export const UpdateDialog: React.VFC<Props> = (props) => {
  const { isOpen, handleClose, handleAction, maxLength, value, i18n } = props
  const [current, setCurrent] = useState(value)
  const [isActive, setIsActive] = useState(value.length <= maxLength)

  const handleOnChange = (e) => {
    setCurrent(e.target.value)
    setIsActive(e.target.value.length <= maxLength)
  }

  return (
    <ThemeProvider theme={createdTheme}>
      <ActionDialog
        title={i18n.title}
        actionText={i18n.save}
        closeText={i18n.close}
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