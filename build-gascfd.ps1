# Builds the two gasCFD FluidX3D binaries with Visual Studio 2022 Build Tools:
#   bin\FluidX3D.exe         live interactive window
#   bin-export\FluidX3D.exe  headless frame export (GASCFD_EXPORT)
$ErrorActionPreference = "Stop"
$msbuild = "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\MSBuild\Current\Bin\MSBuild.exe"
$common = @("FluidX3D.vcxproj", "/p:Configuration=Release", "/p:Platform=x64", "/p:PlatformToolset=v143", "/p:WindowsTargetPlatformVersion=10.0.26100.0", "/m", "/v:minimal", "/nologo")
Push-Location $PSScriptRoot
try {
    & $msbuild @common
    if ($LASTEXITCODE -ne 0) { throw "live build failed" }
    $env:CL = "/DGASCFD_EXPORT"
    & $msbuild @common "/p:OutDir=$PSScriptRoot\bin-export\" "/p:IntDir=$PSScriptRoot\temp-export\"
    if ($LASTEXITCODE -ne 0) { throw "export build failed" }
} finally {
    Remove-Item Env:CL -ErrorAction SilentlyContinue
    Pop-Location
}
