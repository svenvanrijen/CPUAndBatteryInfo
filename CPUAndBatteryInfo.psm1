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
        [Parameter(ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [Alias('cn')]           
        [string[]]$ComputerName = 'localhost'
                  
    )

    Begin
    {
    }
    
    Process
    {
    
  foreach ($Computer in $ComputerName)
    {
      Write-Verbose "Connecting to $Computer"
      $CPU = Get-WMIObject -ComputerName $Computer -Class Win32_Processor  
            
      $properties = [ordered]@{'ComputerName'= $Computer;
                      'CPU Name'   = $CPU.Name;
                      'Current Clock Speed' = $CPU.CurrentClockSpeed;
                      'Maximum Clock Speed' = $CPU.MaxClockSpeed;
                      'Load Percentage' = $CPU.LoadPercentage}
            $output = New-Object -TypeName PSObject -Property $properties
            Write-Output $output
     }
    
    
    }
    End
    {
    }
}