# favorite

## 📋 프로젝트 소개
해당 프로젝트는 GitHub에 있는 Repositoriy와 User에 대해서 검색할 수 있는 기능을 만든 프로젝트입니다.

<br>

## 📌 API
API는 [GitHub Docs](https://docs.github.com/ko/rest?apiVersion=2022-11-28) 를 참고했습니다.

<br>

`iOS 17+` `SwiftUI` `CleanArchitecutre` `TCA` `LinkNavigator`

<br>

## 📱 앱 실행 화면 
|Repo 탭|User 탭|Like 탭|
|-|-|-|
|GitHub에 있는 Repositoriy를 검색할 수 있습니다|GitHub에 있는 User를 검색할 수 있습니다|검색 해서 들어간 항목에 대해서 <br> 좋아요를 누르면 해당 페이지에서 볼 수 있습니다.|
|<img src="https://github.com/seungchan2022/favorite/assets/110214307/d60ad391-0ce7-409b-b247-c3f9184f5a7e">|<img src="https://github.com/seungchan2022/favorite/assets/110214307/040de7cd-84e3-4ab3-a17c-68f4a6dfd8a2">|<img src="https://github.com/seungchan2022/favorite/assets/110214307/d9b8aa77-17f6-48b6-9889-ccfff80bbd6c">|
<br>

<details>
<summary><strong style="font-size: 1.2em;">다크 모드</strong></summary>

|Repo 탭|User 탭|Like 탭|
|-|-|-|
|<img src="https://github.com/seungchan2022/favorite/assets/110214307/92d3605d-a517-46e9-b7af-6ccd73e494c2">|<img src="https://github.com/seungchan2022/favorite/assets/110214307/54c2d2cf-e096-40df-a5d6-5891fa15bf2a">|<img src="https://github.com/seungchan2022/favorite/assets/110214307/f1baf31e-114a-44ff-9627-7ebc69d4f729">|
  
</details>

<br>

## 🗂️ UI 컴포넌트 분리

* 화면에 표현할 것들을 UI 컴포넌트라는 파일안에 최대한 분리하여, 해당 페이지 안에서는 UI 표현에 대한 직접적인 로직을 최대한 작성하지 않으려고 했습니다.
* 이렇게 함으로써 코드를 더욱더 구조화 할수 있고, 각 부분이 명확하게 분리되어 있어 유지보수 및 확장이 용이하면 가독성을 높일 수 있습니다.
  
<br>

<details>
<summary><strong style="font-size: 1.2em;"> 페이지 구조</strong></summary>

<br>

* 페이지에 구조에 대해서 설명하자면 먼저 구조체가 정의되어 있습니다. 이 구조체안에는 뷰 상태를 관리하고, 뷰의 데이터를 저장합니다.
* 그 다음 extension은 해당 페이지에 대한 내부 상태와 속성을 계산하는 부분입니다. 이를 통해 뷰에 필요한 데이터를 제공합니다.
* 그리고 위에서 설정할 것들과 분리한 컴포넌트들을 View에 작성하여 실제 UI를 정의합니다.

<p align="center">
  <img alt="스크린샷 2024-06-20 오후 8 17 32" src="https://github.com/seungchan2022/favorite/assets/110214307/269d4d58-0f8a-452b-a1d2-d480b75945d1" style="width: 80%;">
</p>

</details>

<br>

<p align="left">
  <img src="https://github.com/seungchan2022/Aron/assets/110214307/a4606172-57d7-43c1-9f2f-ee0ff279f6e1" alt="UI Component 1" style="width: 32%;">
  <img src="https://github.com/seungchan2022/Aron/assets/110214307/a5ae535a-b98b-4cce-8786-411b2b4a2e6e" alt="UI Component 2" style="width: 32%;">
  <img src="https://github.com/seungchan2022/Aron/assets/110214307/ba6e24e7-64b9-4e32-95ce-958de9339196" alt="UI Component 3" style="width: 32%;">
  <img src="https://github.com/seungchan2022/Aron/assets/110214307/0dcbcf73-f618-46f1-a231-fd62679a773a" alt="UI Component 4" style="width: 32%;">
  <img src="https://github.com/seungchan2022/Aron/assets/110214307/f136ab8c-8ce5-4aea-91a4-a4fd32b7f54c" alt="UI Component 5" style="width: 32%;">
  <img src="https://github.com/seungchan2022/Aron/assets/110214307/1ec4f73c-46b9-43aa-ae40-766acd50f137" alt="UI Component 6" style="width: 32%;">
  <img src="https://github.com/seungchan2022/Aron/assets/110214307/a638a7b9-9b1f-45d5-aff6-1f108b5cb117" alt="UI Component 7" style="width: 32%;">
  <img src="https://github.com/seungchan2022/Aron/assets/110214307/8beb2d77-58c1-4751-bf7c-2cc2443f161b" alt="UI Component 8" style="width: 32%;">
</p>

<br>

## 👀 예외 처리
* 예외 처리를 통해 사용자에게 현재 상태를 명확하게 전달하고, 예상치 못한 상황에서도 적절한 피드백을 제공함으로써 사용자 경험을 개선합니다.
예외 상황을 처리하는 이러한 접근 방식은 사용자가 애플리케이션을 더 쉽게 이해하고 사용할 수 있도록 도와줍니다.

<br>

### 1. 검색어가 입력되지 않았을때
---

검색어가 입력되지 않았을 때, 사용자에게 안내 메시지를 보여주어 검색 기능 사용 방법을 안내합니다.

|<img src="https://github.com/seungchan2022/Aron/assets/110214307/bb60c3d8-5a08-4f87-b63d-bd570070f9f9" alt="Empty Query Message 1" style="width: 60%;">|<img src="https://github.com/seungchan2022/Aron/assets/110214307/1bb3ee98-2730-47dd-b524-b65596c50f73" alt="Empty Query Message 2" style="width: 60%;">|
|:---:|:---:|
<br>

### 2. 좋아요 눌린 항목이 없을때
---

해당 페이지는 사용자가 좋아요 누른 항목들을 표시하는 페이지로 만약 사용자가 좋아요를 누른 항목이 없다면,
사용자에게 **"좋아요가 눌린 항목이 없습니다"** 라는 메시지를 표시합니다. 이를 통해 사용자는 현재 좋아요를 누른 항목이 없다는 것을 명확히 알 수 있습니다.

|<img src="https://github.com/seungchan2022/Aron/assets/110214307/5d55f9e5-8dee-4b55-9e1e-1668ea505b44" alt="No Liked Items 1" style="width: 60%;">|<img src="https://github.com/seungchan2022/Aron/assets/110214307/2805a427-a3b3-4720-9327-51658f4e48bc" alt="No Liked Items 2" style="width: 60%;">|
|:---:|:---:|

<br>

### 3. 데이터 로드
---

|로딩 인디케이터를 이용해 컨텐츠가 로딩되는 동안에도 어색하지 않도록 유저에게 데이터를 불러오고 있다는 직관적인 모습을 보여줄 수 있습니다.|검색 기능을 구현할 때, 사용자가 입력한 검색어에 대한 결과가 없을 경우, **"검색결과가 없습니다"** 라는 토스트(팝업) 메시지를 표시합니다. <br> 이를 통해 사용자는 현재 입력한 검색어로는 결과를 찾을 수 없다는 것을 즉시 알 수 있습니다.|
|:---:|:---:|
|<img src="https://github.com/seungchan2022/Aron/assets/110214307/3a794570-910a-4eda-aa50-a89059b0bc94" alt="Loading Indicator" style="width: 60%;">|<img src="https://github.com/seungchan2022/Aron/assets/110214307/853472e0-1341-4779-bb89-c10ae0b33ade" alt="No Search Results" style="width: 60%;">|


<br>

## ✨ 다양한 UI 표현 방식
* 검색 결과에 대해서 디테일로 이동할때 Repositoriy의 디테일로 이동할때는 웹뷰로 표현하고, User의 디테일로 이동할때는 네이티브 방식을 사용함으로써 다양한 방식으로 UI를 표현했습니다.

<br>

|<img src="https://github.com/seungchan2022/Aron/assets/110214307/5b1a7e98-dee6-4040-8650-d04d91edddef" alt="RepoDetail" style="width: 60%;">|<img src="https://github.com/seungchan2022/Aron/assets/110214307/43d5d038-02fd-4e7c-9aa2-7af4a7a077e8" alt="UserDetail" style="width: 60%;">|
|:---:|:---:|

<br>

## 📚 모둘화
* 모듈화를 함으로써 각 모듈이 독립성을 가지고, 코드를 구조화 되며, 재사용 가능하고 유지 보수를 효율적으로 만듭니다. 

<br>

<p align="center">
  <img src="https://github.com/seungchan2022/Aron/assets/110214307/65f4e77f-4083-4233-83e5-400c33bbbcf1" alt="Module" style="width: 32%;">
</p>

<br>

## 🛠️ 테스트 코드
* 테스트 코드를 작성함으로써 제가 작성한 코드가 제대로 작동하는지 확인 할 수 있으며, 코드에 대한 이해를 높여줍니다.

<p align="center">
<img src="https://github.com/seungchan2022/Aron/assets/110214307/c40e08c4-d440-44b8-aba1-725936396b3d" alt="RepoTest" style="width: 80%;">
<img src="https://github.com/seungchan2022/Aron/assets/110214307/fe603c5b-9e90-47c6-b974-fe365fb67c5d" alt="UserTest" style="width: 80%;">
<img src="https://github.com/seungchan2022/Aron/assets/110214307/854f9582-bc95-4476-bfbe-fce94fe5c93f" alt="OtherTest" style="width: 80%;">
</p>