import React, {useEffect, useState} from 'react'
import { useRouter } from 'next/router'
import styled from 'styled-components'

import PlanTitle from '../../app/javascript/components/PlanTitle'
import MakeEditableButton from "../../app/javascript/components/MakeEditableButton";
import PlanDescription from "../../app/javascript/components/PlanDescription";
import PlanTable from "../../app/javascript/components/PlanTable";

type APIResult =
  React.ComponentProps<typeof PlanTitle> &
  React.ComponentProps<typeof MakeEditableButton> &
  React.ComponentProps<typeof PlanDescription> &
  React.ComponentProps<typeof PlanTable>

function PlanPage() {
  const router = useRouter()
  const [plan, setPlan] = useState<APIResult>()

  useEffect(() => {
    const { id } = router.query
    if(!id) return

    fetch('http://localhost:4000/2022/api/plans/' + id)
      .then(response => response.json())
      .then(data => setPlan(data.plan))
  }, [router])

  return (
    <div>
      {plan ?
        <>
          <Container>
            <Title>
              <PlanTitle {...plan} />
            </Title>
            <MakeEditableButton {...plan} />
          </Container>
          <PlanDescription {...plan} />
          <PlanTable {...plan} />
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