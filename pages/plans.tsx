import React from 'react'
import styled from 'styled-components'
import {serverSideTranslations} from "next-i18next/serverSideTranslations";

import Navigation from '../app/javascript/components/Navigation'
import PlanTitle from '../app/javascript/components/PlanTitle'
import MakeEditableButton from "../app/javascript/components/MakeEditableButton";
import PlanDescription from "../app/javascript/components/PlanDescription";
import PlanTable from "../app/javascript/components/PlanTable";

const dummyTitleData = {"title":"たいとる","maxLength":100,"visible":true,"i18n":{"label":"edit","edit":"編集"}}
const dummyPlanDescriptionData = {"i18n":{"title":"たいとる","notice":"おしらせ","button":"ぼたん"},"description":"説明","maxLength":100}
const dummyMakeEditableButtonData = {"i18n":{"makeEditable":"へんしゅー"},"form":{"method":"patch","action":"","authenticityToken":"","i18n":{"title":"あああ","takeOwn":"おうーん","close":"閉じる","inputPassword":"パスワード"}}}
const dummyPlanTableData = {"groupedPlans":{"2021-09-09":[{"time":"01:00 - 01:55 (UTC)","schedule":{"title":"TypeProf for IDE: Enrich Dev-Experience without Annotations","mode":'plan',"description":"Ruby 3.0 comes bundled with TypeProf, a code analysis tool that doesn't require so many type annotations. Its primary goal is to create type signatures for existing Ruby programs and help users to apply some external type checkers like Steep. Since the release, we have made an effort to adapt TypeProf to an integrated development environment (IDE), which allows users to enjoy many features supported in an IDE, such as browsing method type signatures inferred on the fly, find definition, find references, error checking, etc. We demonstrate TypeProf for IDE, and present its roadmap.","trackName":"TrackA","speakers":[{"speakerName":"Yusuke Endoh","thumbnailUrl":"https://www.gravatar.com/avatar/e73159002200b33d51b7a6a312f2440e/?s=268\u0026d=https%3A%2F%2Frubykaigi.org%2F2020%2Fimages%2Fspeakers%2Fdummy-avatar.png"}],"language":"ja","details":{"body":{"speakers":[{"thumbnailUrl":"https://www.gravatar.com/avatar/e73159002200b33d51b7a6a312f2440e/?s=268\u0026d=https%3A%2F%2Frubykaigi.org%2F2020%2Fimages%2Fspeakers%2Fdummy-avatar.png","speaker":"Yusuke Endoh","username":"@mametter","aboutSpeaker":"'A full-time MRI committer at Cookpad Inc.  He has been interested in testing, analyzing, abusing of Ruby.  He is an advocate of \"transcendental programming\" that creates a useless program like this bio. (`_`)'.yield_self{|s|eval(t=%q(puts\"'#{s.sub(?_,?_+?_)}'.yield_self{|s|eval(t=%q(#{t}))}\"))}","github":"mame","twitter":"mametter"}],"startEndTime":"2021-09-09 01:00 - 01:55","language":"ja","description":"Ruby 3.0 comes bundled with TypeProf, a code analysis tool that doesn't require so many type annotations. Its primary goal is to create type signatures for existing Ruby programs and help users to apply some external type checkers like Steep. Since the release, we have made an effort to adapt TypeProf to an integrated development environment (IDE), which allows users to enjoy many features supported in an IDE, such as browsing method type signatures inferred on the fly, find definition, find references, error checking, etc. We demonstrate TypeProf for IDE, and present its roadmap.","i18n":{"speaker":"スピーカー","username":"ソーシャルID","aboutSpeaker":"プロフィール","startEndTime":"開始/終了 (UTC)","language":"言語","description":"トークの詳細"}},"i18n":{"title":"トークの詳細","close":"閉じる"}},"i18n":{"showDetail":"詳細を表示","editMemo":"メモを更新","title":"「TypeProf for IDE: Enrich Dev-Experience without Annotations」のメモを更新","save":"保存","close":"閉じる"},"memo":"","memoMaxLength":1024,"form":{"action":"/2021/plans/135306ca-460d-490b-b8b3-1aa579142f95","method":"patch","authenticityToken":"1q9HI3lZ1AISC6JBQ2QCaiO82JN_336imiqbPW2tCrxfp5Q7mD0uEVhA8WZuBu-qx_d3etV7Dq7NvcRKr6xvxw","targetKeyName":"remove_schedule_id","targetKey":"2f3e0897-16b3-4b69-a51d-f61674687885","buttonText":"スケジュールから削除します","mode":'plan',"i18n":{"added":"スケジュールに追加されています"}}},"memo":"","sortKey":1631149200}]},"oopsImagePath":"/assets/2021/rubykaigi-7d3d50383f6a7d9f9a8eb4a8ae3ca0260afd47f0ba2fda15aefb4de83258c9f3.png","uri":"https://rubykaigi.smarthr.co.jp/2021/plans/135306ca-460d-490b-b8b3-1aa579142f95","i18n":{"startEnd":"開始/終了 時間","track":"トラック名","memo":"メモ","updateMemo":"メモを更新","noPlans":"視聴予定のトークを登録しましょう！","noPlansDesc":"トーク一覧から予定を追加しよう"}}

function PlanPage() {

  return (
    <div>
      <Navigation rootLink="" current="" schedulesLink="" locales={{i18n: { label: "test"}, options: []}}
                  i18n={{label: 'test', rootButton: "test", scheduleButton: "test", plansButton: "test", help: "test"}}/>
      <Container>
        <Title>
          <PlanTitle {...dummyTitleData} />
        </Title>
        <MakeEditableButton {...dummyMakeEditableButtonData} />
      </Container>

      <PlanDescription {...dummyPlanDescriptionData} />
      <PlanTable {...dummyPlanTableData} />
    </div>
  )
}

export const getStaticProps = async ({ locale }) => ({
  props: {
    ...await serverSideTranslations(locale, ['common']),
  },
})

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