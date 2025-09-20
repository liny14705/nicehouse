@echo off
chcp 65001 >nul 2>&1
setlocal enabledelayedexpansion
title 餐開月行程表管理工具

:start
cls
echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                    🍽️ 餐開月行程表管理工具                    ║
echo ║                       版本 2.0 - 簡化版                      ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.
echo 請選擇操作：
echo.
echo  📁 檔案管理
echo  ┌─────────────────────────────────────────────────────────────┐
echo  │ 1. 快速上傳到 GitHub (推薦)                                │
echo  │ 2. 檢查檔案狀態                                           │
echo  │ 3. 建立版本備份                                           │
echo  └─────────────────────────────────────────────────────────────┘
echo.
echo  🚀 部署管理
echo  ┌─────────────────────────────────────────────────────────────┐
echo  │ 4. 部署指定版本                                           │
echo  │ 5. 下架所有檔案                                           │
echo  └─────────────────────────────────────────────────────────────┘
echo.
echo  ⚙️ 系統設定
echo  ┌─────────────────────────────────────────────────────────────┐
echo  │ 6. 初始化/連接 GitHub 倉庫                                │
echo  │ 7. 修復同步問題                                           │
echo  │ 8. 檢查認證狀態                                           │
echo  └─────────────────────────────────────────────────────────────┘
echo.
echo  📊 資訊查看
echo  ┌─────────────────────────────────────────────────────────────┐
echo  │ 9. 查看版本資訊                                           │
echo  │ 0. 退出程式                                               │
echo  └─────────────────────────────────────────────────────────────┘
echo.

set /p choice=請輸入選項 (0-9): 

if "%choice%"=="1" goto quick_upload
if "%choice%"=="2" goto check_files
if "%choice%"=="3" goto create_backup
if "%choice%"=="4" goto deploy_version
if "%choice%"=="5" goto cleanup_github
if "%choice%"=="6" goto init_git
if "%choice%"=="7" goto fix_sync
if "%choice%"=="8" goto check_auth
if "%choice%"=="9" goto show_info
if "%choice%"=="0" goto exit
echo.
echo ❌ 無效選項，請重新選擇
timeout /t 2 >nul
goto start

:quick_upload
cls
echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                    ⚡ 快速上傳到 GitHub                      ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

REM 檢查Git狀態
git remote get-url origin >nul 2>&1
if errorlevel 1 (
    echo ❌ 沒有發現GitHub倉庫
    echo 請先使用「初始化/連接 GitHub 倉庫」功能
    echo.
    pause
    goto start
)

REM 顯示專案資訊
for /f "tokens=4,5 delims=/" %%i in ('git remote get-url origin') do (
    set current_user=%%i
    set current_repo=%%j
)
set current_repo=%current_repo:.git=%
echo 📋 當前專案：%current_user%/%current_repo%
echo.

echo 🔄 正在上傳檔案...
echo.

echo 步驟1: 添加所有檔案...
git add .
if errorlevel 1 (
    echo ❌ 添加檔案失敗
    pause
    goto start
)
echo ✅ 檔案已添加

echo.
echo 步驟2: 提交變更...
set commit_msg=更新餐開月行程表 - %date% %time%
git commit -m "!commit_msg!"
if errorlevel 1 (
    echo ❌ 提交失敗
    pause
    goto start
)
echo ✅ 變更已提交

echo.
echo 步驟3: 推送到GitHub...
git push origin main
if errorlevel 1 (
    echo ❌ 推送到main失敗，嘗試master...
    git push origin master
    if errorlevel 1 (
        echo ❌ 推送失敗
        echo.
        echo 可能原因：
        echo - 網路連接問題
        echo - GitHub認證問題
        echo - 倉庫權限問題
        echo.
        echo 建議使用「修復同步問題」功能
        pause
        goto start
    ) else (
        echo ✅ 已推送到master分支
    )
) else (
    echo ✅ 已推送到main分支
)

echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                        🎉 上傳完成！                        ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.
echo 🌐 您的網站地址：
echo %current_user%.github.io/%current_repo%
echo.
pause
goto start

:check_files
cls
echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                    🔍 檢查檔案狀態                          ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

echo 📁 本地檔案列表：
echo ┌─────────────────────────────────────────────────────────────┐
dir /b *.html *.css *.js *.json *.md 2>nul
echo └─────────────────────────────────────────────────────────────┘

echo.
echo 📊 Git狀態：
echo ┌─────────────────────────────────────────────────────────────┐
git status --short
echo └─────────────────────────────────────────────────────────────┘

echo.
echo 🌐 GitHub狀態：
git remote get-url origin >nul 2>&1
if errorlevel 1 (
    echo ❌ 未連接GitHub倉庫
) else (
    echo ✅ 已連接GitHub倉庫
    for /f "tokens=4,5 delims=/" %%i in ('git remote get-url origin') do (
        set current_user=%%i
        set current_repo=%%j
    )
    set current_repo=%current_repo:.git=%
    echo 📋 倉庫：%current_user%/%current_repo%
)

echo.
pause
goto start

:create_backup
cls
echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                    💾 建立版本備份                          ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

set /p version=請輸入版本號 (如 v2.1): 

if "%version%"=="" (
    echo ❌ 版本號不能為空！
    pause
    goto start
)

echo.
echo 正在建立 %version% 資料夾...
mkdir %version% 2>nul

echo 正在複製檔案...
copy index.html %version%\ 2>nul
copy script.js %version%\ 2>nul
copy style.css %version%\ 2>nul
copy data.json %version%\ 2>nul
copy admin.html %version%\ 2>nul
copy *.md %version%\ 2>nul
copy tablet_*.html %version%\ 2>nul

echo.
echo ✅ 版本備份完成！
echo 📁 備份位置：%version% 資料夾
echo.

set /p deploy_now=是否立即部署此版本？(y/n): 
if /i "%deploy_now%"=="y" (
    echo 正在部署版本 %version%...
    goto deploy_version
)

echo.
pause
goto start

:deploy_version
cls
echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                    📦 部署指定版本                          ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

echo 可用的版本：
dir /b | findstr "^v" 2>nul
if errorlevel 1 (
    echo ❌ 沒有找到版本資料夾！
    echo 請先使用「建立版本備份」功能
    echo.
    pause
    goto start
)

echo.
set /p version=請輸入要部署的版本號: 

if "%version%"=="" (
    echo ❌ 版本號不能為空！
    pause
    goto start
)

if not exist "%version%" (
    echo ❌ 版本資料夾不存在：%version%
    pause
    goto start
)

echo.
echo 🚀 正在部署版本：%version%
echo.

echo 步驟1: 備份當前檔案...
if not exist "backup_current" mkdir backup_current
copy *.html backup_current\ 2>nul
copy *.css backup_current\ 2>nul
copy *.js backup_current\ 2>nul
copy *.json backup_current\ 2>nul
copy *.md backup_current\ 2>nul
echo ✅ 當前檔案已備份

echo.
echo 步驟2: 複製版本檔案...
copy "%version%\*" . 2>nul
echo ✅ 版本檔案已複製

echo.
echo 步驟3: 上傳到GitHub...
git add .
git commit -m "部署版本 %version% - %date% %time%"
git push origin main
if errorlevel 1 (
    git push origin master
    if errorlevel 1 (
        echo ❌ 部署失敗
        pause
        goto start
    )
)

echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                        🎉 部署完成！                        ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.
echo 📋 部署資訊：
echo 版本：%version%
echo 時間：%date% %time%
echo.
pause
goto start

:cleanup_github
cls
echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                    🗑️ 下架所有檔案                          ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

echo ⚠️  警告：這將刪除GitHub上的所有檔案！
echo.
echo 下架後的效果：
echo - GitHub Repository 會變成空白
echo - 網站會無法顯示
echo - 所有檔案都會被移除
echo.

set /p confirm=確定要下架所有檔案嗎？(y/n): 

if /i not "%confirm%"=="y" (
    echo 操作已取消
    pause
    goto start
)

echo.
echo 正在下架檔案...
git rm -r --cached .
git commit -m "下架所有檔案 - %date% %time%"
git push origin main
if errorlevel 1 (
    git push origin master
)

echo.
echo ✅ 下架完成！
echo.
pause
goto start

:init_git
cls
echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                🔗 初始化/連接 GitHub 倉庫                   ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

echo 請輸入您的 GitHub 倉庫連結：
echo 範例：https://github.com/username/repository-name
echo.
set /p repo_url=請輸入 GitHub 連結: 

if "%repo_url%"=="" (
    echo ❌ 連結不能為空！
    pause
    goto start
)

echo.
echo 正在驗證連結格式...
echo %repo_url% | findstr "github.com" >nul
if errorlevel 1 (
    echo ❌ 無效的 GitHub 連結格式
    pause
    goto start
)

echo ✅ 連結格式正確

echo.
echo 正在處理 URL 格式...
if "%repo_url:~-4%"==".git" (
    echo ✅ URL 已包含 .git 後綴
) else (
    set repo_url=%repo_url%.git
    echo ✅ 已自動添加 .git 後綴
)

echo.
echo 正在初始化 Git 倉庫...
if exist ".git" (
    git remote remove origin 2>nul
) else (
    git init
)

git remote add origin %repo_url%
git config user.name "餐開月行程表管理工具"
git config user.email "admin@example.com"

echo.
echo 正在添加檔案...
git add .
git commit -m "初始化餐開月行程表 - %date% %time%"

echo.
echo 正在推送到 GitHub...
git push -u origin main
if errorlevel 1 (
    git push -u origin master
    if errorlevel 1 (
        echo ❌ 推送失敗
        echo 請檢查網路連接和倉庫權限
        pause
        goto start
    )
)

echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                    🎉 初始化完成！                          ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.
echo 🌐 您的網站地址：
echo %repo_url:~0,-4%.github.io/%repo_url:~19%
echo.
pause
goto start

:fix_sync
cls
echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                    🔧 修復同步問題                          ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

echo 正在修復 Git 同步問題...
echo.

echo 步驟1: 獲取遠端內容...
git fetch origin
if errorlevel 1 (
    echo ❌ 獲取遠端內容失敗
    pause
    goto start
)

echo 步驟2: 合併遠端內容...
git merge origin/main --allow-unrelated-histories
if errorlevel 1 (
    git reset --hard origin/main
)

echo 步驟3: 添加檔案...
git add .

echo 步驟4: 提交變更...
git commit -m "修復同步問題 - %date% %time%"

echo 步驟5: 推送到 GitHub...
git push origin main
if errorlevel 1 (
    git push origin master
)

echo.
echo ✅ 同步問題已修復！
echo.
pause
goto start

:check_auth
cls
echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                    🔍 檢查認證狀態                          ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

echo Git 用戶資訊：
echo ┌─────────────────────────────────────────────────────────────┐
git config --get user.name
git config --get user.email
echo └─────────────────────────────────────────────────────────────┘

echo.
echo 遠端倉庫：
echo ┌─────────────────────────────────────────────────────────────┐
git remote -v
echo └─────────────────────────────────────────────────────────────┘

echo.
echo 測試 GitHub 連接...
git ls-remote origin >nul 2>&1
if errorlevel 1 (
    echo ❌ 無法連接到 GitHub
    echo 建議：檢查認證設定或使用 Personal Access Token
) else (
    echo ✅ GitHub 連接正常
)

echo.
pause
goto start

:show_info
cls
echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                    📊 查看版本資訊                          ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

echo 本地版本：
echo ┌─────────────────────────────────────────────────────────────┐
dir /b | findstr "^v" 2>nul
echo └─────────────────────────────────────────────────────────────┘

echo.
echo Git 狀態：
echo ┌─────────────────────────────────────────────────────────────┐
git status --short
echo └─────────────────────────────────────────────────────────────┘

echo.
echo 最近提交記錄：
echo ┌─────────────────────────────────────────────────────────────┐
git log --oneline -5 2>nul
echo └─────────────────────────────────────────────────────────────┘

echo.
pause
goto start

:exit
cls
echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                👋 感謝使用餐開月行程表管理工具！             ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.
echo 🌐 您的網站地址：
git remote get-url origin >nul 2>&1
if not errorlevel 1 (
    for /f "tokens=4,5 delims=/" %%i in ('git remote get-url origin') do (
        set current_user=%%i
        set current_repo=%%j
    )
    set current_repo=%current_repo:.git=%
    echo %current_user%.github.io/%current_repo%
) else (
    echo 無法取得倉庫資訊
)
echo.
echo 再見！👋
timeout /t 3 >nul
exit
