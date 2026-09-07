@echo off
setlocal
rem ----------------------------------------------------------------------------
rem Recipe: Git Global Configuration (Windows)
rem ----------------------------------------------------------------------------

if defined GIT_AUTHOR_NAME (
    git config --global user.name "%GIT_AUTHOR_NAME%"
)

if defined GIT_AUTHOR_EMAIL (
    git config --global user.email "%GIT_AUTHOR_EMAIL%"
)

git config --global init.defaultBranch main
git config --global pull.rebase false
git config --global core.autocrlf true
git config --global core.quotepath false
git config --global core.hooksPath .githooks

echo [Git]: Configuracao global concluida com sucesso.
endlocal
