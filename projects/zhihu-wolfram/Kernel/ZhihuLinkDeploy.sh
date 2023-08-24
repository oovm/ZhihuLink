#!/usr/bin/env bash
# 构建更新Raw程序包
wolframscript -script ./ZhihuLinkBuild.wls
# 拷贝副本
cd ../..
rm -rf ZhihuLinkTemp
cp -rf ZhihuLink ZhihuLinkTemp
cd ZhihuLinkTemp
# 清理非必要文件
rm -rf .git
rm -rf .idea
rm -rf Resources/Image
rm -rf Resources/Test
rm -rf Packages/__Dev
rm -rf Packages/__Raw
rm -f .gitignore
rm -f Kernel/ZhihuLink*
# 安装包打包
echo "Print@FileBaseName@PackPaclet[DirectoryName@ExpandFileName[First[\$ScriptCommandLine]]]" > ZhihuLinkPack.wls
echo "  "
echo "Packing:"
paclet=`wolframscript -script ./ZhihuLinkPack.wls`
echo ${paclet}
echo "  "
# 导入秘钥, 获取版本号
GH_USER=GalAster
GH_TOKEN=`cat ~/.ssh/github_token`
VERSION=`awk 'BEGIN{info="'${paclet}'";print substr(info,11);}'`
file_name=ZhihuLink-${VERSION}.paclet
# 创建一个release tag
dt=`date +"%Y-%m-%d %H:%M"`
res=`curl --user "$GH_USER:$GH_TOKEN" -X POST https://api.github.com/repos/wjxway/ZhihuLink-Mathematica/releases \
-d "
{
  \"tag_name\": \"v$VERSION\",
  \"target_commitish\": \"dev\",
  \"name\": \"Auto Build-v$VERSION\",
  \"body\": \"Auto Build $VERSION paclet by Gal@Builder at $dt :octocat: .\",
  \"draft\": false,
  \"prerelease\": false
}"`
#解析返回的 json
parse_json(){
    value=`echo $1 | sed 's/.*"url":[^,}]*.*/\1/'`
    echo ${value} | sed 's/\"//g'
}
function fuckJson() {
    awk -v json="$1" -v key="$2" -v defaultValue="$3" 'BEGIN{
        foundKeyCount = 0
        while (length(json) > 0) {
            pos = match(json, "\""key"\"[ \\t]*?:[ \\t]*");
            if (pos == 0) {if (foundKeyCount == 0) {print defaultValue;} exit 0;}

            ++foundKeyCount;
            start = 0; stop = 0; layer = 0;
            for (i = pos + length(key) + 1; i <= length(json); ++i) {
                lastChar = substr(json, i - 1, 1)
                currChar = substr(json, i, 1)

                if (start <= 0) {
                    if (lastChar == ":") {
                        start = currChar == " " ? i + 1: i;
                        if (currChar == "{" || currChar == "[") {
                            layer = 1;
                        }
                    }
                } else {
                    if (currChar == "{" || currChar == "[") {
                        ++layer;
                    }
                    if (currChar == "}" || currChar == "]") {
                        --layer;
                    }
                    if ((currChar == "," || currChar == "}" || currChar == "]") && layer <= 0) {
                        stop = currChar == "," ? i : i + 1 + layer;
                        break;
                    }
                }
            }

            if (start <= 0 || stop <= 0 || start > length(json) || stop > length(json) || start >= stop) {
                if (foundKeyCount == 0) {print defaultValue;} exit 0;
            } else {
                print substr(json, start, stop - start);
            }

            json = substr(json, stop + 1, length(json) - stop)
        }
    }'
}
# wolframscript -code First@Extract[#,Position[#,"releases"]+1]\&[StringCases[ImportString["${res}"],WordCharacter..]]
# fuckJson "${res}" "id"
rel_id=`echo ${res} | python -c 'import json,sys;print(json.load(sys.stdin)["id"])'`
echo ${rel_id}
# 上传安装包
echo "  "
cd ..
curl --user "$GH_USER:$GH_TOKEN" \
    -X POST \
    https://uploads.github.com/repos/wjxway/ZhihuLink-Mathematica/releases/${rel_id}/assets?name=${file_name}\
    --header 'Content-Type: text/javascript ' \
    --upload-file ${file_name}

echo "  "
echo "deploy finish, Ctrl+C to exit."
sleep 60