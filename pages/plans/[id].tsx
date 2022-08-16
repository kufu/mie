import React, {useEffect, useState} from 'react'
import { useRouter } from 'next/router'
import styled from 'styled-components'

import PlanTitle from '../../app/javascript/components/PlanTitle'
import MakeEditableButton from "../../app/javascript/components/MakeEditableButton";
import PlanDescription from "../../app/javascript/components/PlanDescription";
import PlanTable from "../../app/javascript/components/PlanTable";
import SettingButton from "../../app/javascript/components/SettingButton";

type APIResult = {
  id: string
  title:  React.ComponentProps<typeof PlanTitle>
  description: React.ComponentProps<typeof PlanDescription>
  settingButton?: React.ComponentProps<typeof SettingButton>
  makeEditableButton?: React.ComponentProps<typeof MakeEditableButton>
  visible: boolean
} &
  React.ComponentProps<typeof MakeEditableButton> &
  React.ComponentProps<typeof PlanTable>

function PlanPage() {
  const router = useRouter()
  const [plan, setPlan] = useState<APIResult>()
  const [lastMod, setLastMod] = useState(Date.now())

  useEffect(() => {
    const { id } = router.query
    if(!id) return

    fetch('http://localhost:4000/2022/api/plans/' + id)
      .then(response => response.json())
      .then(data => setPlan(data.plan))
  }, [router, lastMod])

  const handleUpdate = () => {
    setLastMod(Date.now())
  }

  return (
    <div>
      {plan ?
        <>
          <Container>
            <Title>
              <PlanTitle {...plan.title} visible={plan.visible} handleUpdate={handleUpdate} />
            </Title>
            { plan.settingButton ? <SettingButton visible={plan.visible} form={plan.settingButton.form} handleUpdate={handleUpdate} /> : null }
            { plan.makeEditableButton ? <MakeEditableButton {...plan.makeEditableButton} /> : null }
          </Container>
          <PlanDescription {...plan.description} handleUpdate={handleUpdate} />
          <PlanTable {...plan} handleUpdate={handleUpdate} />
        </>
        : null
      }
    </div>
  )
}

const Container = styled.div`
  display: flex;
  align-items: center;
  margin: 16px auto 24px;
  max-width: 1120px;
`

const Title = styled.div`
  margin-right: auto;
`

export default PlanPage