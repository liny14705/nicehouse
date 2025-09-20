@echo off
chcp 65001 >nul 2>&1
setlocal enabledelayedexpansion

REM 添加錯誤處理和調試信息
echo 正在啟動 GitHub 管理工具...
echo 當前目錄: %CD%
echo.

REM 檢查 Git 是否安裝
git --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Git 未安裝或未正確配置
    echo 請先安裝 Git: https://git-scm.com/
    echo.
    echo 按任意鍵退出...
    pause >nul
    exit /b 1
)

echo ✅ Git 已安裝
echo.

REM 通用認證修復函數
:auto_fix_auth
echo 🔧 檢測到認證問題，正在自動修復...
echo.

REM 步驟1: 清理 Windows 憑證管理器
echo 步驟1: 清理 Windows 憑證管理器...
cmdkey /delete:LegacyGeneric:target=git:https://github.com 2>nul
for /f "tokens=*" %%i in ('cmdkey /list 2^>nul ^| findstr "GitHub"') do (
    for /f "tokens=2 delims=:" %%j in ("%%i") do (
        cmdkey /delete:"%%j" 2>nul
    )
)
echo ✅ Windows 憑證已清理

REM 步驟2: 重新設定 Git 認證
echo 步驟2: 重新設定 Git 認證...
git config --global --unset credential.helper 2>nul
git config --global credential.helper store
echo ✅ Git 認證已重新設定

REM 步驟3: 修改遠端 URL 包含用戶名
echo 步驟3: 更新遠端 URL...
for /f "tokens=*" %%i in ('git remote get-url origin 2^>nul') do set current_url=%%i
if defined current_url (
    for /f "tokens=*" %%j in ('git config --get user.name 2^>nul') do set git_username=%%j
    if defined git_username (
        set new_url=https://!git_username!@github.com/!current_url:~19!
        git remote set-url origin "!new_url!"
        echo ✅ 遠端 URL 已更新
    )
)
echo ✅ 認證修復完成
goto :eof

:start
echo ================================
echo 🤖 AI指令大全網站 - 完整管理工具
echo ================================
echo.

echo 請選擇操作：
echo 1. 一鍵修復推送問題
echo 2. 檢查檔案上傳問題
echo 3. 部署指定版本 (上架)
echo 4. 下架所有檔案
echo 5. 建立版本備份
echo 6. 查看版本資訊
echo 7. 初始化 Git 倉庫 (需要手動輸入倉庫連結)
echo 8. 修復 Git 同步問題
echo 9. 快速上傳檔案
echo 10. 連接新專案 GitHub 倉庫
echo 11. 修正 GitHub 認證權限
echo 12. 檢查認證狀態 (推薦在操作 3,4 前使用)
echo 13. 清理 Windows 憑證管理器 (解決認證衝突)
echo 14. 一鍵修復所有認證問題 (推薦)
echo 15. 退出
echo.

set /p choice=請輸入選項 (1-15): 

if "%choice%"=="1" goto fix_push
if "%choice%"=="2" goto check_upload
if "%choice%"=="3" goto deploy_version
if "%choice%"=="4" goto cleanup_github
if "%choice%"=="5" goto create_backup
if "%choice%"=="6" goto show_versions
if "%choice%"=="7" goto auto_init_git
if "%choice%"=="8" goto fix_git_sync
if "%choice%"=="9" goto quick_upload
if "%choice%"=="10" goto connect_new_project
if "%choice%"=="11" goto fix_auth
if "%choice%"=="12" goto check_auth_status
if "%choice%"=="13" goto cleanup_windows_credentials
if "%choice%"=="14" goto one_click_fix_auth
if "%choice%"=="15" goto exit
echo 無效選項
pause
goto start

:fix_push
echo.
echo ================================
echo 🚀 一鍵修復推送問題
echo ================================
echo.

echo 正在修復推送問題...
echo.

echo 步驟1: 下載GitHub內容...
echo 這會將GitHub上的內容下載到您的電腦
git pull origin main --allow-unrelated-histories
if errorlevel 1 (
    echo ❌ 下載失敗，嘗試其他方法...
    echo.
    echo 正在獲取遠端內容...
    git fetch origin main
    echo ✅ 遠端內容已獲取
    echo.
    echo 正在合併內容...
    git merge origin/main --allow-unrelated-histories
    if errorlevel 1 (
        echo ❌ 合併失敗
        echo 請手動解決衝突或選擇強制覆蓋
        pause
        goto start
    )
) else (
    echo ✅ GitHub內容已下載
)

echo.
echo 步驟2: 檢查當前狀態...
git status
echo.

echo 步驟3: 添加所有檔案到Git...
git add .
if errorlevel 1 (
    echo ❌ 添加檔案失敗
    pause
    goto start
)
echo ✅ 檔案已添加

echo.
echo 步驟4: 提交檔案...
set commit_msg=修復推送問題 - %date% %time%
git commit -m "!commit_msg!"
if errorlevel 1 (
    echo ❌ 提交失敗
    pause
    goto start
)
echo ✅ 檔案已提交

echo.
echo 步驟5: 推送到GitHub...
git push origin main
if errorlevel 1 (
    echo ❌ 推送失敗，正在自動檢測問題...
    
    REM 檢查是否為認證問題
    git push origin main 2>&1 | findstr "access_denied\|403\|Permission denied" >nul
    if not errorlevel 1 (
        call :auto_fix_auth
        echo 🔄 重新嘗試推送...
        git push origin main
        if errorlevel 1 (
            echo ❌ 自動修復後仍失敗，嘗試強制推送...
            git push -f origin main
            if errorlevel 1 (
                echo ❌ 強制推送到 main 也失敗，嘗試 master...
                git push -f origin master
                if errorlevel 1 (
                    echo ❌ 所有推送方式都失敗
                    echo.
                    echo 需要手動處理：
                    echo 1. 使用選項 13「清理 Windows 憑證管理器」
                    echo 2. 使用選項 11「修正 GitHub 認證權限」
                    echo 3. 或生成 Personal Access Token
                    pause
                    goto start
                ) else (
                    echo ✅ 已強制推送到 master 分支
                )
            ) else (
                echo ✅ 已強制推送到 main 分支
            )
        ) else (
            echo ✅ 認證修復成功，已推送到 main 分支
        )
    ) else (
        echo ❌ 推送失敗，嘗試強制推送...
        git push -f origin main
        if errorlevel 1 (
            echo ❌ 強制推送到 main 也失敗，嘗試 master...
            git push -f origin master
            if errorlevel 1 (
                echo ❌ 推送失敗
                echo.
                echo 可能的原因：
                echo 1. 網路連接問題
                echo 2. GitHub 認證問題
                echo 3. 倉庫權限問題
                echo.
                echo 建議使用「修復 Git 同步問題」功能
                pause
                goto start
            ) else (
                echo ✅ 已強制推送到 master 分支
            )
        ) else (
            echo ✅ 已強制推送到 main 分支
        )
    )
) else (
    echo ✅ 已推送到 main 分支
)

echo.
echo ================================
echo 🎉 修復成功！
echo ================================
echo.
echo 您的網站已成功更新：
for /f "tokens=*" %%i in ('git remote get-url origin 2^>nul') do set current_repo=%%i
if defined current_repo (
    echo GitHub: %current_repo%
    echo 網站: %current_repo:~0,-4%.github.io/%current_repo:~19%
) else (
    echo 無法取得倉庫資訊
)
echo.
echo 現在您可以正常使用部署工具了！

echo.
pause
goto start

:check_upload
echo.
echo ================================
echo 🔍 檢查檔案上傳問題
echo ================================
echo.

echo 正在檢查本地檔案...
echo.

echo 本地檔案列表：
echo ================================
dir /b *.html *.css *.js *.txt *.md 2>nul
echo ================================

echo.
echo 正在檢查Git狀態...
echo.

echo Git追蹤的檔案：
echo ================================
git ls-files
echo ================================

echo.
echo 正在檢查未追蹤的檔案...
echo ================================
git status --porcelain
echo ================================

echo.
echo 正在檢查GitHub上的檔案...
echo ================================
git ls-tree -r origin/main --name-only 2>nul
echo ================================

echo.
echo ================================
echo 🔧 修復檔案上傳問題
echo ================================
echo.

echo 步驟1: 添加所有檔案到Git...
git add .
if errorlevel 1 (
    echo ❌ 添加檔案失敗
    pause
    goto start
)
echo ✅ 所有檔案已添加

echo.
echo 步驟2: 檢查添加的檔案...
git status --short
echo.

echo 步驟3: 提交檔案...
set commit_msg=添加所有網站檔案 - %date% %time%
git commit -m "!commit_msg!"
if errorlevel 1 (
    echo ❌ 提交失敗
    pause
    goto start
)
echo ✅ 檔案已提交

echo.
echo 步驟4: 推送到GitHub...
git push origin main
if errorlevel 1 (
    echo ❌ 推送失敗，嘗試強制推送...
    git push -f origin main
    if errorlevel 1 (
        echo ❌ 強制推送到 main 也失敗，嘗試 master...
        git push -f origin master
        if errorlevel 1 (
            echo ❌ 推送失敗
            echo.
            echo 可能的原因：
            echo 1. 網路連接問題
            echo 2. GitHub 認證問題
            echo 3. 倉庫權限問題
            echo.
            echo 建議使用「修復 Git 同步問題」功能
            pause
            goto start
        ) else (
            echo ✅ 已強制推送到 master 分支
        )
    ) else (
        echo ✅ 已強制推送到 main 分支
    )
) else (
    echo ✅ 已推送到 main 分支
)
echo ✅ 推送成功！
echo 所有檔案已上傳到GitHub

echo.
echo 步驟5: 驗證上傳結果...
echo.
echo GitHub上的檔案：
echo ================================
git ls-tree -r origin/main --name-only
echo ================================

echo.
echo 您的網站地址：
for /f "tokens=*" %%i in ('git remote get-url origin 2^>nul') do set current_repo=%%i
if defined current_repo (
    echo %current_repo:~0,-4%.github.io/%current_repo:~19%
) else (
    echo 無法取得倉庫資訊
)
echo.

pause
goto start

:quick_upload
echo.
echo ================================
echo ⚡ 快速上傳檔案
echo ================================
echo.

echo 正在快速上傳所有檔案到 GitHub...
echo.

echo 步驟1: 檢查 Git 狀態...
git status --short
echo.

echo 步驟2: 添加所有檔案...
git add .
if errorlevel 1 (
    echo ❌ 添加檔案失敗
    pause
    goto start
)
echo ✅ 檔案已添加

echo.
echo 步驟3: 檢查添加的檔案...
git status --short
echo.

echo 步驟4: 提交變更...
set commit_msg=快速上傳 - %date% %time%
git commit -m "!commit_msg!"
if errorlevel 1 (
    echo ❌ 提交失敗
    pause
    goto start
)
echo ✅ 變更已提交

echo.
echo 步驟5: 推送到 GitHub...
git push origin main
if errorlevel 1 (
    echo ❌ 推送失敗，嘗試強制推送...
    git push -f origin main
    if errorlevel 1 (
        echo ❌ 強制推送到 main 也失敗，嘗試 master...
        git push -f origin master
        if errorlevel 1 (
            echo ❌ 推送失敗
            echo.
            echo 可能的原因：
            echo 1. 網路連接問題
            echo 2. GitHub 認證問題
            echo 3. 倉庫權限問題
            echo.
            echo 建議使用「修復 Git 同步問題」功能
            pause
            goto start
        ) else (
            echo ✅ 已強制推送到 master 分支
        )
    ) else (
        echo ✅ 已強制推送到 main 分支
    )
) else (
    echo ✅ 已推送到 main 分支
)

echo.
echo ================================
echo 🎉 快速上傳完成！
echo ================================
echo.
echo 當前遠端倉庫：
git remote -v
echo.
echo 如果這是 GitHub Pages 倉庫，您的網站地址可能是：
for /f "tokens=*" %%i in ('git remote get-url origin 2^>nul') do set current_repo=%%i
if defined current_repo (
    echo %current_repo:~0,-4%.github.io/%current_repo:~19%
) else (
    echo 無法取得倉庫資訊
)
echo.
echo 所有檔案已成功上傳到 GitHub！

echo.
pause
goto start

:check_auth_status
echo.
echo ================================
echo 🔍 檢查認證狀態
echo ================================
echo.

echo 正在檢查 Git 認證狀態...
echo.

echo 步驟1: 檢查 Git 用戶資訊...
echo ================================
echo 用戶名：
git config --get user.name
echo 信箱：
git config --get user.email
echo ================================

echo.
echo 步驟2: 檢查遠端倉庫...
echo ================================
git remote -v
echo ================================

echo.
echo 步驟3: 檢查認證快取...
echo ================================
git config --get credential.helper
echo ================================

echo.
echo 步驟4: 測試遠端連接...
echo ================================
echo 正在測試 GitHub 連接...
git ls-remote origin >nul 2>&1
if errorlevel 1 (
    echo ❌ 無法連接到 GitHub
    echo.
    echo 可能的原因：
    echo 1. 需要 Personal Access Token
    echo 2. 網路連接問題
    echo 3. 倉庫權限問題
    echo.
    echo 建議操作：
    echo 1. 使用「修正 GitHub 認證權限」功能
    echo 2. 檢查是否需要 Personal Access Token
    echo 3. 確認倉庫權限設定
) else (
    echo ✅ GitHub 連接正常
    echo.
    echo 認證狀態良好，可以正常推送檔案
)

echo ================================

echo.
echo 步驟5: 檢查分支資訊...
echo ================================
echo 本地分支：
git branch
echo.
echo 遠端分支：
git branch -r
echo ================================

echo.
echo ================================
echo 📋 認證狀態總結
echo ================================
echo.

git config --get user.name >nul 2>&1
if errorlevel 1 (
    echo ❌ Git 用戶資訊：未設定
    echo 建議：使用「修正 GitHub 認證權限」功能
) else (
    echo ✅ Git 用戶資訊：已設定
)

git remote get-url origin >nul 2>&1
if errorlevel 1 (
    echo ❌ 遠端倉庫：未設定
    echo 建議：使用「初始化 Git 倉庫」功能
) else (
    echo ✅ 遠端倉庫：已設定
)

git ls-remote origin >nul 2>&1
if errorlevel 1 (
    echo ❌ GitHub 連接：失敗
    echo 建議：檢查認證設定或使用 Personal Access Token
) else (
    echo ✅ GitHub 連接：正常
)

echo.
echo 💡 使用建議：
echo - 如果認證狀態有問題，請先使用「修正 GitHub 認證權限」
echo - 如果所有狀態都正常，可以直接使用「部署指定版本」或「下架所有檔案」
echo - 遇到推送問題時，可以嘗試「修復 Git 同步問題」

echo.
pause
goto start

:exit
echo.
echo ================================
echo 👋 感謝使用AI指令大全網站管理工具！
echo ================================
echo.
echo 您的網站地址：
for /f "tokens=*" %%i in ('git remote get-url origin 2^>nul') do set current_repo=%%i
if defined current_repo (
    echo %current_repo:~0,-4%.github.io/%current_repo:~19%
) else (
    echo 無法取得倉庫資訊
)
echo.
pause
exit
