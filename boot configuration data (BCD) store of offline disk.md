You can edit the BCD of an offline Windows disk by pointing bcdedit directly at its BCD store with /store.

For a typical UEFI/GPT Windows disk:

diskpart
list disk
select disk 1
list partition
select partition <EFI partition number>
assign letter=S
exit

The EFI partition is normally FAT32 and around 100–300 MB.

Then inspect the offline BCD:

bcdedit /store S:\EFI\Microsoft\Boot\BCD /enum all

Edit it using the identifiers shown by /enum. For example:

bcdedit /store S:\EFI\Microsoft\Boot\BCD /set {default} safeboot minimal

or:

bcdedit /store S:\EFI\Microsoft\Boot\BCD /deletevalue {default} safeboot

If you need to modify the Windows loader path/device:

bcdedit /store S:\EFI\Microsoft\Boot\BCD /set {default} device partition=C:
bcdedit /store S:\EFI\Microsoft\Boot\BCD /set {default} osdevice partition=C:

Be careful: when working from WinPE or another Windows installation, the offline Windows partition may not be C:. Check:

diskpart
list volume

For an older BIOS/MBR system, the BCD is usually on the System Reserved partition:

bcdedit /store S:\Boot\BCD /enum all

If the BCD is damaged or missing, rebuilding it is often easier:

bcdboot D:\Windows /s S: /f UEFI

For legacy BIOS:

bcdboot D:\Windows /s S: /f BIOS

And for either:

bcdboot D:\Windows /s S: /f ALL

If you tell me exactly what BCD setting you want to change on the offline disk, I can give you the exact bcdedit /store ... command.
