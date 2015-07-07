##########
#######
###
  matchName Checker
    (C) 2013-2015 あかつきみさき（みくちぃP）

  このスクリプトについて
    選択した一つ目のプロパティか選択した一つ目のレイヤーのmatchNameをプロンプトですぐにコピーできるようにして表示します.
    プロパティが選択されていない場合はレイヤーのmatchNameを,プロパティが選択されている場合はプロパティのmatchNameが入力されます.

  動作環境
    Adobe After Effects CS5.5以上

  使用方法
    matchNameを取得したいレイヤーかプロパティを選択して実行してください.

  バージョン情報
    2015/02/12 Ver1.2.0 Update
      対象がエフェクトの場合,カテゴリとディスプレイネームを表示するようにした.
      対応バージョンの変更.

    2013/12/29 Ver1.1.0 Update
      プロパティ選択時に最後に選択されたプロパティを表示するようにした.

    2013/11/10 Ver1.0.0 Release
###
#######
##########

MNCData = ( ->
  scriptName          = "matchName Checker"
  scriptURLName       = "matchNameChecker"
  scriptVersionNumber = "1.2.0"
  scriptURLVersion    = 120
  canRunVersionNum    = 10.5
  canRunVersionC      = "CS5.5"
  guid                = "{50EC3707-B4E6-4284-8F3D-BDA375223852}"

  return{
    getScriptName         : -> scriptName
    ,
    getScriptURLName      : -> scriptURLName
    ,
    getScriptVersionNumber: -> scriptVersionNumber
    ,
    getScriptURLVersion   : -> scriptURLVersion
    ,
    getCanRunVersionNum   : -> canRunVersionNum
    ,
    getCanRunVersionC     : -> canRunVersionC
    ,
    getGuid               : -> guid
   }
)()


# 許容バージョンを渡し,実行できるか判別
runAEVersionCheck = (AEVersion) ->
  if parseFloat(app.version) < AEVersion.getCanRunVersionNum()
    alert "This script requires After Effects #{AEVersion.getCanRunVersionC()} or greater."
    return false
  else
    return true

# コンポジションを選択しているか確認する関数
isCompActive = (selComp) ->
  unless(selComp and selComp instanceof CompItem)
    alert "Select Composition"
    return false
  else
    return true

# レイヤーを選択しているか確認する関数
isLayerSelected = (selLayers) ->
  if selLayers.length <= 0
    alert "Select Layers"
    return false
  else
    return true

# プロパティを選択しているか確認する関数
isPropertySelected = (selProperties) ->
  if selProperties.length <= 0
    alert "Select Properties"
    return false
  else
    return true

getEffectName = (effectMatchName) ->
  effectsList = app.effects

  for i in [0...effectsList.length-1] by 1
    if effectMatchName is effectsList[i].matchName
      return "Category : #{effectsList[i].category}, displayName : #{effectsList[i].displayName}"
  return ""


entryFunc = (MNCData, selLayers) ->
  curLayer   = selLayers[selLayers.length-1]
  effectName = ""

  if curLayer.selectedProperties[0]?
    target = curLayer.selectedProperties[curLayer.selectedProperties.length-1]

    if target.isEffect is true
      effectName = getEffectName(target.matchName)
    typeName = "Property"
  else
    target = curLayer
    typeName = "Layer"

  prompt "Name : #{target.name}\ntype : #{typeName}\n#{effectName}\n", target.matchName, MNCData.getScriptName()

  return 0

###
メイン処理開始
###
return 0 unless runAEVersionCheck MNCData

actComp = app.project.activeItem
return 0 unless isCompActive actComp

selLayers = actComp.selectedLayers

return 0 unless isLayerSelected selLayers

entryFunc MNCData, selLayers

return 0
