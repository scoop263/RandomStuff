

$RACE = ".\Properties\Race"
$CLASS = ".\Properties\Classes"
$CHARACTERISTIC = ".\Properties\PrimaryCharacteristics"
$BONUSMODS = ".\Properties\CharacteristicModifier"
$CLASSDIR = ".\Properties\Class\"
$ABILITYNAME = ".\Properties\InitialClassTotal"
$CLASSBONUSDIR = ".\Properties\Class\Bonus\"
$CHARACTERISTICBONUS = ".\Properties\InitialBonus"
$QUICKSTORAGE = ".\Properties\NumbersCharacter"
$WEIGHT = ".\Properties\Weight\Size"
$HEIGHT = ".\Properties\Height\Size"
$CHARACTERDIRECTORY = ".\CharacterSheets\"



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
    if($ARCHETYPE -eq "Fighter"){$PERCENT = @(95,1,1,95)}
    elseif($ARCHETYPE -eq "Mystic"){$PERCENT = @(10,95,1,95)}
    elseif($ARCHETYPE -eq "Prowler"){$PERCENT = @(95,2,2,95)}
    elseif($ARCHETYPE -eq "Psychic"){$PERCENT = @(2,20,95,95)}
    elseif($ARCHETYPE -eq "Domine"){$PERCENT = @(95,20,20,95)}
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
                [System.Collections.ArrayList]$SUCCESS = @(1..$PERCENT.Item(0+$q))
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
            #    $DPTOSPEND = $points * $DPNUM
            #                    $CURRENTDP = $CURRENTDP - $DPTOSPEND
            #                    $DPTOSPEND = $CURRENTDP
            #$VAL = $i + 18
            #$ARRAY.Item(4) = $CURRENTDP
            #$ARRAY.Item($VAL) = $DPTOSPEND
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
    # Index of Array of ARRAY
    # Index 0 = Race
    # Index 1 = Class
    # Index 2 = Level
    # Index 3 = MAX Development Points
    # Index 4 = MAX Characteristic + Points
    # Index 5 = Sex (0 = Female)(1 = Male)
    # Index 6 = Appearence
    # Index 7 = STR
    # Index 8 = DEX
    # Index 9 = AGI
    # Index 10 = CON
    # Index 11 = INT
    # Index 12 = POW
    # Index 13 = WP
    # Index 14 = PER
    # Index 15 = Movement
    # Index 16 = Fatigue
    # Index 17 = Size
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
    ######################
    # 
    ######################
    for($i=0;$i -lt 61;$i++){
        $NUMBERS += 0
    }
    $NUMBERS = baseCalc $CLASSFILE $NUMBERS
    return $NUMBERS
}
for($r=0;$r -lt 100; $r++){
    $NUMBERS = numbers $RACE $CLASS
    write-host $NUMBERS
    Remove-Variable NUMBERS
}