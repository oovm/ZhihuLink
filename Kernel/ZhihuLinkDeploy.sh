#!/usr/bin/env bash
#
wolframscript -script ./ZhihuLinkBuild.wls
#
cd ../..
rm -rf ZhihuLinkTemp
cp -rf ZhihuLink ZhihuLinkTemp
cd ZhihuLinkTemp
#
rm -rf .git
rm -rf .idea
rm -rf Resources
rm -rf Packages/__Dev
rm -rf Packages/__Raw
rm -f .gitignore
rm -f Kernel/ZhihuLink*
#
echo "Print@PackPaclet[DirectoryName@ExpandFileName[First[\$ScriptCommandLine]]]" > ZhihuLinkPack.wls
echo "Packing:"
wolframscript -script ./ZhihuLinkPack.wls
echo "deploy finish, Ctrl+C to exit."
sleep 600