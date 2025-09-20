@echo off
chcp 65001 >nul 2>&1
setlocal enabledelayedexpansion
title GitHub 快速切換工具

echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                ⚡ GitHub 快速切換工具                        ║
echo ║              一鍵切換不同專案的認證設定                      ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

echo 請選擇要切換到的專案：
echo.
echo 1. 🍽️  餐開月行程表 (sky770825)
echo 2. 🏠  濬聯配件專用 (liny14705)
echo 3. ➕ 添加新專案
echo 4. 🔧 修復當前認證
echo 5. ❌ 退出
echo.

set /p choice=請選擇 (1-5): 

if "%choice%"=="1" goto switch_niceshow_sky
if "%choice%"=="2" goto switch_niceshow_liny
if "%choice%"=="3" goto add_new_project
if "%choice%"=="4" goto fix_current_auth
if "%choice%"=="5" goto exit
goto main

:switch_niceshow_sky
echo.
echo 🔄 正在切換到餐開月行程表專案 (sky770825)...
echo.

REM 清除現有認證
echo 清除現有認證...
cmdkey /delete:git:https://github.com >nul 2>&1
git config --global --unset credential.helper >nul 2>&1

REM 設定餐開月行程表專案 (sky770825)
echo 設定專案認證...
git config --global user.name "sky770825"
git config --global user.email "sky19880825@gmail.com"

REM 設定遠端倉庫
echo 設定遠端倉庫...
git remote remove origin >nul 2>&1
git remote add origin https://github.com/sky770825/niceshow.git

echo.
echo ✅ 已切換到餐開月行程表專案 (sky770825)
echo 📋 專案資訊：
echo    用戶名: sky770825
echo    電子郵件: sky19880825@gmail.com
echo    倉庫: https://github.com/sky770825/niceshow.git
echo    網站: https://sky770825.github.io/niceshow
echo.

echo 是否要立即推送變更？ (y/n)
set /p push_choice=請選擇: 
if /i "%push_choice%"=="y" (
    echo.
    echo 🚀 正在推送變更...
    git add . >nul 2>&1
    git commit -m "切換到餐開月行程表專案 (sky770825) - %date% %time%" >nul 2>&1
    git push origin main
    if errorlevel 1 (
        echo ❌ 推送失敗，可能需要 Personal Access Token
        echo 💡 請使用完整的專案切換工具進行詳細設定
    ) else (
        echo ✅ 推送成功！
    )
)

echo.
echo 按任意鍵返回主選單...
pause >nul
goto main

:switch_niceshow_liny
echo.
echo 🔄 正在切換到濬聯配件專用專案 (liny14705)...
echo.

REM 清除現有認證
echo 清除現有認證...
cmdkey /delete:git:https://github.com >nul 2>&1
git config --global --unset credential.helper >nul 2>&1

REM 設定濬聯配件專用專案 (liny14705)
echo 設定專案認證...
git config --global user.name "liny14705"
git config --global user.email "liny14705@gmail.com"

REM 設定遠端倉庫
echo 設定遠端倉庫...
git remote remove origin >nul 2>&1
git remote add origin https://github.com/liny14705/nicehouse.git

echo.
echo ✅ 已切換到濬聯配件專用專案 (liny14705)
echo 📋 專案資訊：
echo    用戶名: liny14705
echo    電子郵件: liny14705@gmail.com
echo    倉庫: https://github.com/liny14705/nicehouse.git
echo    網站: https://liny14705.github.io/nicehouse
echo.

echo 是否要立即推送變更？ (y/n)
set /p push_choice=請選擇: 
if /i "%push_choice%"=="y" (
    echo.
    echo 🚀 正在推送變更...
    git add . >nul 2>&1
    git commit -m "切換到濬聯配件專用專案 (liny14705) - %date% %time%" >nul 2>&1
    git push origin main
    if errorlevel 1 (
        echo ❌ 推送失敗，可能需要 Personal Access Token
        echo 💡 請使用完整的專案切換工具進行詳細設定
    ) else (
        echo ✅ 推送成功！
    )
)

echo.
echo 按任意鍵返回主選單...
pause >nul
goto main

:add_new_project
echo.
echo ➕ 添加新專案
echo.
set /p new_name=專案名稱: 
set /p new_username=GitHub 用戶名: 
set /p new_email=GitHub 電子郵件: 
set /p new_repo=倉庫 URL (https://github.com/username/repo.git): 
set /p new_website=網站 URL (https://username.github.io/repo): 

echo.
echo 🔄 正在切換到新專案...

REM 清除現有認證
cmdkey /delete:git:https://github.com >nul 2>&1
git config --global --unset credential.helper >nul 2>&1

REM 設定新專案
git config --global user.name "%new_username%"
git config --global user.email "%new_email%"
git remote remove origin >nul 2>&1
git remote add origin "%new_repo%"

echo.
echo ✅ 已切換到新專案: %new_name%
echo 📋 專案資訊：
echo    用戶名: %new_username%
echo    電子郵件: %new_email%
echo    倉庫: %new_repo%
echo    網站: %new_website%
echo.

echo 是否要立即推送變更？ (y/n)
set /p push_choice=請選擇: 
if /i "%push_choice%"=="y" (
    echo.
    echo 🚀 正在推送變更...
    git add . >nul 2>&1
    git commit -m "切換到 %new_name% 專案 - %date% %time%" >nul 2>&1
    git push origin main
    if errorlevel 1 (
        echo ❌ 推送失敗，可能需要 Personal Access Token
    ) else (
        echo ✅ 推送成功！
    )
)

echo.
echo 按任意鍵返回主選單...
pause >nul
goto main

:fix_current_auth
echo.
echo 🔧 修復當前認證
echo.

echo 當前設定：
git config --global user.name
git config --global user.email
git remote -v
echo.

set /p fix_username=請輸入正確的 GitHub 用戶名: 
set /p fix_email=請輸入正確的 GitHub 電子郵件: 

REM 清除現有認證
cmdkey /delete:git:https://github.com >nul 2>&1
git config --global --unset credential.helper >nul 2>&1

REM 設定新認證
git config --global user.name "%fix_username%"
git config --global user.email "%fix_email%"

echo.
echo ✅ 認證已修復
echo.

echo 正在嘗試推送...
git add . >nul 2>&1
git commit -m "修復認證問題 - %date% %time%" >nul 2>&1
git push origin main

echo.
echo 按任意鍵返回主選單...
pause >nul
goto main

:main
cls
goto :eof

:exit
echo.
echo 👋 感謝使用！
echo.
pause
exit
