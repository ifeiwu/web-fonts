@echo off

setLocal EnableDelayedExpansion

echo.
echo    请输入要压缩网页字体的字数：
echo      1、英文
echo      2、500 汉字(简体)
echo      3、1000 汉字(简体)
echo      4、1500 汉字(简体)
echo      5、2000 汉字(简体) - 默认
echo      6、2500 汉字(简体)
echo      7、3000 汉字(简体)
echo      8、3500 汉字(简体)
echo      9、4000 汉字(简体)
echo      10、5000 汉字(简体)
echo      11、7000 汉字(简体)
echo.

set /p num=请输入编号：

set end_msg=网页字体转换完成，请在 css 目录下查看。

set font_src_lang=zh
set text_lang=zh-cn
set text_word=2000

if /i "!num!"=="1" (
    set font_src_lang=en
    set text_lang=en
    set text_word=
) else if /i "!num!"=="2" (
    set text_word=500
) else if /i "!num!"=="3" (
    set text_word=1000
) else if /i "!num!"=="4" (
    set text_word=1500
) else if /i "!num!"=="5" (
	set text_word=2000
) else if /i "!num!"=="6" (
	set text_word=2500
) else if /i "!num!"=="7" (
	set text_word=3000
) else if /i "!num!"=="8" (
	set text_word=3500
) else if /i "!num!"=="9" (
	set text_word=4000
) else if /i "!num!"=="10" (
	set text_word=5000
) else if /i "!num!"=="11" (
	set text_word=7000
)

set text_file=!text_lang!-!text_word!

if not "!font_src_lang!"=="en" (
    echo.
    echo 导入文件 !text_file!.txt
    echo.
)

set root_dir=%~dp0
set fontsrc_dir=!root_dir!font-src\!font_src_lang!
set text_word_dir=!text_word!\!text_lang!

if /i "!text_lang!"=="en" (
    set text_word_dir=en
)

cd !fontsrc_dir!

for /d %%d in (*) do (

    set lower_dir=%%d

    for %%i in (a b c d e f g h i j k l m n o p q r s t u v w x y z) do call set lower_dir=%%lower_dir:%%i=%%i%%
    
    set css_dir="!root_dir!css\!text_word_dir!\!lower_dir!"
    
	if not exist "!css_dir!" (
    
        md "!css_dir!"
        
        set fontmin_dir=!root_dir!font-min\%%d
        
        if not exist "!fontmin_dir!" md "!fontmin_dir!"
        
        cd !fontsrc_dir!\%%d

        for /f "delims=" %%f in ('dir /b /a-d "*.ttf"') do (
            
            set filename=%%~nf
            
            set font_weight=400
            
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
            
            pyftsubset !fontsrc_dir!\%%d\%%~nf.ttf --output-file=!fontmin_dir!\%%~nf.ttf --text-file=!root_dir!!text_file!.txt --no-hinting
            
            fonttools ttLib.woff2 compress -o "!css_dir!\%%~nf.woff2" "!fontmin_dir!\%%~nf.ttf"

            set cssfile=!css_dir!\!lower_dir!.css
            
            set csscontent=@font-face{font-family:''%%d'';src:url^(''!filename!.woff2''^) format^(''woff2''^);font-weight:!font_weight!;font-style:normal;font-display:swap;}
            
            pwsh -Command "'!csscontent!' | Out-File -Append ('!cssfile!') -Encoding utf8NoBOM"
        )
    )
)

if exist "!root_dir!font-min" rd /s /q "!root_dir!font-min"

echo.
echo !end_msg!
echo.

pause

@echo on