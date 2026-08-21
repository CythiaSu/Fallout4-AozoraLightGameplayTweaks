$pluginPath = Join-Path $PSScriptRoot '..\AozoraLightGameplayTweaks.esp'
$pluginPath = [IO.Path]::GetFullPath($pluginPath)
$bytes = [IO.File]::ReadAllBytes($pluginPath)

function FindRecord([byte[]] $data, [uint32] $formID) {
    for ($offset = 0; $offset -le $data.Length - 24; $offset++) {
        if ($data[$offset] -eq 0x47 -and $data[$offset + 1] -eq 0x4C -and
            $data[$offset + 2] -eq 0x4F -and $data[$offset + 3] -eq 0x42) {
            $recordFormID = [BitConverter]::ToUInt32($data, $offset + 12) -band 0x00FFFFFF
            if ($recordFormID -eq $formID) {
                return $offset
            }
        }
    }
    return -1
}

function SetGlobalFloat([byte[]] $data, [uint32] $formID, [single] $value) {
    $recordOffset = FindRecord $data $formID
    if ($recordOffset -lt 0) {
        throw ('Missing GLOB record 0x{0:X6}' -f $formID)
    }

    $recordSize = [BitConverter]::ToUInt32($data, $recordOffset + 4)
    $recordEnd = $recordOffset + 24 + $recordSize
    for ($offset = $recordOffset + 24; $offset -le $recordEnd - 10; $offset++) {
        if ($data[$offset] -eq 0x46 -and $data[$offset + 1] -eq 0x4C -and
            $data[$offset + 2] -eq 0x54 -and $data[$offset + 3] -eq 0x56) {
            $subrecordSize = [BitConverter]::ToUInt16($data, $offset + 4)
            if ($subrecordSize -ne 4) {
                throw ('Unexpected FLTV size in GLOB 0x{0:X6}' -f $formID)
            }
            $oldValue = [BitConverter]::ToSingle($data, $offset + 6)
            [Array]::Copy([BitConverter]::GetBytes($value), 0, $data, $offset + 6, 4)
            Write-Output ('GLOB 0x{0:X6}: {1} -> {2}' -f $formID, $oldValue, $value)
            return
        }
    }
    throw ('Missing FLTV subrecord in GLOB 0x{0:X6}' -f $formID)
}

SetGlobalFloat $bytes 0x00000806 ([single]3.0)
SetGlobalFloat $bytes 0x00000808 ([single]0.55)
[IO.File]::WriteAllBytes($pluginPath, $bytes)
Write-Output ('Updated ' + $pluginPath)
