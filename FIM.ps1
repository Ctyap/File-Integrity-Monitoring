$validAnswer = $false

Function Create-Baseline(){
    #Delete baseline.txt ff it already exists
    Erase-Baseline-If-Already-Exists

    #Calculate Hash from the target files and store in baseline.txt
    Write-Host "baseline.txt has been created`n!" -ForegroundColor Cyan

    #Collect all files in the target folder
    $files = Get-ChildItem -Path .\files

    #For file, calculate the hash, and write to baseline.txt
    foreach($f in $files){
        $hash = Calculate-File-Hash $f.FullName
        "$($hash.Path)|$($hash.Hash)" | Out-File -FilePath .\baseline.txt -Append
    }

}

Function Monitor-Files(){
    #Begin monitoring files with saved Baseline
    Write-Host "File integrity check initiated. Reading existing baseline.txt." -ForegroundColor Yellow


    $fileHashDictionary = @{}

    #Load file| hash from baseline.txt and store them in a dictionary
    $filePathsAndHashes = Get-Content -Path .\baseline.txt

    foreach ($f in $filePathsAndHashes){
        $fileHashDictionary.add($f.Split("|")[0], $f.Split("|")[1])
    }
    
    While($true){

        Start-Sleep -Seconds 1
        Write-host "Checking files..."

        $files = Get-ChildItem -Path .\files

        #For file, calculate the hash, and write to baseline.txt
        foreach($f in $files){
            $hash = Calculate-File-Hash $f.FullName
            #"$($hash.Path)|$($hash.Hash)" | Out-File -FilePath .\baseline.txt -Append

            #Notify if a new file has been created
            #This means no created hash for existing file.
            if ($fileHashDictionary[$hash.Path] -eq $null) {
                #A new file has been created.
                Write-Host "$($hash.Path) has been created" -ForegroundColor Green

            }

            #Notify if a new file has been changed
            if ($fileHashDictionary[$hash.Path] -eq $hash.Hash){
                #The file has not changed
            }else{
                #File file has been compromised/changed, notify user.
                Write-Host "$($hash.Path) has changed!" -ForegroundColor Yellow
            }

    }

        foreach ($key in $fileHashDictionary.Keys){
            $baselineFileStillExists = Test-Path -Path $Key
            if (-Not $baselineFileStillExists){
                #One of the baseline files must have been delted, notify the user.
                Write-Host "$($key) has been deleted!" -ForegroundColor Red
            }

        }
    }
}


Function Calculate-File-Hash($filepath){
    $filehash = Get-FileHash -Path $filepath -Algorithm SHA512
    return $filehash
}


Function Erase-Baseline-If-Already-Exists(){
    #Prevents continous appending of file hashes.
    $baselineExist = Test-Path -Path .\baseline.txt
    
    if($baselineExist){
    #Delete it
    Remove-Item -Path .\baseline.txt
    }
}



While (-not $validAnswer){
    Write-Host "`nPlease first 'cd' to the directory that holds the desired files to be monitored.`n" -ForegroundColor Yellow

    Write-Host "What would you like to do?"
    Write-Host "A) Collect new Baseline?"
    Write-Host "B) Begin monitoring files with saved Baseline?"
    Write-Host "Q) Enter Q to quit`n"

    $response = Read-Host -Prompt "Please enter your choice"
    Write-Host "User entered $($response)`n"

    Switch($response.ToUpper()){
        
        "A"{$validAnswer = $true
        #Call function to create baseline.txt with path|hash format.
        Create-Baseline
        $validAnswer = $false
        }
    
    
        "B"{$validAnswer = $true
        #Call function to monitor files and notify user if any file has been added, deleted, or changed.
        Monitor-Files}
        
    
        "Q"{$validAnswer = $true
            Write-Host "Program End"
            break
        }Default{Write-Host "Invalid input. Try again.`n"}


}


}

