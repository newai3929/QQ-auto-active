#SingleInstance Force ; 强制单实例运行，避免重复启动多个脚本
SetWorkingDir %A_ScriptDir% ; 将工作目录设置为脚本所在目录
CoordMode, Mouse, Window ; 设置鼠标坐标模式为相对于窗口，而不是屏幕

; 定义群名称数组
groups := [""] ; 替换为你的群名称，这里用来存储你要发送的群

; 函数：向指定群粘贴并发送图片
SendImageToGroup(group_name) { ; 定义接收群名称参数的函数
    WinActivate, %group_name% ; 激活指定群聊窗口
    Sleep, 500 ; 等待500毫秒让窗口激活完成
    if WinActive(group_name) ; 检查窗口是否成功激活
    {
        ; 点击输入框（坐标需根据实际窗口调整）
        WinGetPos, X, Y, W, H, %group_name% ; 获取窗口位置信息（虽然这里没直接使用）
        MouseClick, left, 450, 1228  ; 点击输入框位置（这里坐标需要根据实际窗口调整，用相对位置）
        Sleep, 500 ; 等待点击操作完成
        ; 粘贴剪贴板中的图片
        Send ^v ; Ctrl+V 粘贴
        Sleep, 1000 ; 等待粘贴完成
        Send {Enter} ; 发送图片
        Sleep, 1000 ; 等待发送完成
        ; 最小化窗口
        WinMinimize, %group_name%
        Sleep, 500 ; 确保最小化操作完成
        return true ; 表示发送成功
    }
    else
    {
        return false ; 表示发送失败
    }
}

; 主程序：遍历群列表并发送图片
; 初始化成功和失败的群列表
success_groups := []
failed_groups := []
for index, group_name in groups ; 遍历所有群并发送图片
{
    if (SendImageToGroup(group_name))
        success_groups.Push(group_name) ;把成功的群加入到成功发送的列表里
    else
        failed_groups.Push(group_name) ;把失败的加入到失败的列表里
}

; 统一提示发送结果
result_msg := "发送完成！`n`n成功发送的群：`n" ; 记录成功的群，一个一个换行的输出
for index, group_name in success_groups
    result_msg .= group_name . "`n"
result_msg .= "`n发送失败的群：`n" ; 记录失败的群
for index, group_name in failed_groups
    result_msg .= group_name . "`n"
if (failed_groups.Length() = 0)
    result_msg .= "无`n" ；没有失败的，回复无
MsgBox, 0, 发送结果, %result_msg% ; 显示结果对话框

; 按 Esc 退出脚本
Esc::ExitApp
return