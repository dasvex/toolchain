@echo off
call:makeExports
EXIT /B %ERRORLEVEL%


::--------------------------------------------------------
::-- Function section starts below here ------------------
::--------------------------------------------------------
:makeExports
    set HERE=%~dp0
    set ENV=%HERE%/.exports.bat


    Setlocal EnableDelayedExpansion

    IF exist %ENV% (
        rem read ENV file and escape characters . Then set dynamically environment valuable
        for /f "tokens=*" %%a in (%ENV%) do (
            set "line=%%a"
            set "line=!line:%%=%%%%!"
            set "line=!line:""=""""!"
            echo invoke export "!line!"
            call !line!
        )
    )

    type nul>%ENV%
    echo REM make exports>>%ENV%

    call:getEnvOrDefault mvn %%%%M2_HOME%%%%\bin\mvn
    echo set mvn=!ENV_RES_VALUE!>>%ENV%

    call:getEnvOrDefault JAVA_HOME %%%%JAVA_HOME%%%%
    echo set JAVA_HOME=!ENV_RES_VALUE!>>%ENV%

    call:getEnvOrDefault java %%%%JAVA_HOME%%%%\bin\java.exe
    echo set java=!ENV_RES_VALUE!>>%ENV%

    call:getEnvOrDefault ssh ssh
    echo set ssh=!ENV_RES_VALUE!>>%ENV%

    call:getEnvOrDefault scp scp
    echo set scp=!ENV_RES_VALUE!>>%ENV%
    Setlocal DisableDelayedExpansion

    rem make true export
    Call "%ENV%"
    GOTO:EOF
::--------------------------------------------------------
::--------------------------------------------------------
:getEnvOrDefault
    SET ENV_VARIABLE=%~1
    SET ENV_VALUE=!%ENV_VARIABLE%!
    SET DEF_VALUE=%~2
    IF "%ENV_VALUE%"=="" (
        SET ENV_RES_VALUE=%DEF_VALUE%
    ) else (
        SET ENV_RES_VALUE=%ENV_VALUE%
    )
    echo "%ENV_VARIABLE%"="%ENV_RES_VALUE%" [default:"%DEF_VALUE%"][before:"%ENV_VALUE%"]
    GOTO:EOF
