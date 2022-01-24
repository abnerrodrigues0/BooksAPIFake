*** Settings ***
Documentation  Documentação da API:  https://fakerestapi.azurewebsites.net/api/v1/
Library            RequestsLibrary
Library            Collections

*** Variable ***
${URL_API}      https://fakerestapi.azurewebsites.net/api/v1/
&{BOOK_15}      id=15
...             title=Book 15
...             pageCount=1500
&{BOOK_201}     id=1212
...             title=TesteNovoLIvro
...             description=newbooksdescription
...             pageCount=1000
...             excerpt=newbooksdescription
...             publishDate=2018-04-26T17:58:14.765Z
&{BOOK_50}      id=50
...             title=AlteraçãodesselvioTesteNovoLIvro
...             description=newbooksdescriptionalteration
...             pageCount=1000
...             excerpt=newbooksdescriptionalteration
...             publishDate=2018-04-26T17:58:14.765Z



*** Keywords ***
####SETUP E TEARDOWN######
Conectar a minha API
    Create Session      FakeAPI     ${URL_API} 
    ${HEADERS}      Create Dictionary       content-type=application/json
    Set Suite Variable    ${HEADERS}


####AÇÕES(PASSO A PASSO#####
Requisitar todos os livros
    ${RESPOSTA}     Get Request      FakeAPI     Books
    Log             ${RESPOSTA.text}
    Set Test Variable       ${RESPOSTA}

Requisitar o livro "${ID_LIVRO}"
    ${RESPOSTA}     Get Request      FakeAPI     Books/${ID_LIVRO}
    Log             ${RESPOSTA.text}
    Set Test Variable       ${RESPOSTA}


Cadastrar um novo livro
    ${RESPOSTA}    Post Request   fakeAPI    Books
    ...                           data={"ID": ${BOOK_201.id},"Title": "${BOOK_201.title}","Description": "${BOOK_201.description}","PageCount": ${BOOK_201.pageCount},"Excerpt": "${BOOK_201.excerpt}","PublishDate": "${BOOK_201.publishDate}"}
    ...                           headers=${HEADERS}
    Log            ${RESPOSTA.text}
    Set Test Variable    ${RESPOSTA}

Alterar o livro ${ID_LIVRO}
    ${RESPOSTA}    Post Request   fakeAPI    Books
    ...                           data={"ID": ${BOOK_50.id},"Title": "${BOOK_50.title}","Description": "${BOOK_50.description}","PageCount": ${BOOK_50.pageCount},"Excerpt": "${BOOK_50.excerpt}","PublishDate": "${BOOK_50.publishDate}"}
    ...                           headers=${HEADERS}
    Log            ${RESPOSTA.text}
    Set Test Variable    ${RESPOSTA}

Excluir o livro "${ID_LIVRO}"
    ${RESPOSTA}     Delete Request      FakeAPI     Books/${ID_LIVRO}
    Log             ${RESPOSTA.text}
    Set Test Variable       ${RESPOSTA}



###CONFERÊNCIAS

Conferir status code    
    [Arguments]                 ${STATUSCODE_DESEJADO}
    Should Be Equal As Strings  ${RESPOSTA.status_code}  ${STATUSCODE_DESEJADO}

Conferir o reason 
    [Arguments]                  ${REASON_DESEJADO}
    Should Be Equal As Strings   ${RESPOSTA.reason}  ${REASON_DESEJADO}


Conferir se retorna uma lista de "${QTD_LIVROS}" livros
    Length Should Be        ${RESPOSTA.json()}      ${QTD_LIVROS}


Conferir se retorna todos os dados corretos do livro 15
    Dictionary Should Contain Item    ${RESPOSTA.json()}    id              ${BOOK_15.id}
    Dictionary Should Contain Item    ${RESPOSTA.json()}    title           ${BOOK_15.title}
    Dictionary Should Contain Item    ${RESPOSTA.json()}    pageCount       ${BOOK_15.pageCount}
    Should Not Be Empty    ${RESPOSTA.json()["description"]}
    Should Not Be Empty    ${RESPOSTA.json()["excerpt"]}
    Should Not Be Empty    ${RESPOSTA.json()["publishDate"]}


Conferir livro
    [Arguments]     ${ID_LIVRO}
    Dictionary Should Contain Item    ${RESPOSTA.json()}    id              ${BOOK_${ID_LIVRO}.id}
    Dictionary Should Contain Item    ${RESPOSTA.json()}    title           ${BOOK_${ID_LIVRO}.title}
    Dictionary Should Contain Item    ${RESPOSTA.json()}    description     ${BOOK_${ID_LIVRO}.description}
    Dictionary Should Contain Item    ${RESPOSTA.json()}    pageCount       ${BOOK_${ID_LIVRO}.pageCount}
    Dictionary should Contain Item    ${RESPOSTA.json()}    excerpt         ${BOOK_${ID_LIVRO}.excerpt}
    Dictionary Should Contain Item    ${RESPOSTA.json()}    publishDate     ${BOOK_${ID_LIVRO}.publishDate}


Conferir se retorna todos os dados do livro "${ID_LIVRO}"
    Conferir livro      ${ID_LIVRO}


Conferir se retorna todos os dados ALTERADOS do livro "${ID_LIVRO}"
    Conferir livro      ${ID_LIVRO}


Conferir se exclui o livro "${ID_LIVRO}"
    Should Be Empty     ${RESPOSTA.content}

