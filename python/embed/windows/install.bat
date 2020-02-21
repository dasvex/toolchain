@echo off
SETLOCAL

set HERE=%~dp0
set PY_EMBED_DOWNLOAD=https://www.python.org/ftp/python/3.8.1/python-3.8.1-embed-amd64.zip
set UNZIP_DOWNLOAD=http://stahlworks.com/dev/unzip.exe
set GET_PIP_DOWNLOAD=https://bootstrap.pypa.io/get-pip.py
set PY_BIN_DEFAULT=%HERE%\bin
set PY_INSTAL=%HERE%\installer
set PY_PTH_FILE_NAME=python38._pth

if "%~1"=="" (
    set PY_BIN=%PY_BIN_DEFAULT%
) else (
    set PY_BIN=%1
)

IF EXIST %PY_BIN%\python.exe (
    echo ... python already installed '%PY_BIN%\python.exe'
) ELSE (
    echo ... try install python into '%PY_BIN%'

    IF EXIST %PY_BIN% (
        echo ... remove python from '%PY_BIN%'
        rmdir  /S /Q "%PY_BIN%"
    )

    IF EXIST %PY_INSTAL% (
        echo ... clean python installer tmp files from '%PY_INSTAL%'    
        rmdir /S /Q %PY_INSTAL%
    )
    
    echo ... create temp instalation folder '%PY_INSTAL%'
    mkdir %PY_INSTAL%
    
    echo ... download python
    curl %PY_EMBED_DOWNLOAD% -o %PY_INSTAL%\python.zip
    if NOT EXIST %PY_INSTAL%\python.zip echo ... download fail & GOTO exitFail
    
    echo ... download unzip
    curl %UNZIP_DOWNLOAD% -o %PY_INSTAL%\unzip.exe
    if NOT EXIST %PY_INSTAL%\unzip.exe echo ... download fail & GOTO exitFail

    echo ... download get-pip
    curl %GET_PIP_DOWNLOAD% -o %PY_INSTAL%\get-pip.py
    if NOT EXIST %PY_INSTAL%\get-pip.py echo ... download fail & GOTO exitFail

    echo ... unzip python into '%PY_BIN%'
    unzip -q -o %PY_INSTAL%/python.zip -d "%PY_BIN%"

    echo ... install pip
    %PY_BIN%\python.exe %PY_INSTAL%\get-pip.py
    
    echo ... python import site
    echo import site>>"%PY_BIN%\%PY_PTH_FILE_NAME%"
    
    echo ... install default packages...
    %PY_BIN%\python.exe -m pip -q install requests

    echo ... python add sitecustomize.py
    copy sitecustomize.py %PY_BIN%\Lib\site-packages

    echo ... cleanup
    rmdir /S /Q %PY_INSTAL%

    echo ... Done! python installed '%PY_BIN%\python.exe'
)

ENDLOCAL
EXIT /B %ERRORLEVEL%

:exitFail
    ENDLOCAL
    EXIT /B %ERRORLEVEL%