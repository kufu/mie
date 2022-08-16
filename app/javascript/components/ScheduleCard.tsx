import React, {useLayoutEffect, useState} from 'react'
import { useTranslation } from "next-export-i18n"
import styled from 'styled-components'

import {
  Base,
  LineClamp,
  SecondaryButton,
  TextButton,
  FaPlusCircleIcon,
  Text,
  Heading,
  FaCheckCircleIcon, FaPencilAltIcon, FaTrashIcon
} from 'smarthr-ui'
import ScheduleDetail from "./ScheduleDetail";
import { Props as DetailProps } from './ScheduleDetail'
import UpdateDialog from "./Shared/UpdateDialog";
import TermsOfServiceDialog from "./TermsOfServiceDialog";
import { LanguageMap } from "./Shared"
import Flash from "./Flash";

type Language = "en" | "ja"
type Mode = "list" | "plan"
type Details = Omit<DetailProps, "isOpen" | "handleOnClickClose">

export interface Props {
  title: string
  mode: Mode
  description: string
  trackName: string
  speakers: {
    speakerName: string
    thumbnailUrl: string
  }[]
  language: Language
  details: Details
  form?: SubmitFormProps
  memo?: string
  memoMaxLength: number
  initial?: InitialProps
  handleUpdate: () => void
}

export interface SubmitFormProps {
  action: string
  method: string
  authenticityToken: string
  targetKeyName: string
  targetKey: string
  buttonText: string
  mode: Mode
  initial? :InitialProps
  handleUpdate: () => void
}

export interface InitialProps {
  title: string
  description: string
  termsOfService: string
  close: string
  accept: string
}

export const ScheduleCard: React.VFC<Props> = (props) => {
  const { title, mode, description, trackName, speakers, language, memo, memoMaxLength, form, initial, details, handleUpdate } = props
  const [isDetailOpen, setIsDetailOpen] = useState(false)
  const [isMemoEditing, setIsMemoEditing] = useState(false)

  const { t } = useTranslation()

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

    request(form.action, body, () => {
        setIsDetailOpen(false)
        setIsMemoEditing(false)
        handleUpdate()
      },
      ()=>{
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
        {speakers.map((speaker, index) =>
          <Profile key={index}>
            <SpeakerImage thumbnailUrl={speaker.thumbnailUrl} />
            <MarginWrapper><Text size="S" weight="bold" color="TEXT_GREY" >{speaker.speakerName}</Text></MarginWrapper>
          </Profile>
        )}
        <TipList>
          <Lng><Text size="S" color="TEXT_GREY">Lang:</Text><MarginWrapper><Text size="S">{LanguageMap[language] || "?"}</Text></MarginWrapper></Lng>
          <Lng><Text size="S" color="TEXT_GREY">Track:</Text><MarginWrapper><Text size="S">{trackName}</Text></MarginWrapper></Lng>
        </TipList>
      </Speaker>

      <Contents>
        <Title type="sectionTitle" tag="h3">{title}</Title>
        <Description maxLines={4}>{description}</Description>
        { mode === "plan" ?
          <MemoArea>
            <MemoHead type="subSubBlockTitle">Memo</MemoHead>
            <Memo><Text size="S">{memo}</Text></Memo>
          </MemoArea>
          : null
        }
      </Contents>
      <Actions>
        { form && mode === "plan" ?
          <UpdateMemoButton>
            <SecondaryButton prefix={<FaPencilAltIcon size={12}/>} size="s"
                             onClick={() => setIsMemoEditing(true)}><Text size="S" weight="bold" color="TEXT_BLACK">{t("button.updateMemo")}</Text></SecondaryButton>
            <UpdateDialog title={t("dialog.editMemo", { title: title} )} isOpen={isMemoEditing} handleClose={() => setIsMemoEditing(false)}
                          handleAction={handleUpdateMemo} maxLength={memoMaxLength} value={memo} />
          </UpdateMemoButton>
          : null
        }
        <MarginWrapper>{ form ? <SubmitForm {...form} initial={initial} handleUpdate={handleUpdate} /> : null }</MarginWrapper>
        <MarginWrapper><TextButton size="s" onClick={() => setIsDetailOpen(true)}><Text size="S" weight="bold" color="TEXT_BLACK">{t("card.showDetail")}</Text></TextButton></MarginWrapper>
      </Actions>
      <ScheduleDetail {...detailProps} />
    </Card>
  )
}

const SubmitForm: React.VFC<SubmitFormProps> = (props) => {
  const { action, authenticityToken, targetKeyName, targetKey, buttonText, initial, mode, handleUpdate } = props
  const [isDialogOpen, setIsDialogOpen] = useState(false)
  const [isClicked, setIsClicked] = useState(false)
  const [error, setError] = useState<string>()

  const { t } = useTranslation()

  const acceptHandler = () => {
    const body = {
      _method: "patch",
      authenticity_token: authenticityToken,
      edit_memo_schedule_id: targetKey,
    }

    body[targetKeyName] = targetKey

    request(action, body, () => {
      setIsDialogOpen(false)
      handleButtonClick()
    }, handleFailure)
  }

  const handleButtonClick = () => {
    setIsClicked(false)
    handleUpdate()
  }

  const handleFailure = (error) => {
    setIsClicked(false)
    setError(error.toString())
  }

  if (initial) {
    return (
      <>
        <SecondaryButton prefix={<FaPlusCircleIcon size={16}/>} size="s" onClick={() => setIsDialogOpen(true)}>
          <Text size="S" weight="bold" color="TEXT_BLACK">{buttonText}</Text>
        </SecondaryButton>
        <TermsOfServiceDialog isOpen={isDialogOpen} closeHandler={() => setIsDialogOpen(false)} actionHandler={acceptHandler} />
        { error ? <Flash message={error} type={'error'} /> : null }
      </>
    )
  } else {
    const onClick = () => {
      setIsClicked(true)
      const body = {
        _method: "patch",
        authenticity_token: authenticityToken
      }
      body[targetKeyName] = targetKey
      request(action, body, handleButtonClick, handleFailure)
    }
    if (targetKeyName.startsWith("add_")) {
      return (
        <>
          <SecondaryButton prefix={<FaPlusCircleIcon size={16}/>} type="submit" name="commit" size="s" disabled={isClicked} onClick={onClick}>
            <Text size="S" weight="bold" color="TEXT_BLACK">{buttonText}</Text>
          </SecondaryButton>
          { error ? <Flash message={error} type={'error'} /> : null }
        </>
      )
    } else {
      if (mode === 'plan') {
        return (<AddedText><FaCheckCircleIcon size={14}/><MarginWrapper><Text weight="bold" size="S" color="TEXT_BLACK">{t("card.added")}</Text></MarginWrapper></AddedText>)
      } else {
        return(
          <>
            <SecondaryButton prefix={<FaPlusCircleIcon size={16}/>} type="submit" name="commit" size="s" disabled={isClicked} onClick={onClick}>
              <Text size="S" weight="bold" color="TEXT_BLACK">{buttonText}</Text>
            </SecondaryButton>
            { error ? <Flash message={error} type={'error'} /> : null }
          </>
        )
      }
    }
  }
}

const request = (planId: string, params: { [key: string]: string }, onSuccess, onFailure) => {
  fetch('/2022/api/plans/' + planId, {
    method: 'post',
    credentials: 'same-origin',
    body: Object.keys(params).reduce((o,key)=>(o.set(key, params[key]), o), new FormData())
  })
    .then(async r => {
      if(!r.ok) {
        const errorMessage = await r.json()
        throw new Error(errorMessage.message)
      }
      onSuccess()
    })
    .catch((e) => {
      onFailure(e.message)
    })
}

const Card = styled(Base)`
  padding: 16px;
  height: fit-content;
`

const Speaker = styled.div`
  display: flex;
  justify-content: space-between;
  align-items: center;
`

const Profile = styled.div`
  display: flex;
  align-items: center;
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
  line-height: 125%;
`

const TipList = styled.div`
  display: flex;
`

const Lng = styled.div`
  display: flex;
  flex-direction: row;
  justify-content: center;
  align-items: center;
  padding: 0px 12px;
  margin-left: 8px;

  height: 24px;
  left: 330.5px;
  top: 0px;

  background: #F8F7F6;
  border: 1px solid #D6D3D0;
  box-sizing: border-box;
  border-radius: 100px;
  
  font-style: normal;
  font-weight: bold;
  font-size: 13.71px;
  line-height: 17px;
  color: #23221F;
`

const Description = styled(LineClamp)`
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
