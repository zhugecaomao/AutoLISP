本程序可以将 ACAD 命令和特定的层对应起来，比如可以将尺寸指定到“Dim”层，因为我们在用 ACAD 画图时，为了便于管理，一般将尺寸放在同一层内，但具体操作时较麻烦。具体办法可以修改菜单。比如可以在，在命令前加上(setvar "CLAYER" "DIMLAYER")让他自动转到尺寸层"DIMLAYER"上去。不过还不够完美，最好的办法就是在标尺寸时， ACAD 能自动将尺寸标注到尺寸层上去。这个程序就是用来实现这个功能的。标注尺寸时，如果指定的尺寸层已经存在，就转到尺寸层上，如果还没有尺寸层，就会自动建一个。其他命令，只要不是透明命令，都可以到指定层上去，至于具体是什么层，请看配置文件 Specifylayer.ini。
配置文件 Specifylayer.ini 格式：等号左边是命令，右边是层名。你可以随意添加命令和层的对应关系。但命令不能是 AutoLISP 的函数产生的命令。 Specifylayer.ini 可直接用记事本打开编辑。
程序加载方法：将 Specifylayer.arx、Specifylayer.ini 和 acad.rx 复制到 ACAD200X 的安装目录下即可。如果安装目录下已经有文件 acad.rx 了，就将 acad.rx 里的内容添加到原文件里，重新运行ACAD200X 即可。 acad.rx 可直接用记事本打开编辑。

多重配置通过在命令行输入"SPLAYER"命令后再输入组名来实现，如"GROUP1"则采用[COMMAND/GROUP1]内的配置，如果[COMMAND/GROUP1]内找不到对应的命令，再到[COMMAND]里去找，有则切换到相应的层上。
为了使用方便，您可以在ACAD里加上一些按钮，按钮执行一个命令，如 "SPLAYER GROUP1"或"SPLAYER GROUP2"……
"GROUP1"、"GROUP2"……与配置文件对应。具体方法请参考有关书籍。

例如:Specifylayer.ini文件内容为如下时
[COMMAND]
DIMLINEAR=Dim
DIMALIGNED=Dim
DIMORDINATE=Dim
DIMRADIUS=Dim
DIMDIAMETER=Dim
DIMANGULAR=Dim
DIMBASELINE=Dim
DIMCONTINUE=Dim
QDIM=Dim
QLEADER=Dim
TOLERANCE=Dim
DIMCENTER=Dim
BHATCH=Hatch
HATCH=Hatch

[COMMAND/GROUP1]
DIMLINEAR=Dim1

则缺省时运行DIMLINEAR，转到Dim层上。执行命令"SPLAYER;GROUP1"后运行DIMLINEAR，转到Dim1层上。运行DIMALIGNED，转到Dim层上。

程序野史：

2003年3月31日
支持AutoCAD 2004版

2003年3月17日
这个程序放到网上后，不少网友认为那个对话框比较讨厌，就改了一下。呵呵，现在不会每次跳出来了。
顺便加了个小功能，在切换多重配置，在左下角会显示配置方案名，比如GROUP1

2002年4月4日
程序新增了多种配置的功能

2001年7月26日
程序具备了自动切换层的功能

如有什么意见和建议，请告诉我。
我的EMail: gu_wenwei@sina.com

	顾文伟	2003.03.31