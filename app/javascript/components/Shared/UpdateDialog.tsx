import React, {useState} from "react";
import styled from 'styled-components'
import {ActionDialog, DialogBase, Textarea} from "smarthr-ui";

interface Props {
  isOpen: boolean
  handleClose: () => void
  handleAction: (string) => void
  value: string
  limit?: number
  i18n: {
    title: string
    save: string
    close: string
  }
}

export const UpdateDialog: React.VFC<Props> = (props) => {
  const { isOpen, handleClose, handleAction, value, i18n } = props
  const [current, setCurrent] = useState(value)

  return (
    <ActionDialog
      title={i18n.title}
      actionText={i18n.save}
      closeText={i18n.close}
      isOpen={isOpen}
      onClickOverlay={handleClose}
      onPressEscape={handleClose}
      onClickAction={() => handleAction(current)}
      onClickClose={handleClose}
    >
      <DialogBody>
        <Textarea
          width="100%"
          onChange={e => setCurrent(e.target.value)}
          defaultValue={value}
        />
      </DialogBody>
    </ActionDialog>
  )
}

const DialogBody = styled(DialogBase)`
  width: 656px;
  padding: 24px;
`
export default UpdateDialog