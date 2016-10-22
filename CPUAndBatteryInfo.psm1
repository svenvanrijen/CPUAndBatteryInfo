<#
    .Synopsis
    Short description
    .DESCRIPTION
    Long description
    .EXAMPLE
    Example of how to use this cmdlet
    .EXAMPLE
    Another example of how to use this cmdlet
#>
function Get-CPUInfo
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

    $range = 1..$Repeats
    
    foreach ($Computer in $ComputerName) 
    {
      Foreach ($i in $range) 
      {
        Write-Verbose -Message "Connecting to $Computer"
        $CPU = Get-WmiObject -ComputerName $Computer -Class Win32_Processor  
            
        $properties = [ordered]@{
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

    $range = 1..$Repeats
    
    foreach ($Computer in $ComputerName) 
    {
      Foreach ($i in $range) 
      {
        $namespace = "root\WMI" 
        Write-Verbose -Message "Connecting to $Computer"
        $Bat = Get-WmiObject -ComputerName $Computer -Class Win32_Battery
        $BatStat =  Get-WmiObject -class BatteryStatus -computername $Computer -namespace $namespace 
           
        $properties = [ordered]@{
          'ComputerName'    = $Computer
          'Battery Availability' = $Bat.Availability
          'Battery Status' = $Bstatus
          'Battery Active' = $BatStat.Active
          'Charge Rate'= $BatStat.ChargeRate
          'Charging?' = $BatStat.Charging
          'Power Online?' = $BatStat.PowerOnline   
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

#svenvanrijen