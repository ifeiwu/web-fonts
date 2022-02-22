@echo off

setLocal EnableDelayedExpansion

echo.
echo    请输入压缩字体转网页字体：
echo      1、2000 汉字(简体中文) - 默认
echo      2、2000 汉字(繁体中文)
echo      3、3500 汉字(简体中文)
echo.

set /p num=请输入编号：

set end_msg=网页字体转换完成，请在 web 目录下查看。

set text_file=zh-cn-2000

if /i "!num!"=="2" (
	set text_file=zh-tw-2000
) else if /i "!num!"=="3" (
	set text_file=zh-cn-3500
)

echo.
echo 导入文件 !text_file!.txt
echo.

set root_dir=%~dp0

cd font-src

for /d %%d in (*) do (

    set lower_dir=%%d

    for %%i in (a b c d e f g h i j k l m n o p q r s t u v w x y z) do call set lower_dir=%%lower_dir:%%i=%%i%%
    
    set fontmin_dir="%root_dir%font-min\!lower_dir!"
	if not exist "!fontmin_dir!" (
    
        md "!fontmin_dir!"
        
        set web_dir="%root_dir%web\!lower_dir!"
        
        if exist "!web_dir!" rd /s /q "!web_dir!"
        
        md "!web_dir!"
        
        cd %root_dir%font-src\%%d
        
        for /f "delims=" %%f in ('dir /b /a-d "*.ttf"') do (
            
            set filename=%%~nf
            
            if not "!filename:-Heavy=!"=="!filename!" (
                set font_weight=900
            ) else if not "!filename:-Black=!"=="!filename!" (
                set font_weight=900
            ) else if not "!filename:-ExtraBold=!"=="!filename!" (
                set font_weight=800
            ) else if not "!filename:-Bold=!"=="!filename!" (
                set font_weight=700
            ) else if not "!filename:-Semibold=!"=="!filename!" (
                set font_weight=600
            ) else if not "!filename:-Demibold=!"=="!filename!" (
                set font_weight=600
            ) else if not "!filename:-Medium=!"=="!filename!" (
                set font_weight=500
            ) else if not "!filename:-Normal=!"=="!filename!" (
                set font_weight=400
            ) else if not "!filename:-Regular=!"=="!filename!" (
                set font_weight=400
            ) else if not "!filename:-Light=!"=="!filename!" (
                set font_weight=300
            ) else if not "!filename:-ExtraLight=!"=="!filename!" (
                set font_weight=200
            ) else if not "!filename:-Thin=!"=="!filename!" (
                set font_weight=100
            )
            
            pyftsubset %root_dir%font-src\%%d\%%~nf.ttf --output-file=%root_dir%font-min\%%d\%%~nf.ttf --text-file=%root_dir%!text_file!.txt --no-hinting
            
            fonttools ttLib.woff2 compress -o "%root_dir%web\!lower_dir!\%%~nf.woff2" "%root_dir%font-min\!lower_dir!\%%~nf.ttf"
            
            set cssfile=%root_dir%web\!lower_dir!\!lower_dir!.css
            
            set csscontent=@font-face{font-family:''%%d'';src:url^(''!filename!.woff2''^) format^(''woff2''^);font-weight:!font_weight!;font-style:normal;font-display:swap;}
            
            pwsh -Command "'!csscontent!' | Out-File -Append ('!cssfile!') -Encoding utf8NoBOM"
        )
    )
)

echo.
echo !end_msg!
echo.

pause

@echo on