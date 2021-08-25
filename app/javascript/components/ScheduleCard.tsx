import React, { useState } from 'react'
import styled from 'styled-components'

import {
  Base,
  LineClamp,
  SecondaryButton,
  TextButton,
  FaPlusCircleIcon,
  Text,
  Heading,
  FaCheckCircleIcon, FaPencilAltIcon
} from 'smarthr-ui'
import ScheduleDetail from "./ScheduleDetail";
import { Props as DetailProps } from './ScheduleDetail'
import UpdateDialog from "./Shared/UpdateDialog";

type Language = "en" | "ja"
type Mode = "list" | "plan"
type Details = Omit<DetailProps, "isOpen" | "handleOnClickClose">

export interface Props {
  title: string
  mode: Mode
  description: string
  speakerName: string
  thumbnailUrl: string
  language: Language
  details: Details
  form?: SubmitFormProps
  memo?: string
  i18n: {
    showDetail: string
    editMemo: string
    title: string
    save: string
    close: string
  }
}

export interface SubmitFormProps {
  action: string
  method: string
  authenticityToken: string
  targetKeyName: string
  targetKey: string
  buttonText: string
  i18n: {
    added: string | null
  }
}

export const ScheduleCard: React.VFC<Props> = (props) => {
  const { title, mode, description, speakerName, thumbnailUrl, language, memo, form, i18n, details } = props
  const [isDetailOpen, setIsDetailOpen] = useState(false)
  const [isMemoEditing, setIsMemoEditing] = useState(false)

  const handleCloseClick = () => {
    setIsDetailOpen(false)
  }

  const handleUpdateMemo = (updateMemo: string) => {
    const body = {
      _method: form.method,
      authenticity_token: form.authenticityToken,
      edit_memo_schedule_id: form.targetKey,
      memo: updateMemo
    }

    fetch(form.action, {
      method: 'post',
      credentials: 'same-origin',
      body: Object.keys(body).reduce((o,key)=>(o.set(key, body[key]), o), new FormData())
    }).then(r => {
      document.location.reload()
    })
  }

  const detailProps: DetailProps = {
    ...details,
    isOpen: isDetailOpen,
    handleOnClickClose: handleCloseClick,
  }

  return (
    <Card>
      <Speaker>
        <Profile>
          <SpeakerImage thumbnailUrl={thumbnailUrl} />
          <MarginWrapper><Text weight="bold" color="TEXT_GREY" >{speakerName}</Text></MarginWrapper>
        </Profile>
        <Lng><Text color="TEXT_GREY">Lang:</Text><MarginWrapper>{language}</MarginWrapper></Lng>
      </Speaker>

      <Contents>
        <Title type="sectionTitle" tag="h3">{title}</Title>
        <Description maxLines={4}>{description}</Description>
        { mode === "plan" ?
          <MemoArea>
            <MemoHead type="subSubBlockTitle">Memo</MemoHead>
            <Memo>{memo}</Memo>
          </MemoArea>
          : null
        }
      </Contents>
      <Actions>
        { form && mode === "plan" ?
          <UpdateMemoButton>
            <SecondaryButton prefix={<FaPencilAltIcon size="12"/>} size="s"
                             onClick={() => setIsMemoEditing(true)}>{i18n.editMemo}</SecondaryButton>
            <UpdateDialog isOpen={isMemoEditing} handleClose={() => setIsMemoEditing(false)}
                          handleAction={handleUpdateMemo} value={memo} i18n={i18n}/>
          </UpdateMemoButton>
          : null
        }
        <MarginWrapper>{ form ? <SubmitForm {...form} /> : null }</MarginWrapper>
        <MarginWrapper><TextButton size="s" onClick={() => setIsDetailOpen(true)}>{i18n.showDetail}</TextButton></MarginWrapper>
      </Actions>
      <ScheduleDetail {...detailProps} />
    </Card>
  )
}

const SubmitForm: React.VFC<SubmitFormProps> = (props) => {
  const { action, authenticityToken, targetKeyName, targetKey, buttonText, i18n } = props
  return (
    i18n.added ?
        <AddedText><FaCheckCircleIcon size={14} /><MarginWrapper><Text weight="bold" size="S">{i18n.added}</Text></MarginWrapper></AddedText>
      : (
        <form action={action} acceptCharset="UTF-8" method="post">
          <input type="hidden" name="_method" value="patch" />
          <input type="hidden" name="authenticity_token" value={authenticityToken} />
          <input type="hidden" name={targetKeyName} id={targetKeyName + "-" + targetKey} value={targetKey} />
          <SecondaryButton prefix={<FaPlusCircleIcon size={16} />} type="submit" name="commit" size="s">
            {buttonText}
          </SecondaryButton>
        </form>
      )
  )
}

const Card = styled(Base)`
  padding: 16px;
`

const Speaker = styled.div`
  display: flex;
  justify-content: space-between;
`

const Profile = styled.div`
  display: flex;
`

const MarginWrapper = styled.div`
  margin-left: 8px;
`

const SpeakerImage = styled.div<{thumbnailUrl: string}>`
  width: 24px;
  height: 24px;
  background-image: url("${props => props.thumbnailUrl}");
  background-size: cover;
  border-radius: 2px;
`

const Contents = styled.div`
  margin-bottom: 24px;
`

const Title = styled(Heading)`
  margin: 8px 0;
`

const Lng = styled.div`
  display: flex;
  flex-direction: row;
  justify-content: center;
  align-items: center;
  padding: 0px 12px;

  width: 84px;
  height: 24px;
  left: 330.5px;
  top: 0px;

  background: #F8F7F6;
  border: 1px solid #D6D3D0;
  box-sizing: border-box;
  border-radius: 100px;
  font-family: Hiragino Sans;
  
  font-style: normal;
  font-weight: bold;
  font-size: 13.71px;
  line-height: 17px;
  color: #23221F;
`

const Description = styled(LineClamp)`
  font-family: Hiragino Sans;
  font-style: normal;
  font-weight: normal;
  font-size: 13.71px;
  line-height: 21px;
  color: #23221F;
`

const Actions = styled.div`
  display: flex;
  justify-content: flex-end;
`

const AddedText = styled.div`
  display: flex;
  align-items: center;
  padding: 4px;
`

const MemoArea = styled.div`
  margin: 16px 0;
`

const MemoHead = styled(Heading)`
  margin-bottom: 8px;
`

const Memo = styled.div`
  padding: 16px;
  background: #F8F7F6;
`

const UpdateMemoButton = styled.div`
  margin-right: auto;
`

export default ScheduleCard
