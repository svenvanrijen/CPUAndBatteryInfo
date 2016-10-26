<#
    .Synopsis
    This module generates diagnostic data, that can be used in case of slow boot and/or logon of your laptop.
    .DESCRIPTION
    This module generates diagnostic data, that can be used in case of slow boot and/or logon of your laptop. 
    Data on both CPU and Battery can be generated. Please note that generating battery data is only supported on laptops.
    .EXAMPLE
    Get-CPUInfo -Repeat 1 -Wait 1
    In this example, you'll receive CPU info from the localhost (default). The script will just run once (default is 10). 
    The timeout after every run is 1 second (default is 10).
    .EXAMPLE
    Get-BatteryInfo -Computername client1 -Repeat 3 -Wait 5
    In this example, you'll receive Battery info from client1 (default is localhost). The script will just run three times (default is 10). 
    The timeout after every run is 5 seconds (default is 10).
    .EXAMPLE
    Get-CPUAndBatteryInfo -ComputerName client1, client2
    In this example, you'll receive both CPU and Battery info, from both client1 and client2 (default is localhost only).
    The script will run ten times (default). 
    The timeout after every run is 10 seconds (default).
#>
function Get-CPUInfo
{
  [OutputType([int])]
  Param
  (
    [Parameter(ValueFromPipelineByPropertyName = $true,
    Position = 0)]
    [Alias('cn')]           
    [string[]]$ComputerName = $env:COMPUTERNAME,

    [Parameter(ValueFromPipelineByPropertyName = $true)]       
    [int]$Repeats = '10',

    [Parameter(ValueFromPipelineByPropertyName = $true)]       
    [int]$Wait = '10'
                  
  )

  Begin
  {
  }
    
  Process
  {

    $range = 1..$Repeats
    
    foreach ($Computer in $ComputerName) 
    {
      Foreach ($i in $range) 
      {
        $datetime = Get-Date
        Write-Verbose -Message "$datetime : Connecting to $Computer"
        $CPU = Get-WmiObject -ComputerName $Computer -Class Win32_Processor  
            
        $properties = [ordered]@{
          'Date and time'     = $datetime
          'ComputerName'      = $Computer
          'CPU Name'          = $CPU.Name
          'Current Clock Speed' = $CPU.CurrentClockSpeed
          'Maximum Clock Speed' = $CPU.MaxClockSpeed
          'Load Percentage'   = $CPU.LoadPercentage
        }
        $output = New-Object -TypeName PSObject -Property $properties
        Write-Output -InputObject $output
        Start-Sleep -Seconds $Wait                            
      }
    }
    
  }
    
  End
  {
  }
}

function Get-BatteryInfo
{
  [OutputType([int])]
  Param
  (
    # Param1 help description
    [Parameter(ValueFromPipelineByPropertyName = $true,
    Position = 0)]
    [Alias('cn')]           
    [string[]]$ComputerName = $env:COMPUTERNAME,

    # Param2 help description
    [Parameter(ValueFromPipelineByPropertyName = $true)]       
    [int]$Repeats = '10',

    # Param3 help description
    [Parameter(ValueFromPipelineByPropertyName = $true)]       
    [int]$Wait = '10'
                  
  )

  Begin
  {
  }
    
  Process
  {     
    Write-Host -Object 'Caution: this command can only be used on a laptop!' -ForegroundColor Yellow
    
    Start-Sleep -Seconds 5

    $range = 1..$Repeats
    
    foreach ($Computer in $ComputerName) 
    {
      Foreach ($i in $range) 
      {
        $namespace = 'root\WMI' 
        $datetime = Get-Date
        Write-Verbose -Message "$datetime : Connecting to $Computer"
        $Bat = Get-WmiObject -ComputerName $Computer -Class Win32_Battery
        $BatStat = Get-WmiObject -Class BatteryStatus -ComputerName $Computer -Namespace $namespace 
           
        $properties = [ordered]@{
          'Date and time'      = $datetime
          'ComputerName'       = $Computer
          'Battery Availability' = $Bat.Availability
          'Battery Status'     = $Bat.Status
          'Battery Active'     = $BatStat.Active
          'Charge Rate'        = $BatStat.ChargeRate
          'Charging?'          = $BatStat.Charging
          'Power Online?'      = $BatStat.PowerOnline
        }

        $output = New-Object -TypeName PSObject -Property $properties
        Write-Output -InputObject $output
        Start-Sleep -Seconds $Wait                            
      }
    }
    
  }
    
  End
  {
  }
}

function Get-CPUAndBatteryInfo
{
  [OutputType([int])]
  Param
  (
    # Param1 help description
    [Parameter(ValueFromPipelineByPropertyName = $true,
    Position = 0)]
    [Alias('cn')]           
    [string[]]$ComputerName = $env:COMPUTERNAME,

    # Param2 help description
    [Parameter(ValueFromPipelineByPropertyName = $true)]       
    [int]$Repeats = '10',

    # Param3 help description
    [Parameter(ValueFromPipelineByPropertyName = $true)]       
    [int]$Wait = '10'
                  
  )

  Begin
  {
  }
    
  Process
  {
  
    Write-Host -Object 'Caution: this command can only be used on a laptop!' -ForegroundColor Yellow
    
    Start-Sleep -Seconds 5

    $range = 1..$Repeats
    
    foreach ($Computer in $ComputerName) 
    {
      Foreach ($i in $range) 
      {
        $namespace = 'root\WMI' 
        $datetime = Get-Date
        Write-Verbose -Message "$datetime : Connecting to $Computer"
        $CPU = Get-WmiObject -ComputerName $Computer -Class Win32_Processor
        $Bat = Get-WmiObject -ComputerName $Computer -Class Win32_Battery
        $BatStat = Get-WmiObject -Class BatteryStatus -ComputerName $Computer -Namespace $namespace 
           
        $properties = [ordered]@{
          'Date and time'      = $datetime
          'ComputerName'       = $Computer
          'CPU Name'           = $CPU.Name
          'Current Clock Speed' = $CPU.CurrentClockSpeed
          'Maximum Clock Speed' = $CPU.MaxClockSpeed
          'Load Percentage'    = $CPU.LoadPercentage
          'Battery Availability' = $Bat.Availability
          'Battery Status'     = $Bat.Status
          'Battery Active'     = $BatStat.Active
          'Charge Rate'        = $BatStat.ChargeRate
          'Charging?'          = $BatStat.Charging
          'Power Online?'      = $BatStat.PowerOnline
        }

        $output = New-Object -TypeName PSObject -Property $properties
        Write-Output -InputObject $output
        Start-Sleep -Seconds $Wait                            
      }
    }
    
  }
    
  End
  {
  }
}
