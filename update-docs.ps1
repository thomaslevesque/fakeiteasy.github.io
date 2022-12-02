param (
    [Parameter(Mandatory = $true)]
    [string]
    $Version,
    [Parameter(Mandatory = $true)]
    [string]
    $FakeItEasyDir,
    [Parameter()]
    [string]
    $BranchName
)

if ([string]::IsNullOrEmpty($BranchName)) {
    $BranchName = "update-$Version-docs"
}

$FakeItEasyDir = (Get-Item $FakeItEasyDir).FullName

$GitUserName = (git config user.name)
$GitUserEmail = (git config user.email)

if ($LASTEXITCODE) { Throw "Failed with exit code $LASTEXITCODE." }

docker run `
    -v "$($FakeItEasyDir):/tmp/FakeItEasy" `
    -v "$($PSScriptRoot):/tmp/website" `
    -e GIT_USER_NAME="$GitUserName" `
    -e GIT_USER_EMAIL="$GitUserEmail" `
    --rm `
    python:latest `
    /tmp/website/mike-deploy.sh -v $Version -f /tmp/FakeItEasy -b $BranchName

if ($LASTEXITCODE) { Throw "Failed with exit code $LASTEXITCODE." }
