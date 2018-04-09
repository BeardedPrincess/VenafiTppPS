function Get-TppConfig {
    <#
	.SYNOPSIS 
	Get all attributes for a given object
	
	.DESCRIPTION
	Returns all values of an object’s attribute, excluding values assigned by policy

	.PARAMETER Path
    Path to the object to retrieve configuration attributes.  Just providing Path will return all attributes.

	.PARAMETER AttributeName
    Only retrieve the value/values for this attribute

	.PARAMETER EffectivePolicy
    Get the effective policy of the attribute

	.PARAMETER VenafiSession
    Session object created from New-TppSession method.  The value defaults to the script session object $VenafiSession.

	.INPUTS

	.OUTPUTS

	.EXAMPLE

	#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ParameterSetName = 'EffectivePolicy', ValueFromPipelineByPropertyName)]
        [Parameter(Mandatory, ParameterSetName = 'NonEffectivePolicy', ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [Alias("DN")]
        [String[]] $Path,
        
        [Parameter(Mandatory, ParameterSetName = 'EffectivePolicy')]
        [Parameter(ParameterSetName = 'NonEffectivePolicy')]
        [ValidateNotNullOrEmpty()]
        [String] $AttributeName,

        [Parameter(Mandatory, ParameterSetName = 'EffectivePolicy')]
        [Switch] $EffectivePolicy,

        $VenafiSession = $Script:VenafiSession
    )

    begin {

        $VenafiSession = $VenafiSession | Test-TppSession

        if ( $AttributeName ) {
            if ( $EffectivePolicy ) {
                $uriLeaf = 'config/ReadEffectivePolicy'
            } else {
                $uriLeaf = 'config/read'
            }
        } else {
            $uriLeaf = 'config/readall'
        }
    }

    process {
	
        foreach ( $thisPath in $Path ) {

            $params = @{
                VenafiSession = $VenafiSession
                Method        = 'Post'
                UriLeaf       = $uriLeaf
                Body          = @{
                    ObjectDN = $thisPath
                }
            }

            if ( $AttributeName ) {
                $params.Body += @{
                    AttributeName = $AttributeName
                }
            }

            $response = Invoke-TppRestMethod @params

            if ( $response ) {
                if ( $AttributeName ) {
                    $response.Values
                } else {
                    $response.NameValues
                }
            }
        }
    }
}