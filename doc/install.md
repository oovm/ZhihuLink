

## 编码

为避免因编码引起的麻烦, 在安装或运行前请使用 `$CharacterEncoding = "UTF8"` 命令将 FrontEnd 编码指定为 UTF-8.

强烈建议您将这个命令写入初始化文件 `init.m` 文件中, 以下命令只需运行一次.

```Mathematica
st=OpenAppend[FindFile["init.m"]];
WriteString[st,"$CharacterEncoding=\"UTF8\";"];
Close[st];
```

## 安装

Todo