# 最多五点圆数目

论坛里面有过不少关于果树种植问题的讨论，也就是n棵果树，如何种植可以使每行k棵数的行数最多。

[A337747](https://oeis.org/A337747)记录了一个类似的问题，n棵果树，如何种植，可以使得正好包含4棵树的圆最多。这个序列一个显然上界是[A001843](http://oeis.org/A001843)

关于4棵树的最多圆问题，Peter Kagey给出了一种构造性方法，在n为偶数时，使用两个同心正n/2边形的顶点，可以构造出一个相当不错的解。



那么类似的问题，n棵果树，如何种植，可以使得正好包含5棵树的圆最多？显然有上界[A004038](http://oeis.org/A004038)

为简化描述，“正好包含k棵树的圆”以下用“CCk”表示。



---
显然只有达到5棵树时，才可以有一个圆，达到8棵树时才可以有两个圆，而9棵树可以有三个圆。所以n棵树5点圆最大数目序列前9项为

0,0,0,0,1,1,1,2,3

其中9棵树3圆的构造方案还是比较简单的

![](https://bbs.emath.ac.cn/data/attachment/forum/202211/07/131207s5s6is6i0vzvgfl7.png)


那么我们如何证明9棵树最多三个圆呢？我们可以选择一个合法构造中任何一颗树，以这颗树为反演中心，对图中所有圆进行反演，那么所有经过反演中心的圆反演以后都变成直线，而且这些直线每条都另外经过四个点，这些点为余下8个点的反演。也就是说这8个点的反演可以有一批直线经过，每条直线经过四个点，根据[A006065](https://oeis.org/A006065), 这批直线最多2条。

也就是说9棵树5点圆的图中，每个点最多有两个圆经过. 对每个点都这样统计，那么每个圆会被统计5次，所以总共圆的数目不超过\(\lfloor\frac{9\times2}5\rfloor=3\).



那么现在的问题是10棵树最多几个5点圆呢？同样类似上面分析，由于9棵树每4棵一行最多3行，我们得出圆的总数不超过\(\lfloor\frac{10\times3}5\rfloor=6\).

而构造10棵树5个圆的方案比较容易，类似上面分析过程，我们先将一颗树作为反演中心，进行变换，余下9个点的反演图象最多确定三条经过4个点的直线，根据[链接内容](https://bbs.emath.ac.cn/forum.php?mod=redirect&goto=findpost&ptid=703&pid=81468&fromuid=20)，这时它们唯一解是构成一个三角形。

我们可以轻易构造出下面的反演后的图:

![](https://bbs.emath.ac.cn/data/attachment/forum/202211/07/135322rkkroke8ree7o47k.png)


所以10棵树的主要问题是是否存在一个解，有6个5点圆。如果存在6个5点圆，根据上面不等式，那么以每颗树为反演中心进行反演，得到余下9棵树反演图都是每行4棵树的行数都是3，所以要求经过每个点的都是正好3个圆。

所以对于一个反演后的图像，除了三角形ABC以外，三条边上都各自还有两个点，假设BC上还有点A1,A2, CA上还有点B1,B2,AB上还有点C1,C2.

那么余下3个5点圆只能是经过A,B,C三点中一个(如果一个圆经过两个顶点比如A,B,那么和边AB没有其它交点，而同AC,BC各自再有一个交点，将只包含9点中4个点，不符合条件）

设经过A点的圆还经过A1,A2,B1,C1

那么经过B点圆必然还经过B1,B2,A1,C2或B1,B2,A2,C1,不妨假设是前者。

那么经过C点的圆必然经过C1,C2,A2,B2

也就是要求下余下的3个圆为

(A,A1,A2,B1,C1), (B,B1,B2,A1,C2), (C,C1,C2,A2,B2).

不妨假设A(0,0), B(1,0), C(t, k*t)

C1(c1,0), C2(c2,0), B1(b1,k*b1), B2(b2,k*b2)

A1(r1+(1-r1)t, (1-r1)*k*t), A2(r2+(1-r2)*t, (1-r2)*k*t)

然后我们可以根据

(A,B1,C1,A1), (A,B1,C1,A2),

(B,B1,C2,A1), (B,B1,C2,B2),

(C,C1,C2,A2), (C,C1,C2,B2)

这6组四点共圆条件得出6条方程，有8个变量(t,k,c1,c2,b1,b2,r1,r2).

上面方程组必然有解，但是很多解中会有一些点重合在一起，需要淘汰。

如果存在所有点都不同的解，就可以找出10棵树5点圆的最大数目是6，不然就是5.



经过验算以后，同时满足上面条件的方程的解必然存在重合的解。比如根据第四个圆的方程可以计算出c2=b1*b2*(1+k^2), 再由第六个圆点方程得出t=b1c1等。最终得出所有点不重合时无解。

由此说明10棵树最多为5个5点圆。



而11棵树，我们同样可以将一棵树映射到无穷远点，余下10棵四点共线最多5条（必然是五条直线两两相交于各自不同的树）。而经过这10棵树的五点圆根据前面结论最多5个，所以得到11棵树的5点圆数目上限最多10个5点圆。而如果将上面10棵树构图采用正五角星，那么显然还可以添加两个5点圆，得出11棵树至少可以构造7个5点圆。

---
我们也顺便分析一下每个圆四棵树的情况，显然4棵和5棵都只有一个四点圆，6棵可以三个四点圆。

7棵树时，将一棵映反演到无穷远，余下六棵三点共线最多4条线(任意四条直线两两交于不同的树).

如果将7棵中任意一棵反演到无穷远，余下6棵都不超过3条线(三点共线)，那么总共四点圆数目将不超过7*3/4,所以最多5个四点圆。

如果将7棵树中某一棵反演到无穷远，余下6棵有四条线(三点共线), 那么不妨设它们构图中四条线字母标记为

AFB, AEC, DFE, DBC。

于是过着6棵树的四点圆中，

如果一个四点圆经过D点且经过B点，那么自然不能过C点(DBC共线）。而且也不能经过F点，不然因为FBA共线，不能经过A； DFE共线，不能经过E；DBC共线，不能经过C点。所以找不到第四个点。所以这个圆只能是DBEA.

同理如果一个四点圆经过D点且经过F点，只能DFAC.

同理经过A的四点圆必然经过D,也在上面两种候选圆中。所以余下第三个可能的四点圆只能BCEF.

现在我们查看是否可以三个四点圆同时存在。

由对称性，我们不妨假设已经有DBEA和BCEF都四点共圆，两圆交于B,E两点

![](https://bbs.emath.ac.cn/data/attachment/forum/202211/08/094012hhfvyixivrnlhrha.png)


如图可以看出DE垂直AC, AB垂直CE,DF,AC是不能四点共圆的。当然如果要求严格一些，最好可以进行代数方程分析。

所以上面过程得出7棵树最多6个四点圆。



而比较有意思的是8棵树的最有情况证明反而比较简单。我们将一颗树反演到无穷远点，余下7棵树构成3点共线情况根据[A003035](https://oeis.org/A003035)最多6条. 而经过这7棵树的四点圆根据上面分析也最多6个。所以8棵树最多只有12个四点圆。而采用两个同心同向正方形的顶点，可以构成12个四点圆。所以得出8棵树最多有12个四点圆。

![](https://bbs.emath.ac.cn/data/attachment/forum/202211/08/163513de6kkt6mkioijmli.png)


如图，两条绿线可以通过反演变成圆。而两个黑色圆根据对称性，四个方向都有，只是为了画面清晰，只画了一个方向。



我们已经有的不等式可以有$A337747(n) <= A003035(n-1)+A337747(n-1)$, 以及$A337747(n)<= \lfloor n\times \frac{A003035(n-1)}4 \rfloor$

所以$A337747(9) <=15$,而OEIS中说等于14，不知道15是如何排除的。

---
对于具有更多树的情况，比如求过14棵树最多的5点圆的情况，我们可以先将一棵树变换到无穷远点，余下[13棵树将最多有9行每行四棵树](https://bbs.emath.ac.cn/forum.php?mod=redirect&goto=findpost&ptid=703&pid=81471&fromuid=20)。

比如

{{13,9},"ABEFAGHMBIJMCEKMCGILDFLMDGJKEHJLFHIK",{{{"A",{1,0,0}},{"B",{0,0,1}},{"C",{1,4,1}},{"D",{-1,-4,1}},{"E",{1,0,1}},{"F",{-1,0,1}},{"G",{1,3,0}},{"H",{1,1,0}},{"I",{0,1,1}},{"J",{0,-1,1}},{"K",{1,2,1}},{"L",{-1,-2,1}},{"M",{0,1,0}}}}}

选择这种配置的最大好处是所有点的坐标已经唯一确定了，后面的分析会比较容易。

后面我们还需要找出过尽量多过上面9点中5个点的圆。可是问题是上面的图象还可以进行任意的射影变换，我们知道在射影变换下圆和其它圆锥曲线是可以任意转化的。

为此，我们可以对上面图案中找出所有任意3点不共线的5个点，得到所有它们确定的圆锥曲线。 然后对于其中任意两条圆锥曲线，如果它们之间存在虚交点（也就是实交点数目不超过2），那么如果我们通过射影变换将这两个共轭虚交点映射为两个虚圆点$(1:\pm i:0)$, 那么这两条圆锥曲线将同时转化为实圆。

所以下面的目标就比较明确了，对已任意两条圆锥曲线，我们需要计算它们的共轭虚交点对(0对，1对或2对). 然后查看所有这些共轭虚交点对，经过的圆锥曲线最多的虚交点对将是最优的选择。通过将这一对虚交点对转化为虚圆点，我们就可以得到一个包含尽量多5点圆的解答。比如对于上面方案，13个点中选择5个点有1287种不同方案，扣除包含3点共线的还有1071个5点组。我们需要在这么多圆锥曲线的两两虚交点中找出被重复使用最多的点对。

![](https://bbs.emath.ac.cn/data/attachment/forum/202211/08/203832utjz9z9r74e8ft7x.png)


而实际上如上图，由于图象对称性太好，如上图中黑色虚线圆锥曲线会过6点，也是我们需要淘汰的，而橙色圆锥曲线(ACKIB)才是我们需要的。而我们要找出另外一条和它有虚交点（实交点数目不超过2）好像很困难。



上面方案尽在对应的每行四棵树方案中所有点坐标已经确定时比较有效，在包含额外自由参数，对应圆锥曲线的交点就不好求了，复杂度就上去了。比如这时每条圆锥曲线的系数都包含参数t,我们需要先检查对于那些三组以上的圆锥曲线（甚至更多），它们有公共解（但是不包含给定的那些点）。然后在判断公共解对应的参数t是否是实数，而对应的坐标点是否为虚点。

而比较有意思的是，对于每个圆4个点（看起来更简单的问题），这个方案也不行，因为4点无法确定一条圆锥曲线。

---
对于每个圆四点的问题，如果我们已经找到一个n-1个点，每线三点线的总数比较多的一个方案。

然后对于其中任意三点不共线的四个点，我们假设过这四个点和一对待定的共轭点$(a+bi, c+di)$以及$(a-bi,c-di)$有一条圆锥曲线，我们根据六点共圆锥曲线这个条件，可以列出一个关于这四个变量a,b,c,d的一条复数方程，在让实部和虚部都相等，可以得到两个关于变量a,b,c,d的四次方程。所以如果两个四点组，我们让它们过相同的共轭点，那么就可以得到关于变量a,b,c,d的四条四次方程。根据自由度，就可以唯一确定这一对共轭点了。

但是问题是这个不符合我们的直觉，这是因为我们过四点分别任意做圆锥曲线（有无穷种选择），只要两圆锥曲线有公共虚交点，就会是一组共轭交点，不同的圆锥曲线的选择，正常情况会得到不同的共轭交点。所以最大的可能是上面方案得到的方程之间有关联性？我偏向于正常情况三个四点组可以正好一对唯一的共轭点。



上面方程使用特殊数据计算了一下，发现问题了。也就是我们使用一对共轭点放到六点共圆锥曲线的行列式方程中，最后两行是共轭的，可以使用两者和以及两者差替换，于是变成和全部实数，差全部纯虚数。纯虚数这一行可以除去i变成实数，也就是只有一条约束方程。

所以由于有四个自由度的变量，通常情况我们总是可以找到四个过四点的圆锥曲线，它们相交于公共的共轭虚点。



我试着用数据进行数值计算，但是好像没有成功，比如对于4个四点组:

(0,0), (1,0),(0,1),(1,1)

(2,2),(2,4),(3,5),(1,6)

(2,3), (4,3), (3,4), (5,7)

(4,5), (3,7), (2,6), (0,8)

可以得到四条方程

(-4*d*c + 2*d)*a^2 + ((4*c^2 - 4*c - 4*d^2)*b + (4*d*c - 2*d))*a + ((4*d*c - 2*d)*b^2 + (-2*c^2 + 2*c + 2*d^2)*b)=0

-44*d*a^3 + ((44*c - 232)*b + (-8*d*c + 308*d))*a^2 + (-44*d*b^2 + (8*c^2 - 224*c + (-8*d^2 + 992))*b + (-8*d*c^2 + 120*d*c + (-8*d^3 - 904*d)))*a + ((44*c - 232)*b^3 + (8*d*c + 84*d)*b^2 + (8*c^3 - 108*c^2 + (8*d^2 + 600)*c + (12*d^2 - 1408))*b + (16*d*c^2 - 208*d*c + (16*d^3 + 928*d)))=0

48*d*a^3 + ((-48*c + 144)*b + (-64*d*c - 208*d))*a^2 + (48*d*b^2 + (64*c^2 - 160*c + (-64*d^2 - 96))*b + (28*d*c^2 + 216*d*c + (28*d^3 + 156*d)))*a + ((-48*c + 144)*b^3 + (64*d*c - 368*d)*b^2 + (-28*c^3 + 136*c^2 + (-28*d^2 - 348)*c + (352*d^2 + 576))*b + (-116*d*c^2 + 184*d*c + (-116*d^3 - 404*d)))=0

28*d*a^3 + ((-28*c + 188)*b + (88*d*c - 760*d))*a^2 + (28*d*b^2 + (-88*c^2 + 1272*c + (88*d^2 - 4544))*b + (52*d*c^2 - 1088*d*c + (52*d^3 + 5296*d)))*a + ((-28*c + 188)*b^3 + (-88*d*c + 512*d)*b^2 + (-52*c^3 + 1204*c^2 + (-52*d^2 - 9200)*c + (116*d^2 + 23168))*b + (-144*d*c^2 + 2304*d*c + (-144*d^3 - 9216*d)))=0



通过消除变量和迭代法，我先找到了b=0.63516174072319831898509931931955499049,d=0.46792352594682015606721097687421159730

然后求解得到c=3.8709182653664940247058425306984458486, a=5.0310740262024631642895158983869638355或0.35578906168827928945194111328112828445它们都只符合部分方程，看看大家能否帮忙找找看是否有实数解, 数值求解的难点在于我们需要避开b=d=0的平凡情况

==================

可以通过变换d=br替换，然后每条方程可以除以b,然后避开b=d=0情况。用数值法迭代好像无法找到a,b,c,r同时实数的情况。应该同初始数据相关。

---
换了组数据做测试，验证了上面的方案可行，比如选择如下四组点，每组四个点:



[0,0,1],[1,0,1],[0,1,1],[1,1,1]

[2,2,1],[2,3,1],[3,2,1],[3,3,1]

[4,4,1],[4,5,1],[5,4,1],[6,6,1]

[10,10,1],[11,11,1],[10,11,1]



我们假设有虚点$(a+bi, c+di)$和它的共轭点同每组的四个点都六点共圆锥曲线，并且设d=br,可以得到方程:

(-4*r*c + 2*r)*a^2 + (-4*r^2*b^2 + (4*c^2 + (4*r - 4)*c - 2*r))*a + ((4*r*c + (2*r^2 - 2*r))*b^2 + (-2*c^2 + 2*c))=0

(4*r*c - 10*r)*a^2 + (4*r^2*b^2 + (-4*c^2 + (-20*r + 20)*c + (50*r - 24)))*a + ((-4*r*c + (-10*r^2 + 10*r))*b^2 + (10*c^2 + (24*r - 50)*c + (-60*r + 60)))=0

-4*r*a^3 + ((16*r + 4)*c + (-20*r - 16))*a^2 + ((-4*r^3 + 16*r^2 - 4*r)*b^2 + ((-4*r - 16)*c^2 + (-112*r + 112)*c + (360*r - 192)))*a + (((4*r^2 - 16*r + 4)*c + (16*r^3 - 92*r^2 + 92*r - 16))*b^2 + (4*c^3 + (16*r + 20)*c^2 + (192*r - 360)*c + (-864*r + 864)))=0

(4*r*c - 42*r)*a^2 + (4*r^2*b^2 + (-4*c^2 + (-84*r + 84)*c + (882*r - 440)))*a + ((-4*r*c + (-42*r^2 + 42*r))*b^2 + (42*c^2 + (440*r - 882)*c + (-4620*r + 4620)))=0

我们可以通过数值法（牛顿迭代）找到几组实数解,比如[a,b,c,r]=

[3.3977035170695895892746281275100215092, 1.2095696424892583832474261333152633094, -0.34126823285394525048749673328351439472, 1.5306621354683455615906467453926368480]

[6.6083150028155415386948182258750703195, -0.024275721798213817304471274955574804557, 6.6083150028155415387552508321802243055, 1.0000000000000000000000000000000000000]

[3.3977035170695895892746281275100215092, -1.2095696424892583832474261333152633094, -0.34126823285394525048749673328351439472, 1.5306621354683455615906467453926368481]



取其中第一组，可以得到这四组点都可以和虚点$(3.3977035170695895892746281275100215092+1.2095696424892583832474261333152633094i,-0.34126823285394525048749673328351439472+1.8514424519702915249627830451131201330i)$及其共轭点确定圆锥曲线如图:

![](https://bbs.emath.ac.cn/data/attachment/forum/202211/09/200330gvsbasgasi4s44jy.png)


对应坐标方程:

x^2-x+2.2502984396849894757510607258767604052*y^2 - 2.2502984396849894757510607258767604052*y=0

x^2 - 5*x + (0.20641504661085802714202773907993901822*y^2 - 1.0320752330542901357101386953996950911*y + 7.2384902796651481628521664344796341093)=0

x^2 + (-0.51751553864970893444954132470608444132*y - 6.9299378454011642622018347011756622348)*x + (0.035031077299417868899082649412168882630*y^2 + 1.7547824589040749177064214541148178216*y + 12.420372927593014426788991792946026592)=0

x^2 - 21*x + (-0.42799566376720509964304800932967663725*y^2 + 8.9879089391113070925040081959232093824*y + 62.920476985607439039264718973735569900)=0



我们需要将虚点$(3.3977035170695895892746281275100215092+1.2095696424892583832474261333152633094i,-0.34126823285394525048749673328351439472+1.8514424519702915249627830451131201330i)$ 映射为虚圆点$(1,i,0)$，同时其共轭点映射为$(1,-i,0)$， 我们在加上约束条件变换保持(0,0,1), (1,0,1)不变，利用[链接](https://bbs.emath.ac.cn/forum.php?mod=redirect&goto=findpost&ptid=3953&pid=82371&fromuid=20)中计算方法，可以得到变换矩阵

[-1, 0.30469185648741416715476766528927951236, 0]

[0, -1.8913281181230178415750065410370865488, 0]

[0.38158353291439615467212523887276807783, -0.24929311575192315734302049841351603663, -1.3815835329143961546721252388727680778]

由此将上面圆锥曲线变换为

x^2+y^2-x-0.67544871555867683577169513262020712107*2*y=0

x^2+y^2-2*2.1171510815205749140321101529459489720*x-2*4.4141437221310586865025261856136175234*y+22.150077989349251499282581513542942265=0

x^2+y^2-2*0.74744558515194252015094028992137252984*x-2*15.719255161278792577340072102853639386*y+194.48421204411773560132642833478575214=0

x^2+y^2-2*15617.481802752951690068004138873436925*x+2*5718.9228242383352897882804282297807531*y-103407.45413472270552830847021773145316=0

对应四组点坐标转化为

[0,0,1], [1,0,1], [-0.18682703976207016151639617952867705935, 1.1597002873697944713909462289358480507,1], [0.55656125431708197418853161517470635357, 1.5139186266824718455600491742707080636,1]

[1.2449533817431600291551788547297097889, 3.3864342861684846631331853869688947378,1], [0.79479452336698431506486674960951712303, 4.1528227597653978048625702833421924553,1],  [3.2506853215210722979892680650441648033, 5.1435377439121673250049551342497790372,1], [2.1183085352758874858112799905239497390, 5.7620733095221545346435780034807917957,1]

[3.2627419481433368016194208581612562022, 8.8750802738027560330303013465936425565,1], [2.2478960189195233153044605376262428670, 8.5835635914418484523586811048637697357,1],  [8.0308511909126574421457439996425687647, 16.067749732267705857988307744672607565,1],  [7.0968997545211578725818759582981666453, 19.304485619020001843027993629945178424,1]

[118.49279341679442177689298347680667582, 322.31573019116911740433449558200361221,1], [-103.90272884896751209881481571123720378, -282.62886671944580879769087532683801230,1], [21.587609524407694901071931649621869162, 67.553469385329820031517242610746277143,1], [-24.629850382882953087005377745528997702, -58.572427497810882565065603263668676778,1]



上面求共轭虚点的pari/gp代码如下:

```
conx(X)=
{
    local(m);
    m=matrix(6,6);
    for(u=1,6,
         m[u,1]=X[u][1]*X[u][1];
         m[u,2]=X[u][2]*X[u][1];
         m[u,3]=X[u][2]*X[u][2];
         m[u,4]=X[u][1]*X[u][3];
         m[u,5]=X[u][2]*X[u][3];
         m[u,6]=X[u][3]*X[u][3];
    );
    matdet(m)
}
P1=conx([[0,0,1],[1,0,1],[0,1,1],[1,1,1],[a+b*I,c+b*r*I,1],[a-b*I,c-b*r*I,1]])/(b*I);
P2=conx([[2,2,1],[2,3,1],[3,2,1],[3,3,1],[a+b*I,c+b*r*I,1],[a-b*I,c-b*r*I,1]])/(b*I);
P3=conx([[4,4,1],[4,5,1],[5,4,1],[6,6,1],[a+b*I,c+b*r*I,1],[a-b*I,c-b*r*I,1]])/(b*I);
P4=conx([[10,10,1],[11,11,1],[10,11,1],[11,10,1],[a+b*I,c+b*r*I,1],[a-b*I,c-b*r*I,1]])/(b*I);
H11=deriv(P1,a);H12=deriv(P1,b);H13=deriv(P1,c);H14=deriv(P1,r);
H21=deriv(P2,a);H22=deriv(P2,b);H23=deriv(P2,c);H24=deriv(P2,r);
H31=deriv(P3,a);H32=deriv(P3,b);H33=deriv(P3,c);H34=deriv(P3,r);
H41=deriv(P4,a);H42=deriv(P4,b);H43=deriv(P4,c);H44=deriv(P4,r);
vapply(f,x)={
  subst(subst(subst(subst(f,a,x[1]),b,x[2]),c,x[3]),r,x[4])
}
iterf(x)={
    local(m);
    m=matrix(4,4);
    m[1,1]=vapply(H11,x); m[1,2]=vapply(H12,x); m[1,3]=vapply(H13,x); m[1,4]=vapply(H14,x);
    m[2,1]=vapply(H21,x); m[2,2]=vapply(H22,x); m[2,3]=vapply(H23,x); m[2,4]=vapply(H24,x);
    m[3,1]=vapply(H31,x); m[3,2]=vapply(H32,x); m[3,3]=vapply(H33,x); m[3,4]=vapply(H34,x);
    m[4,1]=vapply(H41,x); m[4,2]=vapply(H42,x); m[4,3]=vapply(H43,x); m[4,4]=vapply(H44,x);
    x-m^-1*[vapply(P1,x),vapply(P2,x),vapply(P3,x),vapply(P4,x)]~
}
genone()={
   local(x);
   x=vector(4)~;
   for(u=1,4, x[u]=random(200)-100.0);
   for(u=1,1000, x=iterf(x));
   x
}
```





===================

\(\begin{cases}143451r^6 - 1445256r^5 + 2819816r^4 - 2709866r^3 + 2819816r^2 - 1445256r + 143451=0\\

2521355742675r^5-26245123391808r^4+44846306763281r^3+53963393585191r^2\\-67977224798104r-53603603209827=-19706658745104c\\

-854055968689539r^5+8478577046022003r^4-15649755072930989r^3+14973546480184634r^2\\-16845680109446093r+7405983892652979=-37771095928116b^2\\

-\frac{5590675035099}{2189628749456}r^6+\frac{58700662713981}{2189628749456}r^5-\frac{396230081423371}{6568886248368}r^4\\+\frac{10315296251}{164123682}r^3-\frac{444649007775197}{6568886248368}r^2+\frac{337310120365633}{6568886248368}r\frac{-22873470451245}{2189628749456}=c-a\end{cases}\)





---
4#的图形13个点中5点确定的圆锥曲线（去除6点共曲线的）可以找到157中组合。

其中有公共3个虚交点的圆锥曲线最多只找到3条，比如ACDFG, AFJKL, CDEHI都交于$(\frac{-4+5\sqrt{3}i}7, -1+\sqrt{3}i)$

![](https://bbs.emath.ac.cn/data/attachment/forum/202211/11/093132rhiof1fqshhhfzez.png)


可以选择变换阵

\(S=\begin{pmatrix}-1&0.67857142857142857142857142857142857143&0\\

0&-0.061858957413174189054551655053781155962&0\\

-1.1666666666666666666666666666666666667&0.83333333333333333333333333333333333333&0.16666666666666666666666666666666666667\end{pmatrix}\)

变化后坐标如下:

A[1,0,0]=>[0.85714285714285714285714285714285714283,0]

B[0,0]=>[0,0]

C[1,4]=>[0.73469387755102040816326530612244897961,-0.10604392699401289552208855152076769594]

D[-1,-4]=>[0.85714285714285714285714285714285714287,-0.12371791482634837810910331010756231193]

E[1,0]=>[1,0]

F[-1,0]=>[0.75,0]

G[1,3,0]=>[0.77678571428571428571428571428571428574,-0.13918265417964192537274122387100760092]

H[1,1,0]=>[0.96428571428571428571428571428571428560,0.18557687223952256716365496516134346787]

I[0,1]=>[0.67857142857142857142857142857142857143,-0.061858957413174189054551655053781155962]

J[0,-1]=>[1.0178571428571428571428571428571428572,-0.092788436119761283581827482580671733944]

K[1,2]=>[0.53571428571428571428571428571428571432,-0.18557687223952256716365496516134346790]

L[-1,-2]=>[1.0714285714285714285714285714285714287,-0.37115374447904513432730993032268693582]

M[0,1,0]=>[0.81428571428571428571428571428571428572,-0.074230748895809026865461986064537387155]

对应图如下:

![](https://bbs.emath.ac.cn/data/attachment/forum/202211/11/093201v4qjvmivvkzsosdr.png)


这个对应14个点有9+3=12个5点圆。但是应该会有更好的解，比如从13点8线出发，是否可以找到5个以上5点圆。

---
2#分析到:



而由于10棵5条四点共线的情况下五条直线两两各自相交，任意三条直线不共点。在射影坐标系下可以任意指定四条直线的坐标。于是我们可以设定其中四条直线分别为无穷远直线，x=0,y=0,x+y=1, 然后假设余下直线方程为$x/u+y/v=1$, 需要注意这里u,v都不能为0（不然退化为直线x=0和y=0了). 同样u,v不能同时为1.

由此得到10个交点坐标为:

\(\begin{matrix}

1 & 2 & 3   & 4 & 5  &6&7& 8 &9&10\\

(0,1,0)&(1,0,0)&(1,-1,0)&(u,-v,0)&(0,0)&(0,1)&(0,v)&(1,0)&(u,0)&(u(1-v), -v(1-u),u-v)

\end{matrix}\)

其中坐标用三个维度表示（最后一个维度为0）的代表无穷远点。上面一排为点的编号。

对应五条直线经过点的编号为:

1 2 3 4

1 5 6 7

2 5 8 9

3 6 8 10

4 7 9 10

穷举上面的点，要求任意三点不共线的五点组只有下面12种组合(:之前为五点组编号，后面为对应5个点的编号)

0: 1 2 6 9 10

1: 1 2 7 8 10

2: 1 3 5 9 10

3: 1 3 7 8 9

4: 1 4 5 8 10

5: 1 4 6 8 9

6: 2 3 5 7 10

7: 2 3 6 7 9

8: 2 4 5 6 10

9: 2 4 6 7 8

10: 3 4 5 6 9

11: 3 4 5 7 8



我们的目标是选择上面五点组确定的圆锥曲线，将它们尽量多的同时投影成圆。

由于同时投影成圆要求两者之间至少有两个虚交点，所以它们之间实交点数目不能超过2. 我们把它们共享点的数目超过2的组合认为不可以同时出现的。

通过穷举，我们可以得到有最多133种不同的圆锥曲线组合。其中最多的组合包含6条圆锥曲线，最少的是空集。



另外如果我们任意置换5条直线之间的关系，这133中圆锥曲线组合之间也会进行相互转化。而能够相互转化的组合本质上是相同的。经过这种等价关系转化，我们可以发现只余下9种圆锥曲线组合

{ 0 3 4 6 9 10 }

{ 0 3 4 6 9 }

{ 0 3 4 6 }

{ 0 3 4 }

{ 0 3 6 }

{ 0 3 }

{ 0 11 }

{ 0 }

{ }

其中每个组合里面的数字代表对应圆锥曲线的编号（即5点组编号）。

所以如果我们能够证明组合{ 0 3 4 6 }不可以同时转化为圆，那么就可以证明这种方案没法找到额外4个圆。

而如果能够证明组合{ 0 3 4 }和{ 0 3 6 }都不可以同时转化为圆，那么就可以证明这种方案没法找到额外3个圆。即最多为11个点找到5+2=7个圆的方案，这样我们就得继续以10个点只有4条4点共线直线的模式出发来寻找了。

对于组合{ 0 3 4 6 }中任意一个圆锥曲线组合，比如0: 1 2 6 9 10

，如果存在一对公共的共轭虚数点$(a\pm bi,c\pm di)$.

我们可以通过要求圆锥曲线中任意四个点和两个共轭虚数点对6点共圆锥曲线的条件（5#方法）得到两条方程

由于我们总共有6个变量(坐标参数u,v和公共虚数点参数a,b,c,d), 而四个四点组总共提供8条方程，无解的可能性挺大的. (要求b,d,u,v均不为0; u,v不为1).



计算表明这8条方程依次为：

(-2*r*a + (2*r^2*b^2 + (2*c^2 - 2*c)))*u + (2*r*a^2 + 2*r*b^2)=0

((-2*r*a + (2*c - 2))*v^2 + (-2*r*a^2 + 4*r*a + ((-2*r^2 - 2*r)*b^2 + (-2*c^2 + 2)))*v + (2*r*a^2 - 2*r*a + ((2*r^2 + 2*r)*b^2 + (2*c^2 - 2*c))))*u + ((2*r*a^2 + ((2*r^2 + 2*r)*b^2 + (2*c^2 - 4*c + 2)))*v^2 + (-2*r*a^2 + ((-2*r^2 - 2*r)*b^2 + (-2*c^2 + 4*c - 2)))*v)=0

((2*r + 2)*a^2 + (-2*r - 4)*a + ((2*r + 2)*b^2 + (-2*c + 2)))*v + (-2*r*a^2 + (4*c + 2*r)*a + ((2*r^2 + 2*r)*b^2 + (2*c^2 - 2*c)))=0

(-2*r*a + (2*c + 2*r))*u + (2*r*a^2 + (-4*c - 2*r)*a + ((-2*r^2 - 2*r)*b^2 + (-2*c^2 + 2*c)))=0

(2*r^2*b^2 + 2*c^2)*u + (-2*r*a^2 + (4*c + 2*r)*a + (2*r*b^2 - 2*c))*v=0

((-2*r*a + 2*c)*v^2 + (-2*r*a^2 + 2*r*a + ((-2*r^2 - 2*r)*b^2 + (-2*c^2 - 2*c)))*v + (2*r^2*b^2 + 2*c^2))*u^3 + ((2*r*a - 2*c)*v^3 + ((4*r - 2)*a^2 + (-4*c - 2*r)*a + ((2*r^2 - 2)*b^2 + (2*c^2 + 2*c)))*v^2 + (4*c*a + ((-2*r^2 + 4*r)*b^2 - 2*c^2))*v)*u^2 + (((-2*r + 2)*a^2 + 4*c*a + (2*r + 2)*b^2)*v^3 + (2*a^2 - 4*c*a + (-4*r + 2)*b^2)*v^2)*u + (-2*a^2 - 2*b^2)*v^3=0

(-2*r*a + 2*c)*v + (2*r*a^2 + 4*r*c*a + ((2*r^2 + 2*r)*b^2 - 2*c^2))=0

((2*r*a^2 + (4*r*c - 2*r)*a + ((2*r^3 + 4*r^2 + 2*r)*b^2 + (2*r*c^2 + 2*c)))*v + ((-2*r^3 - 2*r^2)*b^2 + (-2*r - 2)*c^2))*u^2 + ((-2*r*a^2 + (-4*r*c + 2*r)*a + ((-2*r^3 - 4*r^2 - 2*r)*b^2 + (-2*r*c^2 - 2*c)))*v^2 + (-2*r*a^2 + (-4*r*c + 2*r)*a + ((2*r^3 - 2*r)*b^2 + ((2*r + 4)*c^2 - 2*c)))*v)*u + (2*r*a^2 + (4*r*c - 2*r)*a + ((2*r^2 + 2*r)*b^2 + (-2*c^2 + 2*c)))*v^2=0



数值计算对于前6条方程，或者前4条加最后两条，都没能找到符合条件的解。

==================

使用Singular求解， 8条方程都符合的解有

v=r=c=0 or v=u=b=a=c=0 or v=u=a=1,b=c=0 or u=1,r=c=0,a^2+b^2-2a+1=0 or u=v=1,r=c=0,a^2+b^2-2a+1=0

or u=v=a=1,r=-1,c=0 or c=r=0,v=1,a=1/2,4b^2+1=0 or u=v=r=c=0,a=1/2,4b^2+1=0

or u=v=a=1,r=-1,c=0,b^4-b^2-1=0 or

u=v=1,r=-1,a+c=1 or u=r=c=1,a+c-1=0 or u=v=0,cr+c-r=0,b^2+c^2-2c+1=0,a+c-1=0

or u=v=1,b=c=0,a+c-1=0 or b=c=r=0,u=1,a+c-1=0 or v=1,r=-1,2c-1=0,4b^2+1=0,a+c-1=0

or r=c=b=0,u=v=1,a+c-1=0 or u=v=1,r=-1,2c-1=0,4b^2+1=0,a+c-1=0 or

a^2+b^2=0 or a^2+b^2-2a+1=0 or

b^4+2b^2c^2+c^4-b^2-c^2+2c-1=0, a+c-1=0, v^2-v=0,uv+v^2-2v=0,... or

c=0,a=1/2, r=0, 2uv^2+rv-2uv-2v^2+2v=0, (4b^2+1)v=0,4b^2r+4b^2v-2rv+r+v=0 or

u=v=1,3r+2u+2v-1=0,c=1/2,a=1/3,4b^2=3

没有一组解符合我们的要求. 所以这种方案没有额外四圆方案。而类似可以得出0,3,4组合没有符合要求的解。

而0，3，6组合消元后要求$2v^4u^2-2v^4u+v^4-2v^3u^3-6v^3u^2+6v^3u-2v^3+2v^2u^4+4v^2u^3+3v^2u^2-4v^2u+v^2-2vu^4-4vu^3+2vu^2+u^4=0$

通过分析这个函数的极值可以知道只有极值点(0,0),(0,1),(1,1),(0.629867545600498058804212092905,0.750779906015520373733441944251),(0.249220093984479626266558055749,0.370132454399501941195787907095),函数在这些极值点取值都不小于0.而且函数最高次项对应$2v^4u^2-2v^3u^3+2v^2u^4=2u^2v^2(u^2-vu+v^2)$正定，所以多项式在u或v趋向无穷时恒大于0.也就是说明多项式永远非负。

![](https://bbs.emath.ac.cn/data/attachment/forum/202211/13/133315wj4h8dplzrzddb7j.png)


这说明{0,3,6}组合也不可以。这种方案最多额外两个圆，总共最多7个圆。

==================



上面问题无法找到3个圆，那么我们就需要从10个点只有4行每行正好4个点的构造方案开始（11个点中将任意一个反演到无穷远，余下点都只能构成4行，每行4个点）。

穷举可以知道10个点有4行，每行4个点的构造方案为5行方案删除任何一行，也就是四条直线两两相交于不同的点，得出每条直线上3个交点共六个点。然后每条直线上再各自独立添加一个自由的点。

由于通过射影变换可以将4条直线映射成任意指定的直线，所以可以设这四条直线为 无穷远直线,x=0,y=0,x+y=1.然后再每条直线上各自选择一个点，得出10个点坐标的参数形式为:

\(\begin{matrix}   1&2& 3&4&5&6&7&8&9&10\\

(0,1,0)&(1,0,0)&(1,-1,0)&(0,0)&(0,1)& (1,0)& (u,0)& (0,v)& (1,w,0)&(t,1-t)\end{matrix}\)

对应四条直线（各自包含四个点）包含点的编号如下：

1 2 3 9

1 4 5 8

2 4 6 7

3 5 6 10



同样可以穷举它们5个点构成的圆锥曲线候选集有42条可选圆锥曲线（任意三点不共线）

而其中4条两两最多包含2两个已知点的圆锥曲线组合在等价关系下（置换四条直线位置可以相互转为的为等价关系）只有6种可能:

0:1 2 5 7 10

4:1 3 6 7 8

6:1 4 6 9 10

15:2 3 4 8 10

19:2 4 8 9 10

20:2 5 6 8 9

25:2 6 8 9 10

27:3 4 5 7 9

31:3 4 7 9 10

38:4 7 8 9 10

{ 0 4 6 15 }

(-2*r*a + (2*r^2*b^2 + (2*c^2 - 2*c)))*u + (2*r*a^2 + 2*r*b^2)=0

(-2*r*a + (2*c - 2))*t + (2*r*a^2 + ((2*r^2 + 2*r)*b^2 + (2*c^2 - 4*c + 2)))=0

(-2*v + (-2*r*a + 2*c))*u^2 + (((2*r + 4)*a + 2*c)*v + (2*r*a^2 - 4*c*a + ((-2*r^2 - 2*r)*b^2 - 2*c^2)))*u + ((-2*r - 2)*a^2 + (-2*r - 2)*b^2)*v=0

((-2*r - 2)*a^2 + (2*r + 4)*a + ((-2*r - 2)*b^2 + (2*c - 2)))*v + (2*r*a^2 + (-4*c - 2*r)*a + ((-2*r^2 - 2*r)*b^2 + (-2*c^2 + 2*c)))=0

(-2*r*a + 2*c)*v + (2*r*a^2 + 4*r*c*a + ((2*r^2 + 2*r)*b^2 - 2*c^2))=0

(-2*r*a^2 + (-4*r*c + 2*r)*a + ((-2*r^3 - 4*r^2 - 2*r)*b^2 + (-2*r*c^2 - 2*c)))*t + (2*r*a^2 + (4*r*c - 2*r)*a + ((2*r^2 + 2*r)*b^2 + (-2*c^2 + 2*c)))=0

(2*r*a^2 + (-4*c - 2*r)*a + (-2*r*b^2 + 2*c))*w + (2*r^2*b^2 + 2*c^2)=0

(-2*r*a^2 + (4*c + 2*r)*a + ((2*r^2 + 2*r)*b^2 + (2*c^2 - 2*c)))*t^2 + (2*r*a^3 - 2*c*a^2 + (2*r*b^2 + (-4*c - 2*r))*a + ((-2*c + (-2*r^2 - 4*r))*b^2 + (-2*c^2 + 2*c)))*t + (-2*r*a^3 + (2*c + 2*r)*a^2 - 2*r*b^2*a + (2*c + 2*r)*b^2)=0

上面这个第一组方程经计算无实数解。



{ 0 4 6 20 }

(-2*r*a + (2*r^2*b^2 + (2*c^2 - 2*c)))*u + (2*r*a^2 + 2*r*b^2)=0

(-2*r*a + (2*c - 2))*t + (2*r*a^2 + ((2*r^2 + 2*r)*b^2 + (2*c^2 - 4*c + 2)))=0

(-2*v + (-2*r*a + 2*c))*u^2 + (((2*r + 4)*a + 2*c)*v + (2*r*a^2 - 4*c*a + ((-2*r^2 - 2*r)*b^2 - 2*c^2)))*u + ((-2*r - 2)*a^2 + (-2*r - 2)*b^2)*v=0

((-2*r - 2)*a^2 + (2*r + 4)*a + ((-2*r - 2)*b^2 + (2*c - 2)))*v + (2*r*a^2 + (-4*c - 2*r)*a + ((-2*r^2 - 2*r)*b^2 + (-2*c^2 + 2*c)))=0

(-2*r*a^2 + 2*r*a + ((-2*r^2 - 2*r)*b^2 + (-2*c^2 + 2*c)))*v^2 + (2*r*a^2 + (-2*r^3*b^2 + (-2*r*c^2 - 2*r))*a + ((2*r^2*c + 2*r)*b^2 + (2*c^3 - 2*c)))*v + ((2*r^3*b^2 + 2*r*c^2)*a + ((-2*r^2*c + 2*r^2)*b^2 + (-2*c^3 + 2*c^2)))=0

(-2*r*a^2 + 2*r*a + ((-2*r^2 - 2*r)*b^2 + (-2*c^2 + 2*c)))*w^2 + ((4*r*c - 2*r)*a + ((2*r^3 + 2*r^2)*b^2 + ((2*r - 2)*c^2 + (-4*r + 2)*c + 2*r)))*w=0

(2*r*a^2 + (-4*c - 2*r)*a + (-2*r*b^2 + 2*c))*w + (2*r^2*b^2 + 2*c^2)=0

(-2*r*a^2 + (4*c + 2*r)*a + ((2*r^2 + 2*r)*b^2 + (2*c^2 - 2*c)))*t^2 + (2*r*a^3 - 2*c*a^2 + (2*r*b^2 + (-4*c - 2*r))*a + ((-2*c + (-2*r^2 - 4*r))*b^2 + (-2*c^2 + 2*c)))*t + (-2*r*a^3 + (2*c + 2*r)*a^2 - 2*r*b^2*a + (2*c + 2*r)*b^2)=0

这个方程经计算需要$c^2-2c+1+d^2=0$,所以在实数范围表示c=1,d=0, 这个表示两个虚圆点$(a\pm bi, c\pm di)$和第五个点(0,1)都在直线y=1上。将两个虚圆点映射到无穷远直线后会导致第五个点也跑到无穷远直线上，不符合要求。



{ 0 4 19 27 }

(-2*r*a + (2*r^2*b^2 + (2*c^2 - 2*c)))*u + (2*r*a^2 + 2*r*b^2)=0

(-2*r*a + (2*c - 2))*t + (2*r*a^2 + ((2*r^2 + 2*r)*b^2 + (2*c^2 - 4*c + 2)))=0

(-2*v + (-2*r*a + 2*c))*u^2 + (((2*r + 4)*a + 2*c)*v + (2*r*a^2 - 4*c*a + ((-2*r^2 - 2*r)*b^2 - 2*c^2)))*u + ((-2*r - 2)*a^2 + (-2*r - 2)*b^2)*v=0

((-2*r - 2)*a^2 + (2*r + 4)*a + ((-2*r - 2)*b^2 + (2*c - 2)))*v + (2*r*a^2 + (-4*c - 2*r)*a + ((-2*r^2 - 2*r)*b^2 + (-2*c^2 + 2*c)))=0

(-2*r*a^2 + (-4*r*c + 2*r)*a + ((-2*r^2 - 2*r)*b^2 + (2*c^2 - 2*c)))*u^2 + (2*r*a^3 + ((4*r - 2)*c - 2*r)*a^2 + ((2*r^3 + 4*r^2 + 2*r)*b^2 + ((2*r - 4)*c^2 + 4*c))*a + (((-2*r^2 - 4*r - 2)*c + (2*r^2 + 2*r))*b^2 + (-2*c^3 + 2*c^2)))*u=0

((2*r + 2)*a^2 + (2*r + 2)*b^2)*w^2 + (2*a^2 + (-4*r*c + 2*r)*a + ((-2*r^2 + 2)*b^2 + (2*c^2 - 2*c)))*w + (-2*r*a^2 + (-4*r*c + 2*r)*a + ((-2*r^2 - 2*r)*b^2 + (2*c^2 - 2*c)))=0

(2*r*a - 2*c)*w*v^2 + ((2*r*a^2 + 2*r*b^2)*w^2 + (-4*r*c*a + (-2*r^2*b^2 + 2*c^2))*w)*v=0

((-2*r*a + 2*c)*t^2 + (2*r*a^2 + 2*r*a + ((2*r^2 + 2*r)*b^2 + (2*c^2 - 2*c)))*t + (-2*r*a^2 - 2*r*b^2))*v^2 + ((2*r*a^2 + 4*r*c*a + ((2*r^2 + 2*r)*b^2 - 2*c^2))*t^2 + (-4*r*a^2 + (2*r^3*b^2 + (2*r*c^2 - 4*r*c))*a + ((-2*r^2*c + (-2*r^2 - 4*r))*b^2 + (-2*c^3 + 2*c^2)))*t + (2*r*a^2 + 2*r*b^2))*v=0

经计算，方程的解要求$c^2+d^2=0$,所以在实数方位要求c=0,d=0. 这个表示两个虚圆点$(a\pm bi, c\pm di)$和第六个点(1,0)和第7个点(u,0)都在直线y=0上. 将两个虚圆点映射到无穷远直线后会导致第六，第七个点也跑到无穷远直线上，不符合要求。





{ 0 4 20 31 }

(-2*r*a + (2*r^2*b^2 + (2*c^2 - 2*c)))*u + (2*r*a^2 + 2*r*b^2)=0

(-2*r*a + (2*c - 2))*t + (2*r*a^2 + ((2*r^2 + 2*r)*b^2 + (2*c^2 - 4*c + 2)))=0

(-2*v + (-2*r*a + 2*c))*u^2 + (((2*r + 4)*a + 2*c)*v + (2*r*a^2 - 4*c*a + ((-2*r^2 - 2*r)*b^2 - 2*c^2)))*u + ((-2*r - 2)*a^2 + (-2*r - 2)*b^2)*v=0

((-2*r - 2)*a^2 + (2*r + 4)*a + ((-2*r - 2)*b^2 + (2*c - 2)))*v + (2*r*a^2 + (-4*c - 2*r)*a + ((-2*r^2 - 2*r)*b^2 + (-2*c^2 + 2*c)))=0

((-2*r*a^2 + (-4*r*c + 2*r)*a + ((-2*r^3 - 4*r^2 - 2*r)*b^2 + (-2*r*c^2 - 2*c)))*t + (2*r*a^2 + (4*r*c - 2*r)*a + ((2*r^2 + 2*r)*b^2 + (-2*c^2 + 2*c))))*u^2 + ((2*r*a^3 + ((4*r - 2)*c - 2*r)*a^2 + ((2*r^3 + 4*r^2 + 2*r)*b^2 + ((2*r - 4)*c^2 + 4*c))*a + (((-2*r^2 - 4*r - 2)*c + (2*r^3 + 4*r^2 + 2*r))*b^2 + (-2*c^3 + (2*r + 4)*c^2)))*t + (-2*r*a^3 + ((-4*r + 2)*c + 2*r)*a^2 + ((-2*r^3 - 4*r^2 - 2*r)*b^2 + ((-2*r + 4)*c^2 - 4*c))*a + (((2*r^2 + 4*r + 2)*c + (-2*r^2 - 2*r))*b^2 + (2*c^3 - 2*c^2))))*u=0

((-2*r*a + 2*c)*w^2 + (-2*r*a + 2*c)*w)*u^2 + ((2*r*a^2 - 4*c*a + ((-2*r^2 - 2*r)*b^2 - 2*c^2))*w^2 + (2*r*a^2 - 4*c*a + ((2*r^3 - 2*r)*b^2 + 2*r*c^2))*w + ((2*r^3 + 2*r^2)*b^2 + (2*r + 2)*c^2))*u=0

(-2*r*a^2 + 2*r*a + ((-2*r^2 - 2*r)*b^2 + (-2*c^2 + 2*c)))*w^2 + ((4*r*c - 2*r)*a + ((2*r^3 + 2*r^2)*b^2 + ((2*r - 2)*c^2 + (-4*r + 2)*c + 2*r)))*w=0

(-2*r*a^2 + 2*r*a + ((-2*r^2 - 2*r)*b^2 + (-2*c^2 + 2*c)))*v^2 + (2*r*a^2 + (-2*r^3*b^2 + (-2*r*c^2 - 2*r))*a + ((2*r^2*c + 2*r)*b^2 + (2*c^3 - 2*c)))*v + ((2*r^3*b^2 + 2*r*c^2)*a + ((-2*r^2*c + 2*r^2)*b^2 + (-2*c^3 + 2*c^2)))=0

经计算得到$c=1,d=0,r=1,t=2a$等，这个表示两个虚圆点$(a\pm bi, c\pm di)$和第五个点(0,1)都在直线y=1上。将两个虚圆点映射到无穷远直线后会导致第五个点也跑到无穷远直线上，不符合要求。



{ 0 4 20 38 }

(-2*r*a + (2*r^2*b^2 + (2*c^2 - 2*c)))*u + (2*r*a^2 + 2*r*b^2)=0

(-2*r*a + (2*c - 2))*t + (2*r*a^2 + ((2*r^2 + 2*r)*b^2 + (2*c^2 - 4*c + 2)))=0

(-2*v + (-2*r*a + 2*c))*u^2 + (((2*r + 4)*a + 2*c)*v + (2*r*a^2 - 4*c*a + ((-2*r^2 - 2*r)*b^2 - 2*c^2)))*u + ((-2*r - 2)*a^2 + (-2*r - 2)*b^2)*v=0

((-2*r - 2)*a^2 + (2*r + 4)*a + ((-2*r - 2)*b^2 + (2*c - 2)))*v + (2*r*a^2 + (-4*c - 2*r)*a + ((-2*r^2 - 2*r)*b^2 + (-2*c^2 + 2*c)))=0

(((-2*r*a + 2*c)*t^2 + (2*r*a^2 + 2*r*a + ((2*r^2 + 2*r)*b^2 + (2*c^2 - 2*c)))*t + (-2*r*a^2 - 2*r*b^2))*v + ((2*r*a^2 + 4*r*c*a + ((2*r^2 + 2*r)*b^2 - 2*c^2))*t^2 + (-4*r*a^2 + (2*r^3*b^2 + (2*r*c^2 - 4*r*c))*a + ((-2*r^2*c + (-2*r^2 - 4*r))*b^2 + (-2*c^3 + 2*c^2)))*t + (2*r*a^2 + 2*r*b^2)))*u^2 + (((2*r*a^2 - 4*c*a + ((-2*r^2 - 2*r)*b^2 - 2*c^2))*t^2 + (-2*r*a^3 + (2*c - 2*r)*a^2 + (-2*r*b^2 + 4*c)*a + (2*c + 2*r)*b^2)*t + (2*r*a^3 - 2*c*a^2 + 2*r*b^2*a - 2*c*b^2))*v + ((-2*r*a^3 + (-4*r + 2)*c*a^2 + ((-2*r^3 - 4*r^2 - 2*r)*b^2 + (-2*r + 4)*c^2)*a + ((2*r^2 + 4*r + 2)*c*b^2 + 2*c^3))*t^2 + (4*r*a^3 + (4*r - 4)*c*a^2 + ((4*r^2 + 4*r)*b^2 - 4*c^2)*a + (-4*r - 4)*c*b^2)*t + (-2*r*a^3 + 2*c*a^2 - 2*r*b^2*a + 2*c*b^2)))*u=0

((2*r*a - 2*c)*w*v^2 + ((2*r*a^2 + 2*r*b^2)*w^2 + (-4*r*c*a + (-2*r^2*b^2 + 2*c^2))*w)*v)*u^2 + (((-2*r*a^2 + 4*c*a + 2*r*b^2)*w + (-2*r^2*b^2 - 2*c^2))*v^2 + ((-2*r*a^3 + 2*c*a^2 - 2*r*b^2*a + 2*c*b^2)*w^2 + (4*r*c*a^2 + (4*r^2*b^2 - 4*c^2)*a - 4*r*c*b^2)*w + ((-2*r^3*b^2 - 2*r*c^2)*a + (2*r^2*c*b^2 + 2*c^3)))*v)*u=0

(-2*r*a^2 + 2*r*a + ((-2*r^2 - 2*r)*b^2 + (-2*c^2 + 2*c)))*w^2 + ((4*r*c - 2*r)*a + ((2*r^3 + 2*r^2)*b^2 + ((2*r - 2)*c^2 + (-4*r + 2)*c + 2*r)))*w=0

(-2*r*a^2 + 2*r*a + ((-2*r^2 - 2*r)*b^2 + (-2*c^2 + 2*c)))*v^2 + (2*r*a^2 + (-2*r^3*b^2 + (-2*r*c^2 - 2*r))*a + ((2*r^2*c + 2*r)*b^2 + (2*c^3 - 2*c)))*v + ((2*r^3*b^2 + 2*r*c^2)*a + ((-2*r^2*c + 2*r^2)*b^2 + (-2*c^3 + 2*c^2)))=0

这个方程经计算需要$c^2-2c+1+d^2=0$,所以在实数范围表示c=1,d=0, 这个表示两个虚圆点$(a\pm bi, c\pm di)$和第五个点(0,1)都在直线y=1上。将两个虚圆点映射到无穷远直线后会导致第五个点也跑到无穷远直线上，不符合要求。



{ 0 4 25 31 }

(-2*r*a + (2*r^2*b^2 + (2*c^2 - 2*c)))*u + (2*r*a^2 + 2*r*b^2)=0

(-2*r*a + (2*c - 2))*t + (2*r*a^2 + ((2*r^2 + 2*r)*b^2 + (2*c^2 - 4*c + 2)))=0

(-2*v + (-2*r*a + 2*c))*u^2 + (((2*r + 4)*a + 2*c)*v + (2*r*a^2 - 4*c*a + ((-2*r^2 - 2*r)*b^2 - 2*c^2)))*u + ((-2*r - 2)*a^2 + (-2*r - 2)*b^2)*v=0

((-2*r - 2)*a^2 + (2*r + 4)*a + ((-2*r - 2)*b^2 + (2*c - 2)))*v + (2*r*a^2 + (-4*c - 2*r)*a + ((-2*r^2 - 2*r)*b^2 + (-2*c^2 + 2*c)))=0

((-2*r*a^2 + (-4*r*c + 2*r)*a + ((-2*r^3 - 4*r^2 - 2*r)*b^2 + (-2*r*c^2 - 2*c)))*t + (2*r*a^2 + (4*r*c - 2*r)*a + ((2*r^2 + 2*r)*b^2 + (-2*c^2 + 2*c))))*u^2 + ((2*r*a^3 + ((4*r - 2)*c - 2*r)*a^2 + ((2*r^3 + 4*r^2 + 2*r)*b^2 + ((2*r - 4)*c^2 + 4*c))*a + (((-2*r^2 - 4*r - 2)*c + (2*r^3 + 4*r^2 + 2*r))*b^2 + (-2*c^3 + (2*r + 4)*c^2)))*t + (-2*r*a^3 + ((-4*r + 2)*c + 2*r)*a^2 + ((-2*r^3 - 4*r^2 - 2*r)*b^2 + ((-2*r + 4)*c^2 - 4*c))*a + (((2*r^2 + 4*r + 2)*c + (-2*r^2 - 2*r))*b^2 + (2*c^3 - 2*c^2))))*u=0

((-2*r*a + 2*c)*w^2 + (-2*r*a + 2*c)*w)*u^2 + ((2*r*a^2 - 4*c*a + ((-2*r^2 - 2*r)*b^2 - 2*c^2))*w^2 + (2*r*a^2 - 4*c*a + ((2*r^3 - 2*r)*b^2 + 2*r*c^2))*w + ((2*r^3 + 2*r^2)*b^2 + (2*r + 2)*c^2))*u=0

(-2*r*a + (2*c + 2*r))*w*v^2 + ((-2*r*a^2 + 2*r*a + (-2*r*b^2 + 2*c))*w^2 + (4*r*c*a + (2*r^2*b^2 + (-2*c^2 - 4*r*c)))*w)*v + ((-2*r^2*b^2 - 2*c^2)*w^2 + (2*r^3*b^2 + 2*r*c^2)*w)=0

((-2*r*a + (2*c + 2*r))*t^2 + (2*r*a^2 + ((2*r^2 + 2*r)*b^2 + (2*c^2 - 4*c - 2*r)))*t + (-2*r*a^2 + 2*r*a + ((-2*r^2 - 2*r)*b^2 + (-2*c^2 + 2*c))))*v^2 + ((2*r*a^2 + (4*r*c - 2*r)*a + ((2*r^2 + 2*r)*b^2 + (-2*c^2 + (-4*r - 2)*c)))*t^2 + (-4*r*a^2 + (2*r^3*b^2 + (2*r*c^2 - 4*r*c + 4*r))*a + ((-2*r^2*c + (-2*r^2 - 4*r))*b^2 + (-2*c^3 + 2*c^2 + (4*r + 4)*c)))*t + (2*r*a^2 + (-2*r^3*b^2 + (-2*r*c^2 - 2*r))*a + ((2*r^2*c + 2*r)*b^2 + (2*c^3 - 2*c))))*v + (((2*r^3 + 2*r^2)*b^2 + (2*r + 2)*c^2)*t^2 + ((-2*r^3*b^2 - 2*r*c^2)*a + ((2*r^2*c + (-2*r^3 - 4*r^2))*b^2 + (2*c^3 + (-2*r - 4)*c^2)))*t + ((2*r^3*b^2 + 2*r*c^2)*a + ((-2*r^2*c + 2*r^2)*b^2 + (-2*c^3 + 2*c^2))))=0

经计算要求$c^2+d^2=0$,也就是c=d=0,同样不符合要求。



上面列表中上面是被使用到的圆锥曲线列表，:前面为编号，后面为5个点的编号。下面{}内为这6种圆锥曲线组合，每个里面包含4条圆锥曲线。

对于每个组合，4条圆锥曲线代表8条方程，而我们的坐标中有4个参数（u,v,w,h）,在加上虚点坐标四个参数a,b,c,d。

上面都无解，说明11个点最多有且只有7个五点圆。

---




查找网络，平面上8棵树，每行3棵，最多7行，而且在射影变化下只有一种配置，但是其中有一个自由度（其中一个点可以选择在一条直线上自由移动），利用这个信息，写代码穷举这种配置下再添加8个四点圆，通过Singular过滤，验证无法再添加8个四点圆(103种情况都无实数解).

[https://github.com/emathgroup/se ... tached/files/n7.tgz](https://github.com/emathgroup/selectedTopics/blob/master/content/attached/files/n7.tgz)

由此验证9棵树，最多14个四点圆。

14个共点圆必然可以通过8棵树，每行3棵，7行构图添加额外7个四点圆得到

[https://github.com/emathgroup/se ... tached/files/n8.tgz](https://github.com/emathgroup/selectedTopics/blob/master/content/attached/files/n8.tgz)

上面链接中提供了所有可能的解。有很多合法的解，但是其中还包含一些非法的结果(比如只有非实数解，或者必然k=-1等)

其中被文件ce7.err列出的才可能有解，比如f50.7.out （13个点射影坐标参考f50.7)。其中我们需要将点(a+bi,c+di)和其共轭点通过射影变换转化为虚圆点(1,i,0)和(1,-i,0).

当然我们还需要验算这13个点都不在两个虚点构成的直线上（不然会被映射到无穷远，不符合要求）

f50.7.out中有解

_[1]=c-1

_[2]=a2k+b2k-1

_[3]=d

于是我们可以选择d=0,c=1,a^2+b^2=1/k, 取k=1,a=3/5,b=4/5, 各点坐标为

list n1=0,0,1;

list n2=1,0,1;

list n3=0,1,1;

list n4=2,1,1;

list n5=1,2,1;

list n6=1,0,0;

list n7=1,1,0;

list n8=0,1,0;

虚点为(3/5+4i/5, 1,1)和(3/5-4i/5,1,1),但是n6=1,0,0在这两个虚点连接的直线上，所以需要淘汰,实际上任意选择k都不行。

看来这种不期望的三点共线也需要淘汰一下。







---
我的哥，完全看不懂你写的。

---