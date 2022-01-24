*** Settings ***
Documentation  Documentação da API:  https://fakerestapi.azurewebsites.net/api/v1/
Resource        ResourceAPI.robot
Suite Setup     Conectar a minha API

*** Test Case ***
Buscar a listagem de todos os livros (GET em todos os livros)
    Requisitar todos os livros
    Conferir status code  200
    Conferir o reason  OK
    Conferir se retorna uma lista de "200" livros


Buscar livro especifico (GET em um livro especifico)
    Requisitar o livro "15"
    Conferir status code  200
    Conferir o reason  OK
    Conferir se retorna todos os dados corretos do livro 15

Cadastrar um novo livro (POST)
    Cadastrar um novo livro
    Conferir status code  200
    Conferir o reason  OK
    Conferir se retorna todos os dados do livro "201"


Alterar um livro (PUT)
    Alterar o livro "50"
    Conferir status code  200
    Conferir o reason  OK
    Conferir se retorna todos os dados ALTERADOS do livro "50"

Deletar um livro (DELETE)
    Excluir o livro "10"
    Conferir status code  200
    Conferir o reason  OK
    Conferir se exclui o livro "10"

