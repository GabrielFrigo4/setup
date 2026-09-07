@echo off
setlocal
rem ----------------------------------------------------------------------------
rem Recipe: Game of Trees (Got) Configuration (Windows)
rem ----------------------------------------------------------------------------

set "GOT_CONF=%USERPROFILE%\.gotconfig"

if defined GIT_AUTHOR_NAME if defined GIT_AUTHOR_EMAIL (
    (
        echo author "%GIT_AUTHOR_NAME% <%GIT_AUTHOR_EMAIL%>"
    ) > "%GOT_CONF%"
    echo [Got]: Arquivo "%GOT_CONF%" configurado com sucesso.
) else (
    echo [Got]: Variaveis GIT_AUTHOR_NAME ou GIT_AUTHOR_EMAIL nao definidas.
)

endlocal
