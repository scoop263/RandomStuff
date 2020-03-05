
$RACE = ".\Properties\Race"
$CLASS = ".\Properties\Classes"
$CHARACTERISTIC = ".\Properties\PrimaryCharacteristics"
$BONUSMODS = ".\Properties\CharacteristicModifier"
$CLASSDIR = ".\Properties\Class\"
$ABILITYNAME = ".\Properties\InitialClassTotal"
$CLASSBONUSDIR = ".\Properties\Class\Bonus\"
$CHARACTERISTICBONUS = ".\Properties\InitialBonus"
$WEIGHT = ".\Properties\Weight\Size"
$HEIGHT = ".\Properties\Height\Size"
$CHARACTERDIRECTORY = ".\CharacterSheets\"
$FILESPEC = ".\Properties\FileSpecs.txt"

$XTIMES = $(Get-Content $FILESPEC | Select -Index 1).Split(":") 
$FILENAME = $(Get-Content $FILESPEC | Select -Index 0).Split(":")
$FILENAME = $FILENAME[1].Trim()
function baseCalc {
    $CLASSFILE = $Args[0]
    $ARRAY = $Args[1]
    $CHOSENCLASS = Get-Content $CLASSFILE | Select -Index $ARRAY.Item(1)
    $LOCATION = $CLASSDIR + $CHOSENCLASS
    $ARCHETYPE = Get-Content $LOCATION | Select -Index 0
    $ARCHETYPE = $ARCHETYPE -split(", ")
    if($ARCHETYPE.Count -eq 2){
        $CHOICE = Get-Random -Maximum 2
        if($CHOICE -eq 0){
            $ARCHETYPE = $ARCHETYPE[1]
        }else{$ARCHETYPE = $ARCHETYPE[0]}
    }
    ################################
    # Percentage
    # Based off of the Archetype Chosen percentages are declared as such
    # How to look at the Percent Array
    # Success : 1 - Success
    # 
    # Success  Success       Success  Success 
    # Combat   Supernatural  Psychic  Secondary
    ################################
    $PERCENT = @()
    # 95 1 1 95
    # 10 95 1 95
    # 95 1 1 95
    # 1 20 95 95
    # 95 1 20 95
    if($ARCHETYPE -eq "Fighter"){$PERCENT = @(95,1,1,75)}
    elseif($ARCHETYPE -eq "Mystic"){$PERCENT = @(10,95,1,75)}
    elseif($ARCHETYPE -eq "Prowler"){$PERCENT = @(95,1,1,75)}
    elseif($ARCHETYPE -eq "Psychic"){$PERCENT = @(1,20,95,75)}
    elseif($ARCHETYPE -eq "Domine"){$PERCENT = @(95,1,20,75)}
    $ABILITYCATEGORY = @("Combat","Supernatural","Psychic","Secondary")
    $MAXDP = $ARRAY.Item(3)
    $CURRENTDP = $ARRAY.Item(4)
    $CLASSBASEPOINTS = @()
    $TOTALDPSPENT = @()
    $LIMITS= @(6,13,21)
    $DPTOSPEND = 0
    $q = 0
    Foreach($ABILITY in $ABILITYCATEGORY){
        switch ($ABILITY){
            Combat {$CLASSBASEPOINTS =  @(7..12)}
            Supernatural {$CLASSBASEPOINTS =  @(14..20)}
            Psychic {$CLASSBASEPOINTS =  @(22..24)}
            Secondary {$CLASSBASEPOINTS =  @(25..61)}
        }
        foreach($x in $LIMITS){
            $LIMIT = Get-Content $LOCATION | Select -Index $x
        }
        $PERCENTOFDP = $MAXDP * ($LIMIT / 100)
        if($ABILITY -eq "Secondary"){$LIMIT = 0}

        foreach($i in $CLASSBASEPOINTS){
                $DPNUM = Get-Content $LOCATION | Select -Index $i
                [System.Collections.ArrayList]$SUCCESS = @(1..$PERCENT.Item($q))
                if($PERCENTOFDP -lt $DPTOSPEND){$DPTOSPEND = $PERCENTOFDP}
                $DPTOSPEND = [math]::floor($CURRENTDP / $DPNUM)
                #if($PERCENTOFDP -lt $DPTOSPEND){$DPTOSPEND = $PERCENTOFDP}
                if($LIMIT -ne 0){
                    for($points=0;$points -le $DPTOSPEND -and ($PERCENTOFDP -ge ($points * $DPNUM));$points++){
                        $RANDOMNUMBER = Get-Random -Minimum 1 -Maximum 101
                        if($SUCCESS -contains $RANDOMNUMBER){
                            $RANDOMNUMBER = $RANDOMNUMBER - 1
                            $SUCCESS.Remove($RANDOMNUMBER)
                            $DPTOSPEND = $DPTOSPEND - 1
                        }else{
            $DPSPENT = $points * $DPNUM
            $CURRENTDP = $CURRENTDP - $DPSPENT
            $VAL = $i + 18
            $ARRAY.Item(4) = $CURRENTDP
            $ARRAY.Item($VAL) = $DPSPENT
                            break
                        }

                    }
                }else{
                    for($points=0;$points -le ([math]::floor($CURRENTDP / $DPNUM));$points++){
                        $RANDOMNUMBER = Get-Random -Minimum 1 -Maximum 101
                        if($SUCCESS -contains $RANDOMNUMBER){
                            $RANDOMNUMBER = $RANDOMNUMBER - 1
                            $SUCCESS.Remove($RANDOMNUMBER)
                            $CURRENTDP = $CURRENTDP - 1
                        }else{
            $DPSPENT = $points * $DPNUM
            $CURRENTDP = $CURRENTDP - $DPSPENT
            $VAL = $i + 18
            $ARRAY.Item(4) = $CURRENTDP
            $ARRAY.Item($VAL) = $DPSPENT
                            break
                        }

                    }

                }
            }
        $q = $q + 1
    }
    return $ARRAY

}

function charAboveTen(){
    $NUM = $Args[0]
    $FULLARRAY = $Args[1]
    $CHECK = @()
    for($i = 7; $i -le 14; $i++){$CHECK += $FULLARRAY.Item($i)}
    $CHECK = $CHECK  | Sort 
    if(($NUM -eq 10) -and ($CHECK.Item(0) -lt 5)){return 1}
    elseif(($NUM -eq 11) -and ($CHECK.Item(0) -lt 6)){return 1}
    elseif(($NUM -eq 12) -and ($CHECK.Item(0) -lt 7)){return 1}
    elseif(($NUM -eq 13) -and ($CHECK.Item(0) -lt 8)){return 1}
    elseif(($NUM -eq 14) -and ($CHECK.Item(0) -lt 9)){return 1}
    elseif(($NUM -eq 15) -and ($CHECK.Item(0) -lt 10)){return 1}
    elseif(($NUM -eq 16) -and ($CHECK.Item(0) -lt 11)){return 1}
    elseif(($NUM -eq 17) -and ($CHECK.Item(0) -lt 12)){return 1}
    elseif(($NUM -eq 18) -and ($CHECK.Item(0) -lt 13)){return 1}
    elseif(($NUM -eq 19) -and ($CHECK.Item(0) -lt 14)){return 1}
    return 0
}

function modification{
    ########################################
    # Index of Array of NUMBERS
    # Index 0 = Race
    # Index 1 = Class
    # Index 2 = Level
    # Index 3 = MAX Development Points
    # Index 4 = Current Development Points
    # Index 5 = MAX Characteristic + Points
    # Index 6 = Sex (0 = Female)(1 = Male)
    # Index 7 = Appearence
    # Index 8 = STR
    # Index 9 = DEX
    # Index 10 = AGI
    # Index 11 = CON
    # Index 12 = INT
    # Index 13 = POW
    # Index 14 = WP
    # Index 15 = PER
    # Index 16 = Movement
    # Index 17 = Fatigue
    # Index 18 = Size
    ########################################
    $RACEFILE = $Args[0]
    $ARRAY = $Args[1]
    # SIZE + 2 Races
    $SIZEPLUS2 = @("Jayan(Nephilim)", "Jayan", "Devah")
    # Size - 1 Races
    $SIZEMINUS1 = @("Daimah(Nephilim)", "Daimah")

    $RACEOFCHOICE = Get-Content $RACEFILE | Select -Index $ARRAY.Item(0)
    
    #Uncommon Strength
    if($RACEOFCHOICE -eq "Jayan(Nephilim)"){
        $ARRAY.Item(8) = $ARRAY.Item(8) + 1
    # Exceptional Build
    }elseif($RACEOFCHOICE -eq "Jayan"){
        $ARRAY.Item(8) = $ARRAY.Item(8) + 2
        $ARRAY.Item(11) = $ARRAY.Item(11) + 1
    # Superhuman Characteristics
    }elseif($RACEOFCHOICE -eq "Sylvain"){
        $ARRAY.Item(8) = $ARRAY.Item(8) - 1
        $ARRAY.Item(9) = $ARRAY.Item(9) + 1
        $ARRAY.Item(10) = $ARRAY.Item(10) + 1
        $ARRAY.Item(11) = $ARRAY.Item(11) - 1
        $ARRAY.Item(12) = $ARRAY.Item(12) + 1
        $ARRAY.Item(13) = $ARRAY.Item(13) + 1
    # Cat-Like Body
    }elseif($RACEOFCHOICE -eq "Daimah"){
        $ARRAY.Item(9) = $ARRAY.Item(9) + 1
        $ARRAY.Item(10) = $ARRAY.Item(10) + 1
        $ARRAY.Item(11) = $ARRAY.Item(11) - 1
        $ARRAY.Item(12) = $ARRAY.Item(12) + 1
        $ARRAY.Item(13) = $ARRAY.Item(13) + 1
        $ARRAY.Item(14) = $ARRAY.Item(14) - 1

    }elseif($RACEOFCHOICE -eq "Ebudan"){
        $ARRAY.Item(13) = $ARRAY.Item(13) + 2
        $ARRAY.Item(14) = $ARRAY.Item(14) + 2

    }elseif($RACEOFCHOICE -eq "Duk'Zarist"){
        $ARRAY.Item(8) = $ARRAY.Item(8) + 1
        $ARRAY.Item(9) = $ARRAY.Item(9) + 1
        $ARRAY.Item(10) = $ARRAY.Item(10) + 1
        $ARRAY.Item(11) = $ARRAY.Item(11) + 1
        $ARRAY.Item(12) = $ARRAY.Item(12) + 1
        $ARRAY.Item(13) = $ARRAY.Item(13) + 1
        $ARRAY.Item(14) = $ARRAY.Item(14) + 1
        $ARRAY.Item(15) = $ARRAY.Item(15) + 1

    }elseif($RACEOFCHOICE -eq "Devah"){
        $ARRAY.Item(8) = $ARRAY.Item(8) - 1
        $ARRAY.Item(9) = $ARRAY.Item(9) - 2
        $ARRAY.Item(10) = $ARRAY.Item(10) + 1
        $ARRAY.Item(11) = $ARRAY.Item(11) + 1
        $ARRAY.Item(12) = $ARRAY.Item(12) + 1
    }
    $n = 0
    while($n -lt $ARRAY.Item(5)){
        for($p=8; $p -le 15; $p++){
            $CHANCE= Get-Random -Maximum 2
            if($CHANCE -eq 0){
                if($ARRAY.Item($p) -ge 10){
                    if((charAboveTen $ARRAY.Item($p) $ARRAY) -eq 0){
                        $ARRAY.Item($p) = $ARRAY.Item($p) + 1
                        $n = $n + 1
                        break
                    }
                }elseif($ARRAY.Item($p) -lt 10){
                    $TOINCREASE = Get-Random -Maximum 4
                    if($TOINCREASE -eq 0){
                        $ARRAY.Item($p) = $ARRAY.Item($p) + 1
                        $n = $n + 1
                        break
                    }
                }
            }
        }
    }
    # Create Size
    $ARRAY.Item(18) =  $ARRAY.Item(8) + $ARRAY.Item(11)
    # Creates Movement
    $ARRAY.Item(16) = $ARRAY.Item(10)
    # Creates Fatigue
    $ARRAY.Item(17) =  $ARRAY.Item(11)
    
    # If Statement for Sex
    if($ARRAY.Item(6) -eq 0){$ARRAY.Item(18) = $ARRAY.Item(18) - 1}
    # If Statement for Phyiscal Traits

    # Unnatural Size + Giant
    if($RACEOFCHOICE -in $SIZEPLUS2){$ARRAY.Item(18) = $ARRAY.Item(18) + 2}
    # Common Appearence
    if($RACEOFCHOICE -eq "Daimah(Nephilim)"){$ARRAY.Item(7) = Get-Random -Minimum 3 -Maximum 8}
    # Small Size
    if($RACEOFCHOICE -in $SIZEMINUS1){$ARRAY.Item(18) = $ARRAY.Item(18) - 1}   
    return $ARRAY
}

function numbers{
    $RACEFILE = $Args[0]
    $CLASSFILE = $Args[1]
    $MAXRACE = Get-Content $RACEFILE | Measure-Object -Line | Select-Object -ExpandProperty Lines
    $MAXCLASS = Get-Content $CLASSFILE | Measure-Object -Line | Select-Object -ExpandProperty Lines
    $NUMLEVEL=0
    $DEVELOPMENTPOINT=400
    $CHARACTERPOINT=0
    $SEX = Get-Random -Maximum 2
    $NUMRANDOM = Get-Random -Minimum 1 -Maximum 10000
    
    if($NUMRANDOM -in 1..5000){$NUMLEVEL=1}
    elseif($NUMRANDOM -in 5001..8000){$NUMLEVEL=2}
    elseif($NUMRANDOM -in 8001..9000){$NUMLEVEL=3}
    elseif($NUMRANDOM -in 9001..9500){$NUMLEVEL=4}
    elseif($NUMRANDOM -in 9501..9750){$NUMLEVEL=5}
    elseif($NUMRANDOM -in 9751..9850){$NUMLEVEL=6}
    elseif($NUMRANDOM -in 9851..9900){$NUMLEVEL=7}
    elseif($NUMRANDOM -in 9901..9930){$NUMLEVEL=8}
    elseif($NUMRANDOM -in 9930..9950){$NUMLEVEL=9}
    elseif($NUMRANDOM -in 9951..9968){$NUMLEVEL=10}
    elseif($NUMRANDOM -in 9969..9983){$NUMLEVEL=11}
    elseif($NUMRANDOM -in 9984..9991){$NUMLEVEL=12}
    elseif($NUMRANDOM -in 9992..9996){$NUMLEVEL=13}
    elseif($NUMRANDOM -in 9997..9999){$NUMLEVEL=14}
    else{$NUMLEVEL=15}
    if($NUMLEVEL -eq 1){$DEVELOPMENTPOINT = 600}
    else{$DEVELOPMENTPOINT = 500 + (100 * $NUMLEVEL)}
    
    if(($NUMLEVEL % 2) -eq 0){$CHARACTERPOINT = $NUMLEVEL / 2}
    else{$CHARACTERPOINT = ($NUMLEVEL - 1) / 2}

    $NUMBERS = @(0..18)
    $NUMBERS.Item(0) = Get-Random -Maximum $MAXRACE
    $NUMBERS.Item(1) = Get-Random -Maximum $MAXCLASS
    $NUMBERS.Item(2) = $NUMLEVEL
    $NUMBERS.Item(3) = $DEVELOPMENTPOINT
    $NUMBERS.Item(4) = $DEVELOPMENTPOINT
    $NUMBERS.Item(5) = $CHARACTERPOINT
    $NUMBERS.Item(6) = $SEX
    $NUMBERS.Item(7) = Get-Random -Minimum 1 -Maximum 11
    ########################################
    # Index of Array of NUMBERS
    # Index 0 = Race
    # Index 1 = Class
    # Index 2 = Level
    # Index 3 = MAX Development Points
    # Index 4 = Current Development Points
    # Index 5 = MAX Characteristic + Points
    # Index 6 = Sex (0 = Female)(1 = Male)
    # Index 7 = Appearence
    # Index 8 = STR
    # Index 9 = DEX
    # Index 10 = AGI
    # Index 11 = CON
    # Index 12 = INT
    # Index 13 = POW
    # Index 14 = WP
    # Index 15 = PER
    # Index 16 = Movement
    # Index 17 = Fatigue
    # Index 18 = Size
    ########################################
    # Characterisitc Numbers start on Index 7
    # Physical Stats start on Index 15
    for($i=8; $i -le 15; $i++){
        $NUMBERS.Item($i) = Get-Random -Minimum 4 -Maximum 11
    }
    $NUMBERS = modification $RACEFILE $NUMBERS
    for($i=0;$i -lt 61;$i++){
        $NUMBERS += 0
    }
    $NUMBERS = baseCalc $CLASSFILE $NUMBERS
    return $NUMBERS
}
function fileLocation (){
    $FILE = $Args[0]
    $FILEPARTS = $FILE.Split(".")

    $PARENTFOLDER = ".\CharacterSheets"
    if (Test-Path $FILE){ 
        $latest = Get-ChildItem -Path $PARENTFOLDER | Sort-Object Name -Descending | Select-Object -First 1
        #split the latest filename, increment the number, then re-assemble new filename:
        $newFileName = $latest.BaseName.Split('_')[0] + "_" + ([int]$latest.BaseName.Split('_')[1] + 1).ToString().PadLeft(6,"0") + $latest.Extension
        #Move-Item -path $FILEPARTS[1] -destination $PARENTFOLDER"\"$newFileName
        $newFileName = $PARENTFOLDER +"\"+$newFileName
        return $newFileName
    }
    return $FILE
}
function fileConstruction(){
    $RACEFILE = $Args[0]
    $CLASSFILE = $Args[1]
    $BONUSMODSFILE = $Args[2]
    $CLASSDIRECTORY = $Args[3]
    $STATSFILE = $Args[4]
    $BONUSDIR = $Args[5]
    $CHARACTERISTICBONUS = $Args[6]
    $WEIGHTS = $Args[7]
    $HEIGHTS = $Args[8]
    $SHEETDIR = $Args[9]
    $ARRAY = $Args[10]
    $FILE = $Args[11]
    $LP = @(5,20,40,55,70,80,95,110,120,135,150,160,175,185,200,215,225,240,250,265)
    ########################################
    # Index of Array of ARRAY
    # Index 0 = Race
    # Index 1 = Class
    # Index 2 = Level
    # Index 3 = MAX Development Points
    # Index 4 = Current Development Points
    # Index 5 = MAX Characteristic + Points
    # Index 6 = Sex (0 = Female)(1 = Male)
    # Index 7 = Appearence
    # Index 8 = STR
    # Index 9 = DEX
    # Index 10 = AGI
    # Index 11 = CON
    # Index 12 = INT
    # Index 13 = POW
    # Index 14 = WP
    # Index 15 = PER
    # Index 16 = Movement
    # Index 17 = Fatigue
    # Index 18 = Size
    # Index 19 - 24 = Un-needed stuff
    # Index 25 = Combat Limit
    # Index 26 - 31 = Combat Stats
    # Index 31 = Supernatural Limit
    # Index 32 - 38 = Supernatural Stats
    # Index 39 = Psychic Limit
    # Index 40 - 41 = Psychic Stats  
    # Index 42 - 81 = Secondary Abilities
    ########################################
    $ARRAY.Item(0) = Get-Content $RACEFILE | Select -Index $ARRAY.Item(0)
    $ARRAY.Item(1) = Get-Content $CLASSFILE | Select -Index $ARRAY.Item(1)
    $ARRAY.Item(6) = if($ARRAY.Item(6) -eq 0){Write-Output "Female"}else{Write-Output "Male"}

    $LOC = $CLASSDIRECTORY + $ARRAY.Item(1)
    $BONUSLOC = $BONUSDIR + $ARRAY.Item(1)

    $CHARLP = Get-Content $LOC | Select -Index 3
    $FINALCHARLP = [int]$LP[$ARRAY.Item(11)] + ([int]$CHARLP * $ARRAY.Item(2))

    $HEIGHTFILE = $HEIGHTS + $ARRAY.Item(18)
    $WEIGHTFILE = $WEIGHTS + $ARRAY.Item(18)

    $RANDOMHEIGHT = Get-Random -Maximum (Get-Content $HEIGHTFILE | Measure-Object -Line | Select-Object -ExpandProperty Lines)
    $RANDOMWEIGHT = Get-Random -Maximum (Get-Content $WEIGHTFILE | Measure-Object -Line | Select-Object -ExpandProperty Lines)
    
    $CHOSENHEIGHT = Get-Content $HEIGHTFILE | Select -Index $RANDOMHEIGHT
    $CHOSENWEIGHT = Get-Content $WEIGHTFILE | Select -Index $RANDOMWEIGHT
    
    
    $CHOSENCLASS = $($ARRAY.Item(1) -creplace '([A-Z\W_]|\d+)(?<![a-z])',' $&').Trim()
    $FINALDP = $ARRAY.Item(4)
    $CHOSENRACE =  $(($ARRAY.Item(0) -creplace '([\w\s\.\(\)])(?<![a-z])',' $&').Trim())
    $CHOSENSEX = $($ARRAY.Item(6))
    $CHOSENLEVEL = [string]$($ARRAY.Item(2))
    $CHOSENAPPEARANCE = [string]$($ARRAY.Item(7))
    $STATNAME = @("STR","DEX","AGI","CON","INT","POW","WP","PER")
    $CHOSENSIZE = [string]$($ARRAY.Item(18))

    Write-Output "Name:".PadRight(15," ") >> $FILE
    Write-Output ("Class: $($CHOSENCLASS)".PadRight(30, " ") + "Hair/ Eyes:") >> $FILE
    Write-Output ("Level: $($CHOSENLEVEL)".PadRight(30, " ") + "Age: ".PadRight(16, " ")) >> $FILE
    Write-Output ("Gender: $($CHOSENSEX)".PadRight(30, " ") + "Height, Weight: `t$($CHOSENHEIGHT) / $($CHOSENWEIGHT)".PadLeft(30, " ")) >> $FILE
    Write-Output ("Race: $($CHOSENRACE)".PadRight(30, " ") + "Appearance: $($CHOSENAPPEARANCE)".PadRight(15, " ") + "`t" + "Size: $($CHOSENSIZE)".PadRight(15, " ")) >> $FILE
    $n = 8
    Write-Output ("".PadRight(61, "-")) >> $FILE
    Write-Output ("".PadRight(20, " ") + "Base".PadRight(15, " ") + "Class".PadRight(15, " ")) >> $FILE
    Write-Output ("Life Points:".PadRight(20, " ") + "$($LP[$ARRAY.Item(11)])".PadRight(15, " ") + "$([int]$CHARLP * $ARRAY.Item(2))") >> $FILE
    Write-Output ("".PadRight(61, "-")) >> $FILE
    Write-Output ("".PadRight(20, " ") + "Base".PadRight(15, " ") + "Agility".PadRight(15, " ") + "Dexterity".PadRight(15, " ") + "Class".PadRight(15, " ")) >> $FILE
    Write-Output ("Initiative".PadRight(20, " ") + "20".PadRight(15, " ") + "$(Get-Content $BONUSMODSFILE | Select -Index ($ARRAY.Item(10) - 1))".PadRight(15, " ") + "$(Get-Content $BONUSMODSFILE | Select -Index ($ARRAY.Item(9) - 1))".PadRight(15, " ") + "$([int]$(Get-Content $LOC | Select -Index 3) * $ARRAY.Item(2))") >> $FILE
    Write-Output ("".PadRight(61, "-")) >> $FILE
    Write-Output "Development Point(s): $($FINALDP)".PadRight(15, " ") >> $FILE
    Write-Output ("".PadRight(61, "-")) >> $FILE
    Write-Output ("Characteristic".PadRight(32, " ") + "| Bonus".PadRight(30, " ")) >> $FILE
    foreach($stats in $STATNAME){
        $BONUSSTAT = [string]$(Get-Content $BONUSMODSFILE | Select -Index ($ARRAY.Item($n) - 1)) # STR value
        Write-Output ("$($stats)`t:`t" + "$($ARRAY.Item($n))".PadLeft(8, " ") + "`t|`t" + "$($BONUSSTAT)".PadLeft(4, " ")) >> $FILE
        $n = $n + 1
    }
    $WRONGNUMBERS = @(13,21)
    $VARIABLES = ("CHARBONUS", "BASE", "CLASSBONUS")

    Write-Output (" ".PadRight(15, " ") + "Base".PadLeft(8, " ") + "Special".PadLeft(8, " ")) >> $FILE

    Write-Output ("Fatigue".PadRight(15, " ") + "$($ARRAY.Item(17))".PadLeft(8, " ") + "--".PadLeft(8, " ")) >> $FILE

    Write-Output (" ".PadRight(15, " ") + "Base".PadLeft(8, " ") + "Penalty".PadLeft(8, " ") + "Bonus".PadLeft(8, " ") + "Final".PadLeft(8, " ")) >> $FILE

    Write-Output ("Movement".PadRight(15, " ") + "$($ARRAY.Item(16))".PadLeft(8, " ") + "--".PadLeft(8, " ") + "$(Get-Content $BONUSMODSFILE | Select -Index ($ARRAY.Item(10) - 1))".PadLeft(8, " ") + "--".PadLeft(8, " ")) >> $FILE
    
    Write-Output "" >> $FILE
    Write-Output ("Stat".PadRight(21, " ") + "Base".PadLeft(8, " ") + "Bonus".PadLeft(8, " ") + "Special".PadLeft(8, " ") + "Class".PadLeft(8, " ") + "Final".PadLeft(8, " ")) >> $FILE
    Write-Output ("".PadRight(61, "-")) >> $FILE
    for($i=7;$i -lt 62;$i++){

        if($WRONGNUMBERS -notcontains $i){

            $STAT = $(Get-Content $STATSFILE | Select -Index $i)
            $BASE = $ARRAY.Item($i + 18) / $(Get-Content $LOC | Select -Index $i)
            $CHARBONUS = Get-Content $CHARACTERISTICBONUS | Select -Index $i
            $CLASSBONUS = $([int]$(Get-Content $BONUSLOC | Select -Index $i) * $ARRAY.Item(2))
            switch ($CHARBONUS){
                \-\- {$CHARBONUS = "--"}
                STR {$CHARBONUS = Get-Content $BONUSMODSFILE | Select -Index ($ARRAY.Item(8) - 1)}
                DEX {$CHARBONUS = Get-Content $BONUSMODSFILE | Select -Index ($ARRAY.Item(9) - 1)}
                AGI {$CHARBONUS = Get-Content $BONUSMODSFILE | Select -Index ($ARRAY.Item(10) - 1)}
                CON {$CHARBONUS = Get-Content $BONUSMODSFILE | Select -Index ($ARRAY.Item(11) - 1)}
                INT {$CHARBONUS = Get-Content $BONUSMODSFILE | Select -Index ($ARRAY.Item(12) - 1)}
                POW {$CHARBONUS = Get-Content $BONUSMODSFILE | Select -Index ($ARRAY.Item(13) - 1)}
                WP {$CHARBONUS = Get-Content $BONUSMODSFILE | Select -Index ($ARRAY.Item(14) - 1)}
                PER {$CHARBONUS = Get-Content $BONUSMODSFILE | Select -Index ($ARRAY.Item(15) - 1)}
            }
            foreach($vars in $VARIABLES){
                if($(Get-Variable -Value $vars) -eq 0){
                   Set-Variable -Name $vars -Value "--" 
                }
            }
            if($CLASSBONUS -gt 50 -and ($i -in 7..9)){
                $CLASSBONUS = 50
            }
            $BASE = [string]$BASE
            $CHARBONUS = [string]$CHARBONUS
            $CLASSBONUS = [string]$CLASSBONUS
            $STAT = $STAT.PadRight(21, " ")
            $BASE = $BASE.PadLeft(8, " ")
            $CHARBONUS = $CHARBONUS.PadLeft(8, " ")
            $CLASSBONUS = $CLASSBONUS.PadLeft(8, " ")
            $SPEBONUS = "--".PadLeft(8, " ")
            Write-Output "$($STAT)$($BASE)$($CHARBONUS)$($SPEBONUS)$($CLASSBONUS)$($SPEBONUS)" >> $FILE

        }
    }
}
for($r=0;$r -lt [int]$XTIMES[1].Trim(); $r++){
    $NUMBERS = numbers $RACE $CLASS
    $FILENAME = fileLocation $FILENAME
    fileConstruction $RACE $CLASS $BONUSMODS $CLASSDIR $ABILITYNAME $CLASSBONUSDIR $CHARACTERISTICBONUS $WEIGHT $HEIGHT $CHARACTERDIRECTORY $NUMBERS $FILENAME
}