@echo off
chcp 65001 >nul 2>&1
setlocal enabledelayedexpansion

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
echo 13. 🔄 重置所有認證 (清除並重新設定)
echo 14. 🔐 強制重新綁定 GitHub 帳號
echo 15. 🔗 解除綁定 (保留 .git 資料夾)
echo 16. 退出
echo.

set /p choice=請輸入選項 (1-16): 

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
if "%choice%"=="13" goto reset_all_auth
if "%choice%"=="14" goto force_rebind_auth
if "%choice%"=="15" goto unbind_only
if "%choice%"=="16" goto exit
echo 無效選項
pause
goto start

:fix_push
echo.
echo ================================
echo 🚀 一鍵修復推送問題
echo ================================
echo.

echo 正在檢查當前專案資訊...
git remote get-url origin >nul 2>&1
if errorlevel 1 (
    echo ❌ 沒有發現遠端倉庫
    echo 請先使用「初始化 Git 倉庫」或「連接新專案 GitHub 倉庫」功能
    echo.
    pause
    goto start
)

REM 顯示當前專案資訊
for /f "tokens=4,5 delims=/" %%i in ('git remote get-url origin') do (
    set current_user=%%i
    set current_repo=%%j
)
set current_repo=%current_repo:.git=%
echo 當前專案：%current_user%/%current_repo%
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

:deploy_version
echo.
echo ================================
echo 📦 部署指定版本
echo ================================
echo.

echo 可用的本地版本：
dir /b | findstr "^v" 2>nul
echo.

if errorlevel 1 (
    echo  沒有找到版本資料夾！
    echo.
    echo  建議操作：
    echo 1. 使用 "建立版本備份" 建立版本
    echo 2. 或使用 "一鍵修復推送問題" 部署當前版本
    echo.
    pause
    goto start
)

echo.
set /p version=請輸入要部署的版本號 (如 v1.5): 

if "%version%"=="" (
    echo 版本號不能為空！
    pause
    goto start
)

if not exist "%version%" (
    echo 版本資料夾不存在：%version%
    echo 可用的版本：
    dir /b | findstr "^v"
    echo.
    pause
    goto start
)

echo.
echo  正在部署版本：%version%
echo.

echo  步驟1: 備份當前檔案...
if not exist "backup_current" mkdir backup_current
copy index.html backup_current\ 2>nul
copy script.js backup_current\ 2>nul
copy style.css backup_current\ 2>nul
copy data.json backup_current\ 2>nul
copy admin.html backup_current\ 2>nul
copy "通用github管理工具.bat" backup_current\ 2>nul
copy *.md backup_current\ 2>nul
copy *.txt backup_current\ 2>nul
copy tablet_*.html backup_current\ 2>nul
echo  當前檔案已備份

echo.
echo  步驟2: 下架GitHub舊檔案...
git rm -r --cached .
echo  GitHub舊檔案已下架

echo.
echo  步驟3: 複製版本檔案...
copy "%version%\index.html" . 2>nul
copy "%version%\script.js" . 2>nul
copy "%version%\style.css" . 2>nul
copy "%version%\data.json" . 2>nul
copy "%version%\admin.html" . 2>nul
copy "%version%\通用github管理工具.bat" . 2>nul
copy "%version%\*.md" . 2>nul
copy "%version%\*.txt" . 2>nul
copy "%version%\tablet_*.html" . 2>nul
echo  版本檔案已複製

echo.
echo  步驟4: 檢查Git狀態...
git status
echo.

echo  步驟5: 添加版本檔案到Git...
git add .
if errorlevel 1 (
    echo  ❌ 添加檔案失敗
    pause
    goto start
)
echo  版本檔案已添加到Git

echo.
echo  步驟6: 提交變更...
set commit_msg=部署版本 %version% - %date% %time%
git commit -m "!commit_msg!"
if errorlevel 1 (
    echo  ❌ 提交失敗
    pause
    goto start
)
echo  變更已提交

echo.
echo  步驟7: 檢查認證狀態...
git config --get user.name >nul 2>&1
if errorlevel 1 (
    echo  ❌ Git 用戶資訊未設定
    echo  正在使用預設設定...
    git config user.name "AI網站管理工具" >nul 2>&1
    git config user.email "ai@example.com" >nul 2>&1
)

echo.
echo  步驟8: 上架到GitHub...
echo  正在嘗試推送...
git push origin main
if errorlevel 1 (
    echo  ❌ 上架失敗，嘗試強制推送...
    git push -f origin main
    if errorlevel 1 (
        echo  ❌ 強制推送到 main 也失敗，嘗試 master...
        git push -f origin master
        if errorlevel 1 (
            echo  ❌ 上架失敗
            echo.
            echo  可能的原因：
            echo  1. 網路連接問題
            echo  2. GitHub 認證問題 (需要 Personal Access Token)
            echo  3. 倉庫權限問題
            echo.
            echo  建議操作：
            echo  1. 使用「修正 GitHub 認證權限」功能
            echo  2. 或使用「修復 Git 同步問題」功能
            echo  3. 檢查是否需要 Personal Access Token
            echo.
            pause
            goto start
        ) else (
            echo  ✅ 已強制推送到 master 分支
        )
    ) else (
        echo  ✅ 已強制推送到 main 分支
    )
) else (
    echo  ✅ 已推送到 main 分支
)
echo  版本 %version% 已上架到GitHub

echo.
echo ================================
echo  部署完成！
echo ================================
echo.
echo  部署資訊：
echo   版本：%version%
echo   時間：%date% %time%
for /f "tokens=*" %%i in ('git remote get-url origin 2^>nul') do set current_repo=%%i
if defined current_repo (
    echo   GitHub：%current_repo%
    echo   網站：%current_repo:~0,-4%.github.io/%current_repo:~19%
) else (
    echo   無法取得倉庫資訊
)
echo.

set /p restore=是否恢復到部署前的狀態？(y/n): 
if /i "%restore%"=="y" (
    echo.
    echo 🔄 正在恢復檔案...
    copy backup_current\index.html . 2>nul
    copy backup_current\script.js . 2>nul
    copy backup_current\style.css . 2>nul
    copy backup_current\data.json . 2>nul
    copy backup_current\admin.html . 2>nul
    copy backup_current\通用github管理工具.bat . 2>nul
    copy backup_current\*.md . 2>nul
    copy backup_current\*.txt . 2>nul
    copy backup_current\tablet_*.html . 2>nul
    echo  檔案已恢復到部署前狀態
    echo.
    echo  提示：GitHub上仍然是 %version% 版本
    echo     只有本地檔案恢復了
)

echo.
pause
goto start

:cleanup_github
echo.
echo ================================
echo 🗑️ 下架所有檔案
echo ================================
echo.

echo   警告：這將刪除GitHub上的所有檔案！
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
echo  步驟1: 備份當前檔案...
if not exist "backup_before_cleanup" mkdir backup_before_cleanup
copy index.html backup_before_cleanup\ 2>nul
copy style.css backup_before_cleanup\ 2>nul
copy script.js backup_before_cleanup\ 2>nul
copy data.json backup_before_cleanup\ 2>nul
copy admin.html backup_before_cleanup\ 2>nul
copy "通用github管理工具.bat" backup_before_cleanup\ 2>nul
copy *.txt backup_before_cleanup\ 2>nul
copy *.md backup_before_cleanup\ 2>nul
copy tablet_*.html backup_before_cleanup\ 2>nul
echo  檔案已備份到 backup_before_cleanup 資料夾

echo.
echo  步驟2: 下架GitHub檔案...
git rm -r --cached .
echo  GitHub檔案已從暫存區移除

echo.
echo  步驟3: 提交下架變更...
git commit -m "下架所有檔案 - %date% %time%"
echo  下架變更已提交

echo.
echo  步驟4: 檢查認證狀態...
git config --get user.name >nul 2>&1
if errorlevel 1 (
    echo  ❌ Git 用戶資訊未設定
    echo  正在使用預設設定...
    git config user.name "AI網站管理工具" >nul 2>&1
    git config user.email "ai@example.com" >nul 2>&1
)

echo.
echo  步驟5: 推送到GitHub...
echo  正在嘗試推送...
git push origin main
if errorlevel 1 (
    echo  ❌ 下架推送失敗，嘗試強制推送...
    git push -f origin main
    if errorlevel 1 (
        echo  ❌ 強制推送到 main 也失敗，嘗試 master...
        git push -f origin master
        if errorlevel 1 (
            echo  ❌ 下架推送失敗
            echo.
            echo  可能的原因：
            echo  1. 網路連接問題
            echo  2. GitHub 認證問題 (需要 Personal Access Token)
            echo  3. 倉庫權限問題
            echo.
            echo  建議操作：
            echo  1. 使用「修正 GitHub 認證權限」功能
            echo  2. 或使用「修復 Git 同步問題」功能
            echo  3. 檢查是否需要 Personal Access Token
            echo.
            pause
            goto start
        ) else (
            echo  ✅ 已強制推送到 master 分支
        )
    ) else (
        echo  ✅ 已強制推送到 main 分支
    )
) else (
    echo  ✅ 已推送到 main 分支
)
echo  下架完成，已推送到GitHub

echo.
echo ================================
echo  下架完成！
echo ================================
echo.
echo  下架資訊：
echo   時間：%date% %time%
for /f "tokens=*" %%i in ('git remote get-url origin 2^>nul') do set current_repo=%%i
if defined current_repo (
    echo   GitHub：%current_repo% (現在是空白)
    echo   網站：%current_repo:~0,-4%.github.io/%current_repo:~19% (無法顯示)
) else (
    echo   無法取得倉庫資訊
)
echo.
echo  備份位置：backup_before_cleanup 資料夾
echo.
echo  提示：可以選擇 "部署指定版本" 重新上架版本
echo.

pause
goto start

:create_backup
echo.
echo ================================
echo 💾 建立版本備份
echo ================================
echo.

echo 請選擇備份類型：
echo 1. 建立單一版本備份
echo 2. 🚀 快速完整備份 (自動生成v數字版本+最新5版本+全部檔案)
echo.
set /p backup_type=請選擇 (1-2): 

if "%backup_type%"=="1" goto single_version_backup
if "%backup_type%"=="2" goto quick_full_backup
echo 無效選項
pause
goto start

:single_version_backup
echo.
echo ================================
echo 💾 建立單一版本備份
echo ================================
echo.

echo 請選擇版本號輸入方式：
echo 1. 直接輸入版本號 (如 v2.3)
echo 2. 自動生成下一個版本號
echo.
set /p version_input_type=請選擇 (1-2): 

if "%version_input_type%"=="1" goto direct_input_version
if "%version_input_type%"=="2" goto auto_generate_version
echo 無效選項
pause
goto start

:direct_input_version
echo.
set /p version=請輸入版本號 (如 v2.3): 

if "%version%"=="" (
    echo 版本號不能為空！
    pause
    goto start
)

echo.
echo 將建立版本：%version%
set /p confirm=確認建立此版本嗎？(y/n): 
if /i not "%confirm%"=="y" (
    echo 操作已取消
    pause
    goto start
)
goto create_version_folder

:auto_generate_version
echo.
echo 正在分析現有版本...
echo ================================

set latest_version=
set latest_major=0
set latest_minor=0

for /f "tokens=*" %%i in ('dir /b /ad ^| findstr "^v" ^| sort /r') do (
    set current_version=%%i
    set current_version=!current_version:v=!
    
    for /f "tokens=1,2 delims=." %%a in ("!current_version!") do (
        set current_major=%%a
        set current_minor=%%b
        
        if !current_major! gtr !latest_major! (
            set latest_major=!current_major!
            set latest_minor=!current_minor!
            set latest_version=%%i
        ) else if !current_major! equ !latest_major! (
            if !current_minor! gtr !latest_minor! (
                set latest_minor=!current_minor!
                set latest_version=%%i
            )
        )
    )
)

if "%latest_version%"=="" (
    echo 沒有找到現有版本，將建立 v1.0
    set version=v1.0
) else (
    echo 找到最新版本：%latest_version%
    set /a next_minor=!latest_minor!+1
    if !next_minor! gtr 9 (
        set /a next_major=!latest_major!+1
        set version=v!next_major!.0
        echo 小版本號超過9，自動升級主版本號
    ) else (
        set version=v!latest_major!.!next_minor!
    )
    echo 自動生成下一個版本：%version%
)

echo.
echo 將建立版本：%version%
set /p confirm=確認建立此版本嗎？(y/n): 
if /i not "%confirm%"=="y" (
    echo 操作已取消
    pause
    goto start
)

:create_version_folder

echo 正在建立 %version% 資料夾...
mkdir %version% 2>nul

echo 正在複製檔案...
copy index.html %version%\ 2>nul
copy script.js %version%\ 2>nul
copy style.css %version%\ 2>nul
copy data.json %version%\ 2>nul
copy admin.html %version%\ 2>nul
copy "通用github管理工具.bat" %version%\ 2>nul
copy *.md %version%\ 2>nul
copy *.txt %version%\ 2>nul
copy tablet_*.html %version%\ 2>nul

echo.
echo 複製完成！
echo 版本資料夾：%version%
echo.

set /p deploy_now=是否立即部署此版本？(y/n): 
if /i "%deploy_now%"=="y" (
    echo 正在部署版本 %version%...
    goto deploy_version
)

echo.
pause
goto start

:quick_full_backup
echo.
echo ================================
echo 🚀 快速完整備份 (自動生成v數字版本+最新5版本+全部檔案)
echo ================================
echo.

echo 正在分析現有版本並生成新版本號...
echo ================================

set latest_version=
set latest_major=0
set latest_minor=0

for /f "tokens=*" %%i in ('dir /b /ad ^| findstr "^v" ^| sort /r') do (
    set current_version=%%i
    set current_version=!current_version:v=!
    
    for /f "tokens=1,2 delims=." %%a in ("!current_version!") do (
        set current_major=%%a
        set current_minor=%%b
        
        if !current_major! gtr !latest_major! (
            set latest_major=!current_major!
            set latest_minor=!current_minor!
            set latest_version=%%i
        ) else if !current_major! equ !latest_major! (
            if !current_minor! gtr !latest_minor! (
                set latest_minor=!current_minor!
                set latest_version=%%i
            )
        )
    )
)

if "%latest_version%"=="" (
    echo 沒有找到現有版本，將建立 v1.0
    set new_version=v1.0
) else (
    echo 找到最新版本：%latest_version%
    set /a next_minor=!latest_minor!+1
    if !next_minor! gtr 9 (
        set /a next_major=!latest_major!+1
        set new_version=v!next_major!.0
        echo 小版本號超過9，自動升級主版本號
    ) else (
        set new_version=v!latest_major!.!next_minor!
    )
    echo 自動生成新版本：%new_version%
)

echo.
echo 正在建立備份資料夾：%new_version%
mkdir "%new_version%" 2>nul

echo 正在複製檔案到備份資料夾...
copy index.html "%new_version%\" >nul 2>&1
copy *.css "%new_version%\" >nul 2>&1
copy *.js "%new_version%\" >nul 2>&1
copy *.bat "%new_version%\" >nul 2>&1
copy *.txt "%new_version%\" >nul 2>&1
copy *.md "%new_version%\" >nul 2>&1

if exist "images" (
    xcopy "images" "%new_version%\images\" /e /i /q >nul 2>&1
)

echo ✅ 新版本 %new_version% 已建立並包含所有檔案
echo.

echo 正在執行快速完整備份...
echo 這將自動備份最新的5個版本到同一個資料夾
echo.

echo.
echo 步驟1: 備份最新5個版本到 %new_version% 資料夾...
echo ================================
set version_count=0
for /f "tokens=*" %%i in ('dir /b /ad ^| findstr "^v" ^| sort /r') do (
    set /a version_count+=1
    if !version_count! leq 5 (
        echo 正在備份版本：%%i
        xcopy "%%i" "%new_version%\versions\%%i\" /e /i /q >nul 2>&1
        if !errorlevel! equ 0 (
            echo ✅ %%i 備份成功
        ) else (
            echo ❌ %%i 備份失敗
        )
    )
)

echo.
echo 步驟2: 備份所有主要檔案到 %new_version% 資料夾...
echo ================================

echo 正在備份 HTML 檔案...
if exist "*.html" (
    copy *.html "%new_version%\" >nul 2>&1
    if errorlevel 1 (
        echo ❌ HTML 檔案備份失敗
    ) else (
        echo ✅ HTML 檔案備份成功
    )
) else (
    echo ℹ️  沒有找到 HTML 檔案
)

echo 正在備份 CSS 檔案...
if exist "*.css" (
    copy *.css "%new_version%\" >nul 2>&1
    if errorlevel 1 (
        echo ❌ CSS 檔案備份失敗
    ) else (
        echo ✅ CSS 檔案備份成功
    )
) else (
    echo ℹ️  沒有找到 CSS 檔案
)

echo 正在備份 JavaScript 檔案...
if exist "*.js" (
    copy *.js "%new_version%\" >nul 2>&1
    if errorlevel 1 (
        echo ❌ JavaScript 檔案備份失敗
    ) else (
        echo ✅ JavaScript 檔案備份成功
    )
) else (
    echo ℹ️  沒有找到 JavaScript 檔案
)

echo 正在備份批次檔...
if exist "*.bat" (
    copy *.bat "%new_version%\" >nul 2>&1
    if errorlevel 1 (
        echo ❌ 批次檔備份失敗
    ) else (
        echo ✅ 批次檔備份成功
    )
) else (
    echo ℹ️  沒有找到批次檔
)

echo 正在備份文字檔案...
if exist "*.txt" (
    copy *.txt "%new_version%\" >nul 2>&1
    if errorlevel 1 (
        echo ❌ 文字檔案備份失敗
    ) else (
        echo ✅ 文字檔案備份成功
    )
) else (
    echo ℹ️  沒有找到文字檔案
)

echo 正在備份 Markdown 檔案...
if exist "*.md" (
    copy *.md "%new_version%\" >nul 2>&1
    if errorlevel 1 (
        echo ❌ Markdown 檔案備份失敗
    ) else (
        echo ✅ Markdown 檔案備份成功
    )
) else (
    echo ℹ️  沒有找到 Markdown 檔案
)

echo.
echo 步驟3: 備份圖片資料夾到 %new_version% 資料夾...
echo ================================
if exist "images" (
    echo 正在備份 images 資料夾...
    xcopy "images" "%new_version%\images\" /e /i /q >nul 2>&1
    if errorlevel 1 (
        echo ❌ images 資料夾備份失敗
    ) else (
        echo ✅ images 資料夾備份成功
    )
) else (
    echo ℹ️  images 資料夾不存在
)

echo.
echo 步驟4: 備份其他重要資料夾到 %new_version% 資料夾...
echo ================================
for /f "tokens=*" %%i in ('dir /b /ad ^| findstr /v "^v" ^| findstr /v "images" ^| findstr /v "backup"') do (
    echo 正在備份資料夾：%%i
    xcopy "%%i" "%new_version%\%%i\" /e /i /q >nul 2>&1
    if errorlevel 1 (
        echo ❌ %%i 備份失敗
    ) else (
        echo ✅ %%i 備份成功
    )
)

echo.
echo 步驟5: 建立備份資訊檔案...
echo ================================
echo 正在建立備份資訊...
(
echo 快速完整備份資訊
echo ================================
echo 備份時間：%date% %time%
echo 備份資料夾：%new_version%
echo.
echo 包含的版本：
set version_count=0
for /f "tokens=*" %%i in ('dir /b /ad ^| findstr "^v" ^| sort /r') do (
    set /a version_count+=1
    if !version_count! leq 5 (
        echo - %%i
    )
)
echo.
echo 包含的檔案類型：
echo - HTML 檔案 (*.html)
echo - CSS 檔案 (*.css)
echo - JavaScript 檔案 (*.js)
echo - 批次檔 (*.bat)
echo - 文字檔案 (*.txt)
echo - Markdown 檔案 (*.md)
echo - 圖片資料夾 (images)
echo - 其他資料夾
echo.
echo 備份完成時間：%date% %time%
) > "%new_version%\備份資訊.txt"

echo ✅ 備份資訊檔案已建立

echo.
echo ================================
echo 🎉 快速完整備份完成！
echo ================================
echo.
echo 備份資訊：
echo 資料夾：%new_version%
echo 時間：%date% %time%
echo 包含：最新5個版本 + 所有檔案
echo.
echo 備份內容：
echo - 版本資料夾：%new_version%\versions\
echo - 主要檔案：%new_version%\*.html, *.css, *.js, *.bat, *.txt, *.md
echo - 圖片資料夾：%new_version%\images\
echo - 其他資料夾：%new_version%\其他資料夾\
echo - 備份資訊：%new_version%\備份資訊.txt
echo.

set /p open_folder=是否開啟備份資料夾？(y/n): 
if /i "%open_folder%"=="y" (
    explorer "%new_version%"
)

echo.
pause
goto start

:show_versions
echo.
echo ================================
echo 📋 版本資訊
echo ================================
echo.

echo 本地版本：
dir /b | findstr "^v" 2>nul
if errorlevel 1 (
    echo  沒有找到版本資料夾
) else (
    echo  找到以上版本
)
echo.

echo GitHub狀態：
git status 2>nul
if errorlevel 1 (
    echo  Git未初始化
) else (
    echo  Git已初始化
)
echo.

echo 最近提交記錄：
git log --oneline -5 2>nul
echo.

pause
goto start

:auto_init_git
echo.
echo ================================
echo 🚀 初始化 Git 倉庫
echo ================================
echo.

echo 請輸入您的 GitHub 倉庫連結：
echo 範例：https://github.com/username/repository-name
echo 或：https://github.com/username/repository-name.git
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
    echo 請確保連結包含 github.com
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
echo 正在檢查 Git 是否已安裝...
git --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Git 未安裝或未正確配置
    echo 請先安裝 Git: https://git-scm.com/
    pause
    goto start
)
echo ✅ Git 已安裝

echo.
echo 正在檢查是否已初始化 Git 倉庫...
if exist ".git" (
    echo ✅ Git 倉庫已存在
    echo 當前狀態：
    git status --short
    echo.
    echo 正在檢查遠端倉庫...
    git remote -v
    echo.
    set /p replace=是否要替換現有的遠端倉庫？(y/n): 
    if /i not "%replace%"=="y" (
        echo 操作已取消
        pause
        goto start
    )
    echo 正在移除現有遠端倉庫...
    git remote remove origin 2>nul
    echo ✅ 現有遠端倉庫已移除
) else (
    echo 正在初始化 Git 倉庫...
    git init
    if errorlevel 1 (
        echo ❌ 初始化失敗
        pause
        goto start
    )
    echo ✅ Git 倉庫已初始化
)

echo.
echo 正在處理遠端 URL...
set modified_url=%repo_url%
if "%modified_url:~8,11%"=="github.com/" (
    set modified_url=%modified_url:https://=https://%github_username%@%
)

echo.
echo 正在添加遠端倉庫...
git remote add origin %modified_url%
if errorlevel 1 (
    echo ❌ 添加遠端倉庫失敗
    pause
    goto start
)
echo ✅ 遠端倉庫已添加

echo.
echo 正在配置 Git 用戶資訊...
git config user.name "AI網站管理工具" >nul 2>&1
git config user.email "ai@example.com" >nul 2>&1
echo ✅ Git 用戶資訊已配置

echo.
echo 正在添加所有檔案...
git add .
if errorlevel 1 (
    echo ❌ 添加檔案失敗
    pause
    goto start
)
echo ✅ 檔案已添加

echo.
echo 正在提交初始版本...
git commit -m "初始化 AI 網站管理工具 - %date% %time%"
if errorlevel 1 (
    echo ❌ 提交失敗
    pause
    goto start
)
echo ✅ 初始版本已提交

echo.
echo 正在檢查遠端分支...
git ls-remote --heads origin
echo.

echo 正在推送到 GitHub...
echo 嘗試推送到 main 分支...
git push -u origin main
if errorlevel 1 (
    echo ❌ 推送到 main 失敗
    echo.
    echo 嘗試推送到 master 分支...
    git push -u origin master
    if errorlevel 1 (
        echo ❌ 推送到 master 也失敗
        echo.
        echo 正在檢查本地分支...
        git branch
        echo.
        echo 正在檢查遠端分支...
        git ls-remote --heads origin
        echo.
        echo 嘗試強制推送到 main...
        git push -f origin main
        if errorlevel 1 (
            echo 嘗試強制推送到 master...
            git push -f origin master
            if errorlevel 1 (
                echo ❌ 所有推送方式都失敗
                echo.
                echo 可能的原因：
                echo 1. 網路連接問題
                echo 2. GitHub 認證問題
                echo 3. 倉庫權限問題
                echo 4. 遠端倉庫為空或分支設定錯誤
                echo.
                echo 建議操作：
                echo 1. 檢查 GitHub 倉庫是否為空
                echo 2. 在 GitHub 上建立初始檔案
                echo 3. 檢查倉庫權限設定
                echo 4. 確認分支名稱正確
                echo.
                pause
                goto start
            ) else (
                echo ✅ 已強制推送到 master 分支
            )
        ) else (
            echo ✅ 已強制推送到 main 分支
        )
    ) else (
        echo ✅ 已推送到 master 分支
    )
) else (
    echo ✅ 已推送到 main 分支
)

echo.
echo ================================
echo 🎉 Git 倉庫初始化完成！
echo ================================
echo.
echo 倉庫資訊：
echo 連結：%repo_url%
echo 時間：%date% %time%
echo.
echo 如果這是 GitHub Pages 倉庫，您的網站地址可能是：
echo %repo_url:~0,-4%.github.io/%repo_url:~19%
echo.
echo 現在可以使用其他管理功能了！

echo.
pause
goto start

:fix_git_sync
echo.
echo ================================
echo 🔧 修復 Git 同步問題
echo ================================
echo.

echo 正在診斷 Git 同步問題...
echo.

echo 步驟1: 檢查 Git 狀態...
git status
echo.

echo 步驟2: 檢查遠端倉庫...
git remote -v
echo.

echo 步驟3: 檢查分支資訊...
git branch -a
echo.

echo 步驟4: 嘗試獲取遠端內容...
git fetch origin
if errorlevel 1 (
    echo ❌ 獲取遠端內容失敗
    echo 正在嘗試重新添加遠端倉庫...
    echo 請輸入正確的 GitHub 倉庫連結：
    set /p repo_url=請輸入 GitHub 連結: 
    if "%repo_url%"=="" (
        echo ❌ 連結不能為空！
        pause
        goto start
    )
    git remote remove origin
    git remote add origin %repo_url%
    git fetch origin
    if errorlevel 1 (
        echo ❌ 仍然無法獲取遠端內容
        echo 請檢查網路連接和 GitHub 認證
        pause
        goto start
    )
)
echo ✅ 遠端內容已獲取

echo.
echo 步驟5: 檢查本地和遠端的差異...
git log --oneline -5
echo.
echo 遠端最新提交：
git log --oneline origin/main -5
echo.

echo 步驟6: 嘗試合併遠端內容...
git merge origin/main --allow-unrelated-histories
if errorlevel 1 (
    echo ❌ 合併失敗，可能有衝突
    echo 正在嘗試強制合併...
    git reset --hard origin/main
    if errorlevel 1 (
        echo ❌ 強制合併也失敗
        echo 請手動解決衝突
        pause
        goto start
    )
    echo ✅ 強制合併成功
) else (
    echo ✅ 合併成功
)

echo.
echo 步驟7: 添加所有檔案...
git add .
if errorlevel 1 (
    echo ❌ 添加檔案失敗
    pause
    goto start
)
echo ✅ 檔案已添加

echo.
echo 步驟8: 提交變更...
git commit -m "修復同步問題 - %date% %time%"
if errorlevel 1 (
    echo ❌ 提交失敗
    pause
    goto start
)
echo ✅ 變更已提交

echo.
echo 步驟9: 推送到 GitHub...
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
            echo 建議檢查：
            echo - 網路連接
            echo - GitHub 認證設定
            echo - 倉庫權限
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
echo 🎉 Git 同步問題已修復！
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
echo 現在可以正常使用所有功能了！

echo.
pause
goto start

:quick_upload
echo.
echo ================================
echo ⚡ 快速上傳檔案
echo ================================
echo.

echo 正在檢查當前專案資訊...
git remote get-url origin >nul 2>&1
if errorlevel 1 (
    echo ❌ 沒有發現遠端倉庫
    echo 請先使用「初始化 Git 倉庫」或「連接新專案 GitHub 倉庫」功能
    echo.
    pause
    goto start
)

REM 顯示當前專案資訊
for /f "tokens=4,5 delims=/" %%i in ('git remote get-url origin') do (
    set current_user=%%i
    set current_repo=%%j
)
set current_repo=%current_repo:.git=%
echo 當前專案：%current_user%/%current_repo%
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

:connect_new_project
echo.
echo ================================
echo 🔗 連接新專案 GitHub 倉庫
echo ================================
echo.

echo 請輸入新專案的 GitHub 倉庫連結：
echo 範例：https://github.com/username/project-name
echo 或：https://github.com/username/project-name.git
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
    echo 請確保連結包含 github.com
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
echo 正在檢查 Git 是否已安裝...
git --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Git 未安裝或未正確配置
    echo 請先安裝 Git: https://git-scm.com/
    pause
    goto start
)
echo ✅ Git 已安裝

echo.
echo 正在處理現有 Git 設定...
if exist ".git" (
    echo ✅ Git 倉庫已存在
    echo 當前遠端倉庫：
    git remote -v
    echo.
    echo 正在移除現有遠端倉庫...
    git remote remove origin 2>nul
    echo ✅ 現有遠端倉庫已移除
) else (
    echo 正在初始化 Git 倉庫...
    git init
    if errorlevel 1 (
        echo ❌ 初始化失敗
        pause
        goto start
    )
    echo ✅ Git 倉庫已初始化
)

echo.
echo 正在添加新的遠端倉庫...
git remote add origin %repo_url%
if errorlevel 1 (
    echo ❌ 添加遠端倉庫失敗
    pause
    goto start
)
echo ✅ 遠端倉庫已添加

echo.
echo 正在配置 Git 用戶資訊...
echo 請輸入您的 GitHub 用戶名：
set /p github_username=GitHub 用戶名: 
echo 請輸入您的 GitHub 信箱：
set /p github_email=GitHub 信箱: 
git config user.name "%github_username%" >nul 2>&1
git config user.email "%github_email%" >nul 2>&1
echo ✅ Git 用戶資訊已配置

echo.
echo 正在獲取遠端內容...
git fetch origin
if errorlevel 1 (
    echo ❌ 獲取遠端內容失敗
    echo 可能的原因：
    echo 1. 倉庫不存在或無權限
    echo 2. 網路連接問題
    echo 3. 倉庫連結錯誤
    pause
    goto start
)
echo ✅ 遠端內容已獲取

echo.
echo 正在檢查分支...
git branch -a
echo.

echo 正在添加所有檔案...
git add .
if errorlevel 1 (
    echo ❌ 添加檔案失敗
    pause
    goto start
)
echo ✅ 檔案已添加

echo.
echo 正在提交變更...
git commit -m "連接新專案倉庫 - %date% %time%"
if errorlevel 1 (
    echo ❌ 提交失敗
    pause
    goto start
)
echo ✅ 變更已提交

echo.
echo 正在檢查遠端分支...
git ls-remote --heads origin
echo.

echo 正在推送到新倉庫...
echo 嘗試推送到 main 分支...
git push -u origin main
if errorlevel 1 (
    echo ❌ 推送到 main 失敗
    echo.
    echo 嘗試推送到 master 分支...
    git push -u origin master
    if errorlevel 1 (
        echo ❌ 推送到 master 也失敗
        echo.
        echo 正在檢查本地分支...
        git branch
        echo.
        echo 正在檢查遠端分支...
        git ls-remote --heads origin
        echo.
        echo 嘗試強制推送到 main...
        git push -f origin main
        if errorlevel 1 (
            echo 嘗試強制推送到 master...
            git push -f origin master
            if errorlevel 1 (
                echo ❌ 所有推送方式都失敗
                echo.
                echo 可能的原因：
                echo 1. 網路連接問題
                echo 2. GitHub 認證問題
                echo 3. 倉庫權限問題
                echo 4. 分支名稱不匹配
                echo 5. 遠端倉庫為空或分支設定錯誤
                echo.
                echo 建議操作：
                echo 1. 檢查 GitHub 倉庫是否為空
                echo 2. 在 GitHub 上建立初始檔案
                echo 3. 檢查倉庫權限設定
                echo 4. 確認分支名稱正確
                echo.
                pause
                goto start
            ) else (
                echo ✅ 已強制推送到 master 分支
            )
        ) else (
            echo ✅ 已強制推送到 main 分支
        )
    ) else (
        echo ✅ 已推送到 master 分支
    )
) else (
    echo ✅ 已推送到 main 分支
)

echo.
echo ================================
echo 🎉 新專案連接完成！
echo ================================
echo.
echo 專案資訊：
echo 連結：%repo_url%
echo 時間：%date% %time%
echo.
echo 如果這是 GitHub Pages 倉庫，您的網站地址可能是：
echo %repo_url:~0,-4%.github.io/%repo_url:~19%
echo.
echo 現在可以使用其他管理功能了！

echo.
pause
goto start

:fix_auth
echo.
echo ================================
echo 🔐 修正 GitHub 認證權限
echo ================================
echo.

echo 這個功能會幫您修正 GitHub 認證問題
echo 適用於切換不同 GitHub 帳號的情況
echo.

echo 正在自動檢測當前專案資訊...
echo.

REM 檢查是否有遠端倉庫
git remote get-url origin >nul 2>&1
if errorlevel 1 (
    echo ❌ 沒有發現遠端倉庫
    echo 請先使用「初始化 Git 倉庫」或「連接新專案 GitHub 倉庫」功能
    echo.
    pause
    goto start
)

REM 從遠端倉庫 URL 提取用戶名
for /f "tokens=4 delims=/" %%i in ('git remote get-url origin') do set auto_username=%%i
echo 自動檢測到 GitHub 用戶名：%auto_username%

REM 從遠端倉庫 URL 提取倉庫名稱
for /f "tokens=5 delims=/" %%i in ('git remote get-url origin') do set auto_repo=%%i
set auto_repo=%auto_repo:.git=%
echo 自動檢測到倉庫名稱：%auto_repo%

echo.
echo 當前遠端倉庫：%auto_username%/%auto_repo%
echo.

echo 請選擇操作方式：
echo 1. 使用自動檢測的用戶名：%auto_username%
echo 2. 手動輸入新的用戶名和信箱
echo.
set /p auth_choice=請選擇 (1/2): 

if "%auth_choice%"=="1" (
    set github_username=%auto_username%
    echo.
    echo 請輸入對應的信箱：
    set /p github_email=GitHub 信箱: 
) else if "%auth_choice%"=="2" (
    echo.
    echo 請輸入您的 GitHub 資訊：
    set /p github_username=GitHub 用戶名: 
    set /p github_email=GitHub 信箱: 
) else (
    echo 無效選項，使用自動檢測的用戶名
    set github_username=%auto_username%
    echo.
    echo 請輸入對應的信箱：
    set /p github_email=GitHub 信箱: 
) 

if "%github_username%"=="" (
    echo ❌ 用戶名不能為空！
    pause
    goto start
)

if "%github_email%"=="" (
    echo ❌ 信箱不能為空！
    pause
    goto start
)

echo.
echo 正在設定 Git 用戶資訊...
git config user.name "%github_username%"
git config user.email "%github_email%"
echo ✅ Git 用戶資訊已設定

echo.
echo 正在設定全域 Git 用戶資訊...
git config --global user.name "%github_username%"
git config --global user.email "%github_email%"
echo ✅ 全域 Git 用戶資訊已設定

echo.
echo 正在清除現有的認證快取...
git config --global --unset credential.helper 2>nul
echo ✅ Git 認證快取已清除

echo.
echo 正在清除所有 Git 認證設定...
git config --global --unset user.name 2>nul
git config --global --unset user.email 2>nul
git config --local --unset user.name 2>nul
git config --local --unset user.email 2>nul
echo ✅ Git 用戶資訊已清除

echo.
echo 正在清除 Windows 認證管理器中的舊認證...
echo 正在檢查現有的 GitHub 認證...
cmdkey /list | findstr github >nul 2>&1
if not errorlevel 1 (
    echo 發現舊的 GitHub 認證，正在清除...
    for /f "tokens=1*" %%a in ('cmdkey /list ^| findstr "git:https://github.com"') do (
        echo 正在刪除認證：%%a %%b
        cmdkey /delete:"%%a %%b" >nul 2>&1
    )
    echo ✅ Windows 認證管理器中的舊認證已清除
) else (
    echo ✅ 沒有發現需要清除的舊認證
)

echo.
echo 正在清除 Git 認證檔案...
if exist "%USERPROFILE%\.git-credentials" (
    del "%USERPROFILE%\.git-credentials" 2>nul
    echo ✅ Git 認證檔案已刪除
) else (
    echo ✅ 沒有發現 Git 認證檔案
)

echo.
echo 正在重新設定認證...
git config --global credential.helper store
echo ✅ 認證設定已更新

echo.
echo 正在檢查當前遠端倉庫...
git remote -v
echo.

echo 正在測試認證...
echo 嘗試獲取遠端內容...
git fetch origin
if errorlevel 1 (
    echo ❌ 認證測試失敗
    echo.
    echo 可能的原因：
    echo 1. 用戶名或信箱錯誤
    echo 2. 沒有該倉庫的推送權限
    echo 3. 需要重新輸入密碼或 Personal Access Token
    echo.
    echo 建議操作：
    echo 1. 確認 GitHub 用戶名和信箱正確
    echo 2. 確認有該倉庫的推送權限
    echo 3. 如果使用 Personal Access Token，請重新設定
    echo.
    pause
    goto start
) else (
    echo ✅ 認證測試成功！
)

echo.
echo ================================
echo 🎉 認證修正完成！
echo ================================
echo.
echo 設定資訊：
echo 用戶名：%github_username%
echo 信箱：%github_email%
echo.
echo 現在可以正常推送檔案了！
echo 建議使用「快速上傳檔案」功能測試

echo.
pause
goto start

:check_auth_status
echo.
echo ================================
echo 🔍 檢查認證狀態
echo ================================
echo.

echo 正在檢查當前專案資訊...
git remote get-url origin >nul 2>&1
if errorlevel 1 (
    echo ❌ 沒有發現遠端倉庫
    echo 請先使用「初始化 Git 倉庫」或「連接新專案 GitHub 倉庫」功能
    echo.
    pause
    goto start
)

REM 顯示當前專案資訊
for /f "tokens=4,5 delims=/" %%i in ('git remote get-url origin') do (
    set current_user=%%i
    set current_repo=%%j
)
set current_repo=%current_repo:.git=%
echo 當前專案：%current_user%/%current_repo%
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
echo Git 認證助手：
git config --get credential.helper
echo ================================

echo.
echo 步驟3.5: 檢查 Windows 認證管理器...
echo ================================
echo 正在檢查 Windows 認證管理器中的 GitHub 認證...
cmdkey /list | findstr github
if errorlevel 1 (
    echo 沒有發現 GitHub 相關認證
) else (
    echo 發現以上 GitHub 認證
)
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
cmdkey /list | findstr github >nul 2>&1
if errorlevel 1 (
    echo ❌ Windows 認證管理器：沒有 GitHub 認證
    echo 建議：使用「修正 GitHub 認證權限」功能重新認證
) else (
    echo ✅ Windows 認證管理器：有 GitHub 認證
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
