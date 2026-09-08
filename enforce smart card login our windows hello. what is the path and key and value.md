Windows security policy “Interactive logon: Require Windows Hello for Business or smart card”, the registry setting is:

Path:
HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System

Value:
scforceoption

Type:
REG_DWORD

1 = Enabled
0 = Disabled

So to disable the requirement:

reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v scforceoption /t REG_DWORD /d 0 /f

To enable it:

reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v scforceoption /t REG_DWORD /d 1 /f

This corresponds to:

Computer Configuration
  > Windows Settings
  > Security Settings
  > Local Policies
  > Security Options
  > Interactive logon: Require Windows Hello for Business or smart card

On modern Windows, this allows Windows Hello for Business OR smart card and prevents normal password-based interactive sign-in. Microsoft refers to this policy internally as SCForceOption.

Since you're working with an offline disk, you can modify it by loading the offline SYSTEM/SOFTWARE hive. For this particular key, load the offline SOFTWARE hive, for example if Windows is on D::

reg load HKLM\OFFLINE D:\Windows\System32\Config\SOFTWARE

Then:

reg add "HKLM\OFFLINE\Microsoft\Windows\CurrentVersion\Policies\System" /v scforceoption /t REG_DWORD /d 0 /f

And unload it:

reg unload HKLM\OFFLINE

If your goal is specifically to recover a machine that is forcing Windows Hello/smart-card login and won't allow password login, this is the key I would check first.




reg load HKLM\OFFLINE D:\Windows\System32\Config\SOFTWARE

reg add "HKLM\OFFLINE\Microsoft\Windows\CurrentVersion\Policies\System" /v scforceoption /t REG_DWORD /d 0 /f

reg unload HKLM\OFFLINE
